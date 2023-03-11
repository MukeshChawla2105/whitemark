public class GetWondersoftInventory  implements Queueable, Database.AllowsCallouts{
    //Get Token parameters
    Private static Endpoints__C msg = Endpoints__C.getValues('WondersoftToken');
    Private static Endpoints__C invMsg = Endpoints__C.getValues('WondersoftInventoryData');
    
    Private static String EP = msg.EndpointURL__c;
    Private static String invEP = invMsg.EndpointURL__c;
    Private static String UN = msg.User_Name__c;
    Private static String PW = msg.Password__c;
    Private static String SMN = msg.Service_MethodName__c;
    Private static String invSMN = invMsg.Service_MethodName__c;
    
    Private String FromDate;
    Private String ToDate;
    
    
    
    public GetWondersoftInventory(String FD,String TD){
        this.FromDate= FD;
        this.ToDate= TD;
    }
    
    public void execute( QueueableContext qc ){
        
        //Variables
        String curAuthToken;
        JSONFranchiseeInventory parsedJSON= New JSONFranchiseeInventory();
        //Processing variables
        Map<String, Product2> sourceProdMap= new  Map<String, Product2>();
        List<Product2> prodListToInsert= New  List<Product2>();
        
        List<Product2> prodList= [SELECT Brand__c,Description,Family,Id,IsActive,MRP__c,Name,SAP_Code__c FROM Product2];
        for(Product2 curProd: prodList){
            sourceProdMap.Put(curProd.SAP_Code__c, curProd);
        }
        system.debug('sourceProdMap -- >'+ sourceProdMap);
        
        GetWondersoftToken tk= new GetWondersoftToken();
        HttpResponse authResponse = tk.GetWondersoftTokenDetails(EP,UN,PW,SMN);
        
        // Parse the JSON response
        if (authResponse.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         authResponse.getStatusCode() + ' ' + authResponse.getStatus());
        } else {
            System.debug(authResponse.getBody());
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(authResponse.getBody());
            Map<String, Object> resultsToken=  (Map<String, Object>) results.get('Response');
            
            curAuthToken= (String) resultsToken.get('Access_Token');
            system.debug('curAuthToken --->  '+ curAuthToken);
            
            //Get Sales Data
            String Auth=curAuthToken;
            
            GetWondersoftData wd= new GetWondersoftData();
            HttpResponse res= wd.GetWSData(invEP,Auth,invSMN,FromDate,ToDate);
            system.debug('Sales Data Body ---> '+ res.getbody());
            String jsonBody= res.getbody();
            
            jsonBody= jsonBody.replace('"Items":{"Item":{','"Items_Z":{"Item":{');
            
            JSONFranchiseeInventory invResponse = JSONFranchiseeInventory.parse(jsonBody);
            parsedJSON=invResponse;
            
            for(Integer i=0;i<invResponse.Response.Data.Inventory.size();i++){
                if(invResponse.Response.Data.Inventory[i].Items != null){
                    for(Integer j=0;j<invResponse.Response.Data.Inventory[i].Items.Item.size();j++){
                        if(sourceProdMap.get(invResponse.Response.Data.Inventory[i].Items.Item[j].ItemCode) == Null){
                            Product2 tempProd= New Product2();
                            tempProd.Description= invResponse.Response.Data.Inventory[i].Items.Item[j].ItemName;
                            tempProd.Name= invResponse.Response.Data.Inventory[i].Items.Item[j].ItemName;
                            tempProd.SAP_Code__c= invResponse.Response.Data.Inventory[i].Items.Item[j].ItemCode;
                            tempProd.ProductCode= invResponse.Response.Data.Inventory[i].Items.Item[j].ItemName;
                            tempProd.IsActive= true;
                            tempProd.MRP__c= Decimal.valueOf(invResponse.Response.Data.Inventory[i].Items.Item[j].MRP);
                            prodListToInsert.add(tempProd);
                        }
                    }
                }
                if(invResponse.Response.Data.Inventory[i].Items_Z != null){
                    if(sourceProdMap.get(invResponse.Response.Data.Inventory[i].Items_Z.Item.ItemCode) == Null){
                        Product2 tempProd1= New Product2();
                        tempProd1.Description= invResponse.Response.Data.Inventory[i].Items_Z.Item.ItemName;
                        tempProd1.Name= invResponse.Response.Data.Inventory[i].Items_Z.Item.ItemName;
                        tempProd1.SAP_Code__c= invResponse.Response.Data.Inventory[i].Items_Z.Item.ItemCode;
                        tempProd1.ProductCode= invResponse.Response.Data.Inventory[i].Items_Z.Item.ItemName;
                        tempProd1.IsActive= true;
                        tempProd1.MRP__c= Decimal.valueOf(invResponse.Response.Data.Inventory[i].Items_Z.Item.MRP);
                        prodListToInsert.add(tempProd1);
                        system.debug('ItemZ product ---> '+ tempProd1);
                    }
                }
            }
            system.debug('Temp Product to Insert --> '+ prodListToInsert); 
        }
        If(prodListToInsert.size()>0){
            Database.SaveResult[] srList = Database.insert(prodListToInsert,false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Product. Product ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Product fields that affected this error: ' + err.getFields());
                    }  
                }
            }
        }
        if(!Test.isRunningTest()){
            System.enqueueJob(new ProcessWSFranchiseeData(parsedJSON));
        }
        
    }
}