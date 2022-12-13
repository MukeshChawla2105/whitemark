public class ProcessWSInvoice implements Queueable{
    public JSONSales salesResponse= new JSONSales();
    
    public ProcessWSInvoice(JSONSales parsedJSON) {
        this.salesResponse=parsedJSON;
    }
    
    public void execute(QueueableContext context) {
        
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
        
        List<Account> accList= [SELECT Id,Phone FROM Account Where Phone IN :accPhone];
        for(Account curAcc: accList){
            srcAccountMap.Put(curAcc.Phone, curAcc);
        }
        
        List<Invoice_Master__c> invoiceListToUpsert= New  List<Invoice_Master__c>();
        
        //Pricebook
        List<Pricebook2> pblist =[SELECT Id FROM Pricebook2 where IsStandard=true];
        
        for(Integer i=0;i<salesResponse.Response.WsTransaction.Sales.size();i++){
            if(salesResponse.Response.WsTransaction.Sales[i].Items != null){
                Invoice_Master__c im=New Invoice_Master__c();
                
                im.Invoice_Date__c= date.valueOf(salesResponse.Response.WsTransaction.Sales[i].DocDate);
                im.Due_Date__c= date.valueOf(salesResponse.Response.WsTransaction.Sales[i].DocDate);
                im.Wondersoft_ID__c= salesResponse.Response.WsTransaction.Sales[i].DocNumber;
                im.Invoice_Type__c= salesResponse.Response.WsTransaction.Sales[i].DocType;
                im.Return_Id__c=salesResponse.Response.WsTransaction.Sales[i].RefDocNumber;
                im.Status__c='Invoiced';
                im.Franchisee__c= srcFranchiseeMap.get(salesResponse.Response.WsTransaction.Sales[i].StoreCode).Id;
                If(salesResponse.Response.WsTransaction.Sales[i].CustomerMobile != null){
                    im.Account__c= srcAccountMap.get(salesResponse.Response.WsTransaction.Sales[i].CustomerMobile).Id;
                }
                im.Price_Book__c=pblist[0].Id;
                
                invoiceListToUpsert.add(im);
                System.debug('Invoice Master -- > '+im);
            }
            
        }//end of "for" sales response
        If(invoiceListToUpsert.size()>0){
            Schema.SObjectField ftoken = Invoice_Master__c.Fields.Wondersoft_ID__c;
            Database.UpsertResult[] srList = Database.upsert(invoiceListToUpsert,ftoken,false);
            
            // Iterate through each returned result
            for (Database.UpsertResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    if (sr.isCreated()) {
                        System.debug('Successfully inserted Invoice. Invoice ID: ' + sr.getId());
                    }else{
                        System.debug('Successfully Updated Invoice. Invoice ID: ' + sr.getId());
                    }
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Invoice fields that affected this error: ' + err.getFields());
                    }  
                }
            }
        }//end of upsert Operation
        
         if(!Test.isRunningTest()){
            System.enqueueJob(new ProcessWSInvoiceLine(salesResponse));
        } 
        
    }//end of execute
    
}