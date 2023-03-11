@RestResource(urlMapping = '/Product_Price_data/*')
global with sharing class API_ProductPriceDataFromSAP {

    @httpPost
    global static responseWrapper ProductpriceDataFromSAP(){
        responseWrapper responseJSON = new responseWrapper();
        try {
            system.debug('Product Request List::' + RestContext.request.requestBody.tostring());
            API_ProductPriceDataWrapper SAP_Product_Price_Rec = API_ProductPriceDataWrapper.parse(RestContext.request.requestBody.tostring());

            System.debug('SAP_Product_Price_Rec MOP1 =======> ' + SAP_Product_Price_Rec.MOP1);
            System.debug('SAP_Product_Price_Rec MOP2 =======> ' + SAP_Product_Price_Rec.MOP2 );
            System.debug('SAP_Product_Price_Rec MRP =======> ' + SAP_Product_Price_Rec.MRP );
            System.debug('SAP_Product_Price_Rec Product_SAP_Code =======> ' + SAP_Product_Price_Rec.Product_SAP_Code);
            List<PricebookEntry> updatedpbeList = new List<PricebookEntry>();
            Product2 updateProduct = new Product2();   
            if(SAP_Product_Price_Rec.Product_SAP_Code != null){
                List<Product2> ExistingProduct = [SELECT Brand__c,Capacity_Size__c,Colour__c,Consumer_Offer__c,Id,IsActive,MRP__c,ProductCode,Product_Id__c,SAP_Code__c,Star_Rating__c,Sub_Category__c,Warranty__c 
                                                    FROM Product2
                                                    Where SAP_Code__c =: SAP_Product_Price_Rec.Product_SAP_Code];
                System.debug('ExistingProduct ====> ' + ExistingProduct);                                    
                if (SAP_Product_Price_Rec.MRP != null) {
                    updateProduct.MRP__c = SAP_Product_Price_Rec.MRP;                    
                }
                if (SAP_Product_Price_Rec.MOP1 != null) {
                    updateProduct.MOP1__c = SAP_Product_Price_Rec.MOP1;                   
                }
                if (SAP_Product_Price_Rec.MOP2 != null) {
                    updateProduct.MOP2__c = SAP_Product_Price_Rec.MOP2;                   
                }

                if(!ExistingProduct.isEmpty()){
                    updateProduct.Id = ExistingProduct[0].Id;
                    Update updateProduct;
                    responseJSON.Message = 'Product has been Updated Successfully';
                    responseJSON.Success = true;
                    responseJSON.ProductId = ExistingProduct[0].Id;
                    if ( updateProduct.Id != null ){
                        String PricebookId = [SELECT CreatedDate,Id,IsActive,Name FROM Pricebook2 where Name = 'Standard Price Book'].Id;
                            List<PricebookEntry> PBEList = [SELECT Id, UnitPrice, Product2Id,Product_SAP_Code__c, Pricebook2Id, Name, IsActive, ProductCode FROM PricebookEntry 
                                                             Where Product2Id =: updateProduct.Id];
                                                  System.debug('PBEList =====. ' + PBEList);
                            if (PBEList.isEmpty()) {
                                System.debug('I will create Price entry here');
                                updatedpbeList.add(new PricebookEntry(UnitPrice = updateProduct.MRP__c, Pricebook2Id = PricebookId, product2Id = updateProduct.Id,isActive = true));
                            }
                            System.debug('updatedpbeList =====> ' + updatedpbeList);
                            if (!updatedpbeList.isEmpty()) {
                                insert updatedpbeList;
                            }
                        JSON_Payload__c JP = new JSON_Payload__c();
                        JP.Product__c = updateProduct.Id;
                        JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                        insert JP;
                    }
                }
                else {
                    responseJSON.Message = 'Product with this SAP-Code does not existed in the system. Please Create Product First!';
                    responseJSON.Success = False;
                    JSON_Payload__c JP = new JSON_Payload__c();
                    //JP.Product__c = updateProduct.Id;
                    JP.Payload_Description__c = 'Product with this SAP-Code does not existed in the system';
                    JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                    insert JP;
                }                                    

            }  


        } catch (Exception e) {
            System.debug('The error has occured due to ====> ' + e.getMessage() + 'at line Number =========> ' + e.getLineNumber());
            responseJSON.Message = e.getMessage();
            responseJSON.Success = False;
            Execption__c ex = new Execption__c();
            ex.Class_Name__c = 'API_ProductPriceDataFromSAP';
            ex.Ececption_Message__c = e.getMessage();
            ex.Method_Name__c = 'ProductpriceDataFromSAP';
            ex.Stack_Trace__c = e.getStackTraceString();
            insert ex;
            JSON_Payload__c JP = new JSON_Payload__c();
                //JP.Product__c = updateProduct.Id;
                JP.Payload_Description__c = e.getMessage() + 'at line number ==> ' + e.getLineNumber();
                JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                insert JP;
        }
        return responseJSON;

    }
    

    global class responseWrapper{
        global String Message;            //message string
        global boolean Success;        // Success String
        global String ProductId;
    }
}