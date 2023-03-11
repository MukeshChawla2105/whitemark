@RestResource(urlMapping = '/Product_Creation/*')
global with sharing class API_CreateProductFromSAP{
    @httpPost
    global static responseWrapper CreateProductFromSAP(){
        responseWrapper responseJSON = new responseWrapper();
        try{

            system.debug('Product Request List::' + RestContext.request.requestBody.tostring());
            API_CreateProductWrapper SAP_Product_Rec = API_CreateProductWrapper.parse(RestContext.request.requestBody.tostring());

            List<PricebookEntry> pbeList = new List<PricebookEntry>();
            List<Product2> ExistingProductWithSAPcode = new List<Product2>();
            if ( SAP_Product_Rec.SAP_Code != null ){
                product2 CreateOrUpdateProd = new product2();
                if ( SAP_Product_Rec.Capacity_Size != null ){
                    CreateOrUpdateProd.Capacity_Size__c = SAP_Product_Rec.Capacity_Size;
                }
                if ( SAP_Product_Rec.Colour != null ){
                    CreateOrUpdateProd.Colour__c = String.valueof(SAP_Product_Rec.Colour);
                }
                if ( SAP_Product_Rec.Category != null ){
                    CreateOrUpdateProd.Family = SAP_Product_Rec.Category;
                }
                if ( SAP_Product_Rec.Brand != null ){
                    CreateOrUpdateProd.Brand__c = SAP_Product_Rec.Brand;
                }
                if ( SAP_Product_Rec.Features != null ){
                    CreateOrUpdateProd.Description = SAP_Product_Rec.Features;
                }
                if ( SAP_Product_Rec.Model != null ){
                    CreateOrUpdateProd.ProductCode = SAP_Product_Rec.Model;
                }
                if ( SAP_Product_Rec.Product_Name != null ){
                    CreateOrUpdateProd.Name = SAP_Product_Rec.Product_Name;
                }
                if ( SAP_Product_Rec.Product_SKU != null ){
                    CreateOrUpdateProd.StockKeepingUnit = SAP_Product_Rec.Product_SKU;
                }
                if ( SAP_Product_Rec.Quantity_Unit_Of_Measure != null ){
                    CreateOrUpdateProd.QuantityUnitOfMeasure = SAP_Product_Rec.Quantity_Unit_Of_Measure;
                }
                if ( SAP_Product_Rec.SAP_Code != null ){
                    CreateOrUpdateProd.SAP_Code__c = SAP_Product_Rec.SAP_Code;
                }
                if ( SAP_Product_Rec.Star_Rating != null ){
                    CreateOrUpdateProd.Star_Rating__c = SAP_Product_Rec.Star_Rating;
                }
                if ( SAP_Product_Rec.Sub_Category != null ){
                    CreateOrUpdateProd.Sub_Category__c = SAP_Product_Rec.Sub_Category;
                }
                if ( SAP_Product_Rec.IsActive != null ){
                    CreateOrUpdateProd.IsActive = SAP_Product_Rec.IsActive;
                }
                if ( SAP_Product_Rec.Warranty != null ){
                    CreateOrUpdateProd.Warranty__c = SAP_Product_Rec.Warranty;
                }
                System.debug('CreateOrUpdateProd ======> ' + CreateOrUpdateProd);

                ExistingProductWithSAPcode = [SELECT Brand__c, Capacity_Size__c, Colour__c, Consumer_Offer__c, Id, IsActive, MRP__c, ProductCode, Product_Id__c, SAP_Code__c, Star_Rating__c, Sub_Category__c, Warranty__c
                                              FROM Product2
                                              where SAP_Code__c = :SAP_Product_Rec.SAP_Code];
                System.debug('ExistingProductWithSAPcode======>' + ExistingProductWithSAPcode);

                if ( !ExistingProductWithSAPcode.isEmpty() ){
                    CreateOrUpdateProd.id = ExistingProductWithSAPcode[0].id;
                    update CreateOrUpdateProd;
                    responseJSON.Message = 'Product has been Updated Successfully';
                    responseJSON.Success = true;
                    responseJSON.ProductId = CreateOrUpdateProd.Id;
                    if ( CreateOrUpdateProd.Id != null ){
                        JSON_Payload__c JP = new JSON_Payload__c();
                        JP.Product__c = CreateOrUpdateProd.Id;
                        JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                        insert JP;
                    }
                }
                else{
                    //String PricebookId = [SELECT CreatedDate,Id,IsActive,Name FROM Pricebook2 where Name = 'Standard Price Book'].Id;
                    //CreateOrUpdateProd.
                    insert CreateOrUpdateProd;

                    if ( CreateOrUpdateProd.Id != null ){
                        responseJSON.Message = 'Product Record has been Created Successfully!';
                        responseJSON.Success = true;
                        responseJSON.ProductId = CreateOrUpdateProd.Id;
                        JSON_Payload__c JP = new JSON_Payload__c();
                        JP.Product__c = CreateOrUpdateProd.Id;
                        JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                        insert JP;
                    }
                }


            }
        }
        catch ( Exception e ){
            System.debug('The error has occured due to ======> ' + e.getMessage() + 'at line number ======> ' + e.getLineNumber());
            System.debug('Exception trace =====> ' + e.getStackTraceString());
            Execption__c ex = new Execption__c();
            ex.Class_Name__c = 'API_CreateProductFromSAP';
            ex.Ececption_Message__c = e.getMessage();
            ex.Method_Name__c = 'CreateProductFromSAP';
            ex.Stack_Trace__c = e.getStackTraceString();
            insert ex;
            responseJSON.Message = e.getMessage();
            responseJSON.Success = False;
            //responseJSON.ProductId = CreateOrUpdateProd.Id;
            JSON_Payload__c JP = new JSON_Payload__c();
                //JP.Product__c = CreateOrUpdateProd.Id;
                JP.Payload_Description__c = e.getMessage() + 'at line number ==> ' + e.getLineNumber();
                JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                System.debug(' JP ======> ' + JP);
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