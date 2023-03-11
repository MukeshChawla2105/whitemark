/*Rapidor_Inventory_Sync*/
@RestResource(urlMapping='/franchiseeInventorySync')
global class WS_FranchiseeInventorySync{
    global class Response extends WS_Response{
        public Response(){}
        public cls_franchisee_Response franchisee_details;
    }
    @HttpPost
    global static Response getRespon(){
        RestRequest req      = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        System.debug(req.requestBody);
        Response res         = new Response();
        List<Inventory__c> inventoryList = new List<Inventory__c>();
        List<Franchisee__c> franchList = new List<Franchisee__c>();
        Map<String,Id> invLineItemMap = new Map<String,Id>();
        List<Inventory_Detail__c> invLineItemList = new List<Inventory_Detail__c>();
        Set<String> prodCodeSet = new Set<String>();
        List<Product2> prodList = new List<Product2>();
        Map<String,Id> prodMap = new Map<String,Id>();
        if(req == null || req.requestBody == null){
            res.status          = 'Error';
            res.errorMessage    = 'REQUEST_BODY_IS_NULL';
            res.statusCode      = '400';
            return res;
        }else{
            String jsonData     = req.requestBody.toString();
            RequestStructure franchisee_details = new RequestStructure();
            cls_franchisee_Response franchisee_details_1 = new cls_franchisee_Response();
            System.debug('jsonData::: ' + jsonData);
            RequestStructure reqStruct=(RequestStructure)Json.deserialize(jsonData, RequestStructure.class);
            System.debug('reqStruct:::'+reqStruct);
            if(reqStruct.franchisee_details != null && reqStruct.franchisee_details.franchisee_code != null && reqStruct.franchisee_details.franchisee_code != '' && reqStruct.franchisee_details.inventory_details.size() > 0){
                inventoryList = [SELECT Id,(SELECT Id,Item_Code__c FROM Inventory_Details__r) FROM Inventory__c WHERE SAP_Franchisee_Code__c =: reqStruct.franchisee_details.franchisee_code];
                if(inventoryList.size() > 0){
                    for(Inventory_Detail__c invLineItem : inventoryList[0].Inventory_Details__r){
                        invLineItemMap.put(invLineItem.Item_Code__c,invLineItem.Id);
                    }
                    for(cls_inventory_details rcvdInvLineItem : reqStruct.franchisee_details.inventory_details){
                        prodCodeSet.add(rcvdInvLineItem.product_code);
                    }
                    if(prodCodeSet.size() > 0){
                        prodList = [SELECT Id,SAP_Code__c FROM Product2 WHERE SAP_Code__c IN: prodCodeSet];
                        for(Product2 prodObj : prodList){
                            prodMap.put(prodObj.SAP_Code__c,prodObj.Id); 
                        }
                    }
                    for(cls_inventory_details rcvdInvLineItem : reqStruct.franchisee_details.inventory_details){
                        Inventory_Detail__c invLineItemObj = new Inventory_Detail__c();
                        if(invLineItemMap.keySet().contains(rcvdInvLineItem.product_code)){
                            invLineItemObj.Id = invLineItemMap.get(rcvdInvLineItem.product_code);
                        }
                        else{
                            invLineItemObj.Inventory__c = inventoryList[0].Id;
                            invLineItemObj.Date__c = System.today();
                            if(prodMap.get(rcvdInvLineItem.product_code) != null)
                                invLineItemObj.Product__c = prodMap.get(rcvdInvLineItem.product_code);
                            else{
                                franchisee_details_1.sf_id = '';
                                res.franchisee_details = franchisee_details_1;
                                res.status          = 'Error';
                                res.errorMessage    = 'Product not found with code as: '+rcvdInvLineItem.product_code; 
                                res.successMessage  = '';
                                res.statusCode      = '400';
                                res.franchisee_details = franchisee_details_1;
                                RETURN res;
                            }
                        }
                        invLineItemObj.Available_Quantity__c = Decimal.valueOf(rcvdInvLineItem.available_quantity);
                        invLineItemList.add(invLineItemObj);
                    }
                    if(invLineItemList.size() > 0)
                        UPSERT invLineItemList;
                }
                else{
                    franchList = [SELECT Id FROM Franchisee__c WHERE SAP_Code__c =: reqStruct.franchisee_details.franchisee_code];
                    if(franchList.size() > 0){
                        Inventory__c invObj = new Inventory__c();
                        Id recTypeId = Schema.SObjectType.Inventory__c.getRecordTypeInfosByName().get('Franchisee Inventory').getRecordTypeId();
                        invObj.Franchisee__r = new Franchisee__c(SAP_Code__c = reqStruct.franchisee_details.franchisee_code);
                        INSERT invObj;
                        for(cls_inventory_details rcvdInvLineItem : reqStruct.franchisee_details.inventory_details){
                            prodCodeSet.add(rcvdInvLineItem.product_code);
                        }
                        if(prodCodeSet.size() > 0){
                            prodList = [SELECT Id,SAP_Code__c FROM Product2 WHERE SAP_Code__c IN: prodCodeSet];
                            for(Product2 prodObj : prodList){
                                prodMap.put(prodObj.SAP_Code__c,prodObj.Id); 
                            }
                        }
                        for(cls_inventory_details rcvdInvLineItem : reqStruct.franchisee_details.inventory_details){
                            Inventory_Detail__c invLineItemObj = new Inventory_Detail__c();
                            
                            invLineItemObj.Inventory__c = invObj.Id;
                            invLineItemObj.Date__c = System.today();
                            if(prodMap.get(rcvdInvLineItem.product_code) != null)
                                invLineItemObj.Product__c = prodMap.get(rcvdInvLineItem.product_code);
                            else{
                                franchisee_details_1.sf_id = '';
                                res.franchisee_details = franchisee_details_1;
                                res.status          = 'Error';
                                res.errorMessage    = 'Product not found with code as: '+rcvdInvLineItem.product_code; 
                                res.successMessage  = '';
                                res.statusCode      = '400';
                                res.franchisee_details = franchisee_details_1;
                                RETURN res;
                            }
                            invLineItemObj.Available_Quantity__c = Decimal.valueOf(rcvdInvLineItem.available_quantity);
                            invLineItemList.add(invLineItemObj);
                        }
                        if(invLineItemList.size() > 0)
                            INSERT invLineItemList;
                    }
                    else{
                        franchisee_details_1.sf_id = '';
                        res.franchisee_details = franchisee_details_1;
                        res.status          = 'Error';
                        res.errorMessage    = 'Franchisee not found with franchisee code as: '+reqStruct.franchisee_details.franchisee_code; 
                        res.successMessage  = '';
                        res.statusCode      = '400';
                        res.franchisee_details = franchisee_details_1;
                        RETURN res;
                    }
                }
                UPSERT invLineItemList;
                franchisee_details_1.sf_id = invLineItemList[0].Id;
                res.franchisee_details = franchisee_details_1;
            }
            else{
                res.franchisee_details = franchisee_details_1;
                res.status          = 'Error';
                res.errorMessage    = 'Franchisee code or other details can not be blank';
                res.successMessage  = '';
                res.statusCode      = '400';
                res.franchisee_details = franchisee_details_1;
                RETURN res;
            }
        }
        RETURN res;
    }
    public class RequestStructure{
        public cls_franchisee_details franchisee_details;
    }
    class cls_franchisee_details {
        public String franchisee_code;
        public List<cls_inventory_details> inventory_details;
    }
    class cls_inventory_details {
        public String product_code;
        public String available_quantity;
    }
    class cls_franchisee_Response {
        public String sf_id;
    }
}