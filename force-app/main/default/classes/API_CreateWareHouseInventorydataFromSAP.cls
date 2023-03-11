@RestResource(urlMapping = '/WareHouseInventory_Data/*')
global with sharing class API_CreateWareHouseInventorydataFromSAP{
    @httpPost
    global static responseWrapper CreateWareHouseInventorydataFromSAP(){
        responseWrapper responseJSON = new responseWrapper();
        try{

            system.debug('Product Request List::' + RestContext.request.requestBody.tostring());
            API_CreateWareHouseInventoryDataWrapper SAP_WareHouse_Inventory_Data = API_CreateWareHouseInventoryDataWrapper.parse(RestContext.request.requestBody.tostring());
            System.debug('SAP_WareHouse_Inventory_Data Inventor_Date  =======> ' + SAP_WareHouse_Inventory_Data.Inventor_Date);
            System.debug('SAP_WareHouse_Inventory_Data Product_SAP_Code  =======> ' + SAP_WareHouse_Inventory_Data.Product_SAP_Code);
            System.debug('SAP_WareHouse_Inventory_Data Warehouse_SAP_Code  =======> ' + SAP_WareHouse_Inventory_Data.Warehouse_SAP_Code);
            System.debug('SAP_WareHouse_Inventory_Data Available_Quantity  =======> ' + SAP_WareHouse_Inventory_Data.Available_Quantity);

            List<Inventory__c> ExistingInventoryDetails = new List<Inventory__c>();
            List<Product2> ExistingProduct = new List<Product2>();
            List<Warehouse__c> ExistingWareHouse = new List<Warehouse__c>();

            if ( SAP_WareHouse_Inventory_Data.Product_SAP_Code != null && SAP_WareHouse_Inventory_Data.Warehouse_SAP_Code != null ){
                ExistingInventoryDetails = [SELECT Available_Quantity__c, CurrentIOH__c, Date__c, Id, Inventory_Key__c, Product__c, SAP_Franchisee_Code__c, SAP_Product_Code__c, SAP_Warehouse_Code__c, Warehouse__c
                                            FROM Inventory__c
                                            Where Product__r.SAP_Code__c = :SAP_WareHouse_Inventory_Data.Product_SAP_Code AND Warehouse__r.SAP_Code__c = :SAP_WareHouse_Inventory_Data.Warehouse_SAP_Code];


                Inventory__c Invent_CreateOrUpdate = new Inventory__c();
                if ( SAP_WareHouse_Inventory_Data.Inventor_Date != null ){
                    Invent_CreateOrUpdate.Date__c = Date.valueOf(SAP_WareHouse_Inventory_Data.Inventor_Date);
                }
                if ( SAP_WareHouse_Inventory_Data.Available_Quantity != null ){
                    Invent_CreateOrUpdate.Available_Quantity__c = SAP_WareHouse_Inventory_Data.Available_Quantity;
                }
                if ( !ExistingInventoryDetails.isEmpty() ){
                    Invent_CreateOrUpdate.Id = ExistingInventoryDetails[0].Id;
                    update Invent_CreateOrUpdate;
                    responseJSON.Message = 'Inventory Details has been Updated Successfully';
                    responseJSON.Success = true;
                    responseJSON.InventoryId = ExistingInventoryDetails[0].Id;
                    if ( Invent_CreateOrUpdate.Id != null ){
                        JSON_Payload__c JP = new JSON_Payload__c();
                        JP.Inventory__c = Invent_CreateOrUpdate.Id;
                        JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                        insert JP;
                    }
                }
                else{
                    ExistingProduct = [SELECT Brand__c, Capacity_Size__c, Colour__c, Consumer_Offer__c, Id, IsActive, MRP__c, ProductCode, Product_Id__c, SAP_Code__c, Star_Rating__c, Sub_Category__c, Warranty__c
                                       FROM Product2
                                       Where SAP_Code__c = :SAP_WareHouse_Inventory_Data.Product_SAP_Code];
                    ExistingWareHouse = [SELECT City__c, Comments__c, Id, Location__c, Name, Pin_Code__c, SAP_Code__c, State__c, Street_Address__c, Warehouse_Id__c
                                         FROM Warehouse__c
                                         Where SAP_Code__c = :SAP_WareHouse_Inventory_Data.Warehouse_SAP_Code];

                    if ( ExistingProduct.isEmpty() && ExistingWareHouse.isEmpty() ){
                        responseJSON.Message = 'WareHouse And Product Does not Exist in the System!!';
                        responseJSON.Success = False;
                        JSON_Payload__c JP = new JSON_Payload__c();
                        JP.Payload_Description__c = 'Either WareHOuse or Product, Or Both Does not Exist in the System. So Inventory is neither updated nor Insert';
                        JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                        insert JP;

                    }
                    else if ( !ExistingProduct.isEmpty() && !ExistingWareHouse.isEmpty() ){
                        Invent_CreateOrUpdate.Product__c = ExistingProduct[0].Id;
                        Invent_CreateOrUpdate.Warehouse__c = ExistingWareHouse[0].Id;
                        insert Invent_CreateOrUpdate;
                        responseJSON.Message = 'Inventory Details has been Created  Successfully';
                        responseJSON.Success = true;
                        responseJSON.InventoryId = Invent_CreateOrUpdate.Id;
                        if ( Invent_CreateOrUpdate.Id != null ){
                            JSON_Payload__c JP = new JSON_Payload__c();
                            JP.Inventory__c = Invent_CreateOrUpdate.Id;
                            JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                            insert JP;
                        }
                    }
                    else if(ExistingProduct.isEmpty() || ExistingWareHouse.isEmpty()){
                        responseJSON.Message = 'Either WareHouse or Product Does not Exist in the System!!';
                        responseJSON.Success = False;
                        JSON_Payload__c JP = new JSON_Payload__c();
                        JP.Payload_Description__c = 'Either WareHOuse or Product, Or Both Does not Exist in the System. So Inventory is neither updated nor Insert';
                        JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                        insert JP;
                    }
                }
            }

        }
        catch ( Exception e ){

            System.debug('The error has occured due to ====> ' + e.getMessage() + 'at line Number =========> ' + e.getLineNumber());
            responseJSON.Message = 'WareHouse Inventory record can not be Updated/Created Beacuse ' + e.getMessage();
            responseJSON.Success = False;
            Execption__c ex = new Execption__c();
            ex.Class_Name__c = 'API_CreateWareHouseInventorydataFromSAP';
            ex.Ececption_Message__c = e.getMessage();
            ex.Method_Name__c = 'CreateWareHouseInventorydataFromSAP';
            ex.Stack_Trace__c = e.getStackTraceString();
            insert ex;
            
            //responseJSON.Success = false;
            JSON_Payload__c JP = new JSON_Payload__c();
                //JP.Inventory__c = Invent_CreateOrUpdate.Id;
                JP.Payload_Description__c = e.getMessage() + 'at line number ==> ' + e.getLineNumber();
                JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                insert JP;

        }
        return responseJSON;
    }

    global class responseWrapper{
        global String Message;            //message string
        global boolean Success;        // Success String
        global String InventoryId;

    }

}