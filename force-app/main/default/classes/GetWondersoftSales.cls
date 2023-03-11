public class GetWondersoftSales implements Queueable, Database.AllowsCallouts{
    //Get Token parameters
    Private static Endpoints__C msg = Endpoints__C.getValues('WondersoftToken');
    Private static Endpoints__C invMsg = Endpoints__C.getValues('WondersoftPullSales');
    
    Private static String EP = msg.EndpointURL__c;
    Private static String salesEP = invMsg.EndpointURL__c;
    Private static String UN = msg.User_Name__c;
    Private static String PW = msg.Password__c;
    Private static String SMN = msg.Service_MethodName__c;
    Private static String salesSMN = invMsg.Service_MethodName__c;
    
    Private String FromDate;
    Private String ToDate;
    Private String CallType;    
    public GetWondersoftSales(String FD,String TD, String CT){
        this.FromDate= FD;
        this.ToDate= TD;
        this.CallType= CT;
    }
    
    public void execute( QueueableContext qc ){
        //Variables
        String curAuthToken;
        JSONSales parsedJSON= New JSONSales();
        
        GetWondersoftToken tk= new GetWondersoftToken();
        HttpResponse authResponse = tk.GetWondersoftTokenDetails(EP,UN,PW,SMN);
        
        // Parse the JSON response
        if (authResponse.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         authResponse.getStatusCode() + ' ' + authResponse.getStatus());
        } else {
            System.debug('Inside else --> '+ authResponse.getBody());
            
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(authResponse.getBody());
            Map<String, Object> resultsToken=  (Map<String, Object>) results.get('Response');
            
            curAuthToken= (String) resultsToken.get('Access_Token');
            system.debug('curAuthToken --->  '+ curAuthToken);
            
            //Get Sales Data
            String Auth=curAuthToken;
            
            GetWondersoftData wd= new GetWondersoftData();
            if(CallType=='Return'){
                salesSMN= 'PullSalesReturn';
            }
            
            HttpResponse res= wd.GetWSData(salesEP,Auth,salesSMN,FromDate,ToDate);
            system.debug('Sales Data Body ---> '+ res.getbody());
            String jsonBody= res.getbody();
            
            JSONSales salesResponse = JSONSales.parse(jsonBody);
            parsedJSON=salesResponse;
            
            Set<String> franSAPCode = new Set<String>();
            for(Integer i=0;i<salesResponse.Response.WsTransaction.Sales.size();i++){
                franSAPCode.add(salesResponse.Response.WsTransaction.Sales[i].StoreCode);
            }
            
            //Processing variables
            Map<String, Franchisee__c> srcFranchiseeMap= new  Map<String, Franchisee__c>();
            List<Franchisee__c> franListToInsert= New  List<Franchisee__c>();
            
            system.debug('Franchisee codes --> '+ franSAPCode);
            List<Franchisee__c> franList= [SELECT Id,Name,SAP_Code__c FROM Franchisee__c Where SAP_Code__c IN :franSAPCode];
            for(Franchisee__c curfran: franList){
                srcFranchiseeMap.Put(curfran.SAP_Code__c, curfran);
            }
            
            for(Integer i=0;i<salesResponse.Response.WsTransaction.Sales.size();i++){
                if(srcFranchiseeMap.get(salesResponse.Response.WsTransaction.Sales[i].StoreCode) == Null){
                    Franchisee__c tempfran= New Franchisee__c();
                    if(salesResponse.Response.WsTransaction.Sales[i].StoreName == Null){
                        tempfran.Name= salesResponse.Response.WsTransaction.Sales[i].StoreCode;
                    }else{
                        tempfran.Name= salesResponse.Response.WsTransaction.Sales[i].StoreName;
                    }
                    tempfran.SAP_Code__c= salesResponse.Response.WsTransaction.Sales[i].StoreCode;
                    tempfran.GST_No__c=salesResponse.Response.WsTransaction.Sales[i].StoreGSTIN;
                    franListToInsert.add(tempfran);
                }
            }
            
            If(franListToInsert.size()>0){
                Database.SaveResult[] srList = Database.insert(franListToInsert,false);
                
                // Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted Franchisee. Franchisee ID: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Franchisee fields that affected this error: ' + err.getFields());
                        }  
                    }
                }
            }
            if(!Test.isRunningTest()){
                System.enqueueJob(new ProcessWSSalesCustomer(parsedJSON));
            } 
        } 
    }   
}