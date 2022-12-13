public class ProcessWSSalesProduct implements Queueable{
    public JSONSales salesResponse= new JSONSales();
    
    public ProcessWSSalesProduct(JSONSales parsedJSON) {
        this.salesResponse=parsedJSON;
    }
    
    public void execute(QueueableContext context) {
        
        //Extracting the keys from data
        Set<String> prodSAPCode = new Set<String>();
        for(Integer i=0;i<salesResponse.Response.WsTransaction.Sales.size();i++){
            if(salesResponse.Response.WsTransaction.Sales[i].Items != null){
                for(Integer j=0;j<salesResponse.Response.WsTransaction.Sales[i].Items.Item.size();j++){
                    prodSAPCode.add(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].ProductCode);
                }
            }  
        }
        
        //Product Review
        Map<String, Product2> sourceProdMap= new  Map<String, Product2>();
        List<Product2> prodListToInsert= New  List<Product2>();
        System.debug('Product sets --> '+ prodSAPCode);
        List<Product2> prodList= [SELECT Brand__c,Description,Family,Id,IsActive,MRP__c,Name,SAP_Code__c FROM Product2 Where SAP_Code__c IN :prodSAPCode];
        for(Product2 curProd: prodList){
            sourceProdMap.Put(curProd.SAP_Code__c, curProd);
        }
        
        for(Integer i=0;i<salesResponse.Response.WsTransaction.Sales.size();i++){
            if(salesResponse.Response.WsTransaction.Sales[i].Items != null){
                for(Integer j=0;j<salesResponse.Response.WsTransaction.Sales[i].Items.Item.size();j++){
                    if(sourceProdMap.get(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].ProductCode) == Null){
                        Product2 tempProd= New Product2();
                        tempProd.Description= salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].HSNCode;
                        tempProd.Name= salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].ProductCode;
                        tempProd.SAP_Code__c= salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].ProductCode;
                        tempProd.ProductCode= salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].ProductCode;
                        tempProd.IsActive= true;
                        tempProd.MRP__c= Decimal.valueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].BaseValue);
                        prodListToInsert.add(tempProd);
                        system.debug('Product ---> ' + tempProd);
                    }
                }//end of inner for loop
            }   
        }//end of ourter for loop
        
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
        }//end of insert operation
        
        if(!Test.isRunningTest()){
            System.enqueueJob(new ProcessWSInvoice(salesResponse));
        } 
        
    }//end of execute
}