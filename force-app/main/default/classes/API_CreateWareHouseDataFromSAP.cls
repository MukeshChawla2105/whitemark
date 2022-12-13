@RestResource(urlMapping = '/WareHouse_Data/*')
global with sharing class API_CreateWareHouseDataFromSAP {
    
    @httpPost
    global static responseWrapper CreateWareHouseDataFromSAP(){

        responseWrapper responseJSON = new responseWrapper();
        try {

            system.debug('Product Request List::' + RestContext.request.requestBody.tostring());
            API_CreateWareHouseWrapper SAP_WareHouse_Data_Rec = API_CreateWareHouseWrapper.parse(RestContext.request.requestBody.tostring());
            System.debug('SAP_WareHouse_Data_Rec city  =======> ' + SAP_WareHouse_Data_Rec.City);
            System.debug('SAP_WareHouse_Data_Rec Comments =======> ' + SAP_WareHouse_Data_Rec.Comments);
            System.debug('SAP_WareHouse_Data_Rec Location =======> ' + SAP_WareHouse_Data_Rec.Location);
            System.debug('SAP_WareHouse_Data_Rec Pin code =======> ' + SAP_WareHouse_Data_Rec.Pin_Code);
            System.debug('SAP_WareHouse_Data_Rec  Sap code =======> ' + SAP_WareHouse_Data_Rec.SAP_Code);
            System.debug('SAP_WareHouse_Data_Rec  State =======> ' + SAP_WareHouse_Data_Rec.State);
            System.debug('SAP_WareHouse_Data_Rec Street Address =======> ' + SAP_WareHouse_Data_Rec.Street_Address);

            List<Warehouse__c> ExistingWareHouse = new List<Warehouse__c>();
            if (SAP_WareHouse_Data_Rec.SAP_Code != null) {
                ExistingWareHouse = [SELECT City__c,Comments__c,Id,Location__c,Name,Pin_Code__c,SAP_Code__c,State__c,Street_Address__c,Warehouse_Id__c 
                                        FROM Warehouse__c
                                        Where SAP_Code__c =: SAP_WareHouse_Data_Rec.SAP_Code];
                System.debug('ExistingWareHouse =====> ' + ExistingWareHouse);
                Warehouse__c WH_createOrUpdate = new Warehouse__c();

                if (SAP_WareHouse_Data_Rec.City != null) {
                    WH_createOrUpdate.City__c = SAP_WareHouse_Data_Rec.City;
                }
                if (SAP_WareHouse_Data_Rec.Comments != null) {
                    WH_createOrUpdate.Comments__c = SAP_WareHouse_Data_Rec.Comments;
                }
                if (SAP_WareHouse_Data_Rec.Location != null) {
                    WH_createOrUpdate.Location__c = SAP_WareHouse_Data_Rec.Location;                    
                }
                if (SAP_WareHouse_Data_Rec.Pin_Code != null) {
                    WH_createOrUpdate.Pin_Code__c = SAP_WareHouse_Data_Rec.Pin_Code;                    
                }
                if (SAP_WareHouse_Data_Rec.SAP_Code != null) {
                    WH_createOrUpdate.SAP_Code__c = SAP_WareHouse_Data_Rec.SAP_Code;                    
                }
                if (SAP_WareHouse_Data_Rec.State != null) {
                    WH_createOrUpdate.State__c = SAP_WareHouse_Data_Rec.State;                    
                }
                if (SAP_WareHouse_Data_Rec.Street_Address != null) {
                    WH_createOrUpdate.Street_Address__c = SAP_WareHouse_Data_Rec.Street_Address;
                    
                }
                if (SAP_WareHouse_Data_Rec.Warehouse_Name != null) {
                    WH_createOrUpdate.Name = SAP_WareHouse_Data_Rec.Warehouse_Name;                  
                }
                if (!ExistingWareHouse.isEmpty()) {
                    WH_createOrUpdate.Id =  ExistingWareHouse[0].Id;
                    Update WH_createOrUpdate;    
                    responseJSON.Message = 'WareHouse Details has been Updated Successfully';
                    responseJSON.Success = true;
                    responseJSON.WareHouseId = ExistingWareHouse[0].Id;
                    if ( WH_createOrUpdate.Id != null ){
                        JSON_Payload__c JP = new JSON_Payload__c();
                        JP.Warehouse__c = WH_createOrUpdate.Id;
                        JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                        insert JP;
                    }              
                }
                else{
                    insert WH_createOrUpdate;
                    responseJSON.Message = 'WareHouse Records has been Created Successfully';
                    responseJSON.Success = true;
                    responseJSON.WareHouseId = WH_createOrUpdate.Id;
                    if ( WH_createOrUpdate.Id != null ){
                        JSON_Payload__c JP = new JSON_Payload__c();
                        JP.Warehouse__c = WH_createOrUpdate.Id;
                        JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                        insert JP;
                    }
                }
            }
        } catch (Exception e) {
            System.debug('The error has occured due to ====> ' + e.getMessage() + 'at line Number =========> ' + e.getLineNumber());
            responseJSON.Message = e.getMessage();
            responseJSON.Success = False;
            Execption__c ex = new Execption__c();
            ex.Class_Name__c = 'API_CreateWareHouseDataFromSAP';
            ex.Ececption_Message__c = e.getMessage();
            ex.Method_Name__c = 'CreateWareHouseDataFromSAP';
            ex.Stack_Trace__c = e.getStackTraceString();
            insert ex;

            JSON_Payload__c JP = new JSON_Payload__c();
                //JP.Warehouse__c = WH_createOrUpdate.Id;
                JP.Payload_Description__c = e.getMessage() + 'at line number ==> ' + e.getLineNumber();
                JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                insert JP;
            
        }
        return responseJSON;

    }

    global class responseWrapper{
        global String Message;            //message string
        global boolean Success;        // Success String
        global String WareHouseId;
    }
}