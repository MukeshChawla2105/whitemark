public class ProcessWSInvoiceLine implements Queueable{
    public JSONSales salesResponse= new JSONSales();
    
    public ProcessWSInvoiceLine(JSONSales parsedJSON) {
        this.salesResponse=parsedJSON;
    }
    
    public void execute(QueueableContext context) {
        
        //Extracting the keys from data
        Set<String> prodSAPCode = new Set<String>();
        Set<String> WSInvoiceId = new Set<String>();
        for(Integer i=0;i<salesResponse.Response.WsTransaction.Sales.size();i++){
            WSInvoiceId.add(salesResponse.Response.WsTransaction.Sales[i].DocNumber);
            if(salesResponse.Response.WsTransaction.Sales[i].Items != null){
                for(Integer j=0;j<salesResponse.Response.WsTransaction.Sales[i].Items.Item.size();j++){
                    prodSAPCode.add(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].ProductCode);
                }
            }  
        }
        
        List<Invoice_Line_Item__c> invoiceLIListToUpsert= New  List<Invoice_Line_Item__c>();
        
        //Product details
        Map<String, Product2> sourceProdMap= new  Map<String, Product2>();
        List<Product2> prodList= [SELECT Brand__c,Description,Family,Id,IsActive,MRP__c,Name,SAP_Code__c FROM Product2 Where SAP_Code__c IN :prodSAPCode];
        for(Product2 curProd: prodList){
            sourceProdMap.Put(curProd.SAP_Code__c, curProd);
        }
        
        //Invoice details
        Map<String, Invoice_Master__c> sourceInvoiceMap= new  Map<String, Invoice_Master__c>();
        List<Invoice_Master__c> invoiceList= [SELECT Id,Wondersoft_ID__c FROM Invoice_Master__c Where Wondersoft_ID__c IN :WSInvoiceId];
        for(Invoice_Master__c curInvoice: invoiceList){
            sourceInvoiceMap.Put(curInvoice.Wondersoft_ID__c, curInvoice);
        }
        
        
        for(Integer i=0;i<salesResponse.Response.WsTransaction.Sales.size();i++){
            if(salesResponse.Response.WsTransaction.Sales[i].Items != null){
                for(Integer j=0;j<salesResponse.Response.WsTransaction.Sales[i].Items.Item.size();j++){
                    Invoice_Line_Item__c invoiceLI= New Invoice_Line_Item__c();
                    invoiceLI.IL_Key__c = salesResponse.Response.WsTransaction.Sales[i].DocNumber + salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].ProductCode ;
                    if(sourceInvoiceMap.get(salesResponse.Response.WsTransaction.Sales[i].DocNumber) != Null){
                        invoiceLI.Invoice_Master__c= sourceInvoiceMap.get(salesResponse.Response.WsTransaction.Sales[i].DocNumber).Id;
                    }
                    if(sourceProdMap.get(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].ProductCode) !=Null){
                       invoiceLI.Product__c= sourceProdMap.get(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].ProductCode).Id; 
                    }
                    invoiceLI.Quantity__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].Quantity);
                    invoiceLI.FreeQuantity__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].FreeQuantity);
                    invoiceLI.BatchDescription__c= salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].BatchDescription;
                    invoiceLI.HSNCode__c= salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].HSNCode;
                    invoiceLI.SalesPrice__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].SalesPrice);
                    invoiceLI.PDiscountAmt__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].PDiscountAmt);
                    invoiceLI.PDiscountPer__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].PDiscountPer);
                    invoiceLI.DiscountAmount__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].DiscountAmount);
                    invoiceLI.OtherDiscountAmt__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].OtherDiscountAmt);
                    invoiceLI.TaxAmount__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].TaxAmount);
                    invoiceLI.MOP__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].BaseValue);
                    invoiceLI.CGST__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].CGST);
                    invoiceLI.SGST__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].SGST);
                    invoiceLI.IGST__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].IGST);
                    invoiceLI.UTGST__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].UTGST);
                    invoiceLI.CESS__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].CESS);
                    invoiceLI.EffectiveTaxPercentage__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].EffectiveTaxPercentage);
                    if(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].TaxRate!= Null){
                        invoiceLI.TaxRate__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].TaxRate);
                    }
                    invoiceLI.CGSTPercent__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].CGSTPercent);
                    invoiceLI.SGSTPercent__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].SGSTPercent);
                    invoiceLI.IGSTPercent__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].IGSTPercent);
                    invoiceLI.UTGSTPercent__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].UTGSTPercent);
                    invoiceLI.CESSPercent__c= Decimal.ValueOf(salesResponse.Response.WsTransaction.Sales[i].Items.Item[j].CESSPercent);
                    
                    invoiceLIListToUpsert.add(invoiceLI);
                    System.debug('Invoice Line Items -- > '+invoiceLI);
                    
                }//end of inner for loop
                
            }
        }//end of outer for loop
        
        If(invoiceLIListToUpsert.size()>0){
            Schema.SObjectField ftoken = Invoice_Line_Item__c.Fields.IL_Key__c;
            Database.UpsertResult[] srList = Database.upsert(invoiceLIListToUpsert,ftoken,false);
            
            // Iterate through each returned result
            for (Database.UpsertResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    if (sr.isCreated()) {
                        System.debug('Successfully inserted Invoice Line Item. Invoice Line Item ID: ' + sr.getId());
                    }else{
                        System.debug('Successfully Updated Invoice Line Item. Invoice Line Item ID: ' + sr.getId());
                    }
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Invoice Line Item fields that affected this error: ' + err.getFields());
                    }  
                }
            }
        }//end of upsert Operation
    }//end of execute
}