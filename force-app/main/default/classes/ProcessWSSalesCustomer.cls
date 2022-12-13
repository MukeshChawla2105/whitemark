public class ProcessWSSalesCustomer implements Queueable{
    public JSONSales salesResponse= new JSONSales();
    
    public ProcessWSSalesCustomer(JSONSales parsedJSON) {
        this.salesResponse=parsedJSON;
    }
    
    public void execute(QueueableContext context) {
        
        List<RecordType > RT= [SELECT DeveloperName,Id,SobjectType FROM RecordType WHERE DeveloperName = 'PersonAccount'];
    
        //Extracting the keys from data
        Set<String> franSAPCode = new Set<String>();
        Set<String> accPhone = new Set<String>();
        for(Integer i=0;i<salesResponse.Response.WsTransaction.Sales.size();i++){
            franSAPCode.add(salesResponse.Response.WsTransaction.Sales[i].StoreCode);
            accPhone.add(salesResponse.Response.WsTransaction.Sales[i].CustomerMobile);
        }
        
        //Check for Franchisee
        Map<String, Franchisee__c> srcFranchiseeMap= new  Map<String, Franchisee__c>();
        List<Franchisee__c> franListToInsert= New  List<Franchisee__c>();
        
        List<Franchisee__c> franList= [SELECT Id,Name,SAP_Code__c FROM Franchisee__c Where SAP_Code__c IN :franSAPCode];
        for(Franchisee__c curfran: franList){
            srcFranchiseeMap.Put(curfran.SAP_Code__c, curfran);
        }
        
        //Check for Account
        Map<String, Account> srcAccountMap= new  Map<String, Account>();
        List<Account> accListToInsert= New  List<Account>();
        system.debug('Account phone set --> '+ accPhone);
        List<Account> accList= [SELECT Id,Phone FROM Account Where Phone IN :accPhone];
        for(Account curAcc: accList){
            srcAccountMap.Put(curAcc.Phone, curAcc);
        }
        
        for(Integer i=0;i<salesResponse.Response.WsTransaction.Sales.size();i++){
            //check if the account exists?
            if(salesResponse.Response.WsTransaction.Sales[i].CustomerMobile != Null){
                //if(srcAccountMap.get(salesResponse.Response.WsTransaction.Sales[i].CustomerMobile) == Null){
                Account acc=New Account();
                acc.RecordTypeId=RT[0].Id;
                if(salesResponse.Response.WsTransaction.Sales[i].CustomerName!= null){
                    acc.LastName= salesResponse.Response.WsTransaction.Sales[i].CustomerName;
                }else{
                    acc.LastName= salesResponse.Response.WsTransaction.Sales[i].CustomerMobile;
                }
                acc.Status__c='Active';
                acc.Type='Customer';
                acc.Phone= salesResponse.Response.WsTransaction.Sales[i].CustomerMobile;
                acc.Email__c= salesResponse.Response.WsTransaction.Sales[i].CustomerEmail;
                acc.Delivery_Option__c='Franchisee';
                acc.Franchisee__c=srcFranchiseeMap.get(salesResponse.Response.WsTransaction.Sales[i].StoreCode).Id;
                
                //Billing address details
                acc.BillingStreet= salesResponse.Response.WsTransaction.Sales[i].BillingAddress1+', '+salesResponse.Response.WsTransaction.Sales[i].BillingAddress2+', '+salesResponse.Response.WsTransaction.Sales[i].BillingAddress3;
                acc.BillingCountry=salesResponse.Response.WsTransaction.Sales[i].CountryCode;
                acc.BillingPostalCode=salesResponse.Response.WsTransaction.Sales[i].BillingPinCode;
                if(salesResponse.Response.WsTransaction.Sales[i].BillingStateCode == 'KL'){
                    acc.BillingState='Kerala';
                }
                
                //Delivery address details
                acc.ShippingStreet= salesResponse.Response.WsTransaction.Sales[i].DeliveryAddress1+', '+salesResponse.Response.WsTransaction.Sales[i].DeliveryAddress2+', '+salesResponse.Response.WsTransaction.Sales[i].DeliveryAddress3;
                acc.ShippingCountry=salesResponse.Response.WsTransaction.Sales[i].CountryCode;
                acc.ShippingPostalCode=salesResponse.Response.WsTransaction.Sales[i].DeliveryPinCode;
                if(salesResponse.Response.WsTransaction.Sales[i].AlternateStateCode == 'KL'){
                    acc.BillingState='Kerala';
                }
                
                accListToInsert.add(acc);
                System.debug('Account -- > '+acc);
                //}
            }
        }//end of for loop
        
        If(accListToInsert.size()>0){
            Database.SaveResult[] srList = Database.insert(accListToInsert,false);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Account. Account ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }  
                }
            }
        }
        if(!Test.isRunningTest()){
            System.enqueueJob(new ProcessWSSalesProduct(salesResponse));
        } 
        
    }
    
}