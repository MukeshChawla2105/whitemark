@RestResource(urlMapping='/wishlistCartDetails')
global class WS_WishListCartItems {
    global class Response extends WS_Response{
        public Response(){}
        public cls_wishlist_cart_details wishlist_cart_details;
    }
    @HttpPost
    global static Response getRespone(){
        RestRequest req      = Restcontext.Request;
        RestResponse restRes = Restcontext.response;
        System.debug(req.requestBody);
        Response res         = new Response();
        if(req == null || req.requestBody == null){
            res.status          = 'Error';
            res.errorMessage    = 'REQUEST_BODY_IS_NULL';
            res.statusCode      = '400';
            return res;
        }else{
            Set<Id> wcIdSet = new Set<Id>();
            List<Wishlist_Cart_Items__c> wcList = new List<Wishlist_Cart_Items__c>();
            List<Wishlist_Cart_Items__c> wcDeleteList = new List<Wishlist_Cart_Items__c>();
            List<Wishlist_Cart_Items__c> fetchedWcList = new List<Wishlist_Cart_Items__c>();
            Map<String,Id> wcMap = new Map<String,Id>();
            Set<String> prodCodeSet = new Set<String>();
            List<Product2> prodList = new List<Product2>();
            Map<String,Id> prodMap = new Map<String,Id>();
            String jsonData     = req.requestBody.toString();
            RequestStructure franchisee_details = new RequestStructure();
            System.debug('jsonData::: ' + jsonData);
            RequestStructure reqStruct=(RequestStructure)Json.deserialize(jsonData, RequestStructure.class);
            System.debug('reqStruct:::'+reqStruct);
            if(reqStruct != null && reqStruct.wishlist_cart_details != null){
                List<Account> accList = new List<Account>();
                accList = [SELECT Id FROM Account WHERE Phone =:reqStruct.wishlist_cart_details.customer_phone_number ORDER BY CreatedDate DESC];
                if(accList.size() > 0){
                    wcDeleteList = [SELECT Id FROM Wishlist_Cart_Items__c WHERE Customer__c =:accList[0].Id];
                    if(wcDeleteList.size() > 0)
                        DELETE wcDeleteList;
                    if(reqStruct.wishlist_cart_details.item_details != null){ 
                        for(cls_item_details itemObj : reqStruct.wishlist_cart_details.item_details){
                            prodCodeSet.add(itemObj.product_code);
                        }
                        if(prodCodeSet.size() > 0){
                            prodList = [SELECT Id,SAP_Code__c FROM Product2 WHERE SAP_Code__c IN :prodCodeSet];
                            for(Product2 prodObj : prodList){
                                prodMap.put(prodObj.SAP_Code__c,prodObj.Id);
                            }
                        }
                        for(cls_item_details itemObj : reqStruct.wishlist_cart_details.item_details){
                            Wishlist_Cart_Items__c wcObj = new Wishlist_Cart_Items__c();
                            wcObj.Customer__c = accList[0].Id;
                            if(reqStruct.wishlist_cart_details.type != null && reqStruct.wishlist_cart_details.type != '')
                                wcObj.Type__c = reqStruct.wishlist_cart_details.type;
                            if(itemObj.quantity != null && itemObj.quantity != '')
                                wcObj.Quantity__c = Decimal.valueOf(itemObj.quantity);
                            if(itemObj.product_code != null && itemObj.product_code != '')
                                wcObj.Product__c = prodMap.get(itemObj.product_code);
                            wcList.add(wcObj);
                        }
                        INSERT wcList;
                        
                        for(Wishlist_Cart_Items__c wcObj : wcList){
                            wcIdSet.add(wcObj.Id);
                        }
                        fetchedWcList = [SELECT Id,Product__r.SAP_Code__c FROM Wishlist_Cart_Items__c WHERE Id IN :wcIdSet];
                        for(Wishlist_Cart_Items__c wcObj : fetchedWcList){
                            wcMap.put(wcObj.Product__r.SAP_Code__c,wcObj.Id);
                        }
                        for(cls_item_details itemObj : reqStruct.wishlist_cart_details.item_details){
                            itemObj.sf_id = wcMap.get(itemObj.product_code);
                        }
                    }
                    res.wishlist_cart_details = reqStruct.wishlist_cart_details;
                }
                else{
                    res.status          = 'Error';
                    res.errorMessage    = 'No customer found with phone number as: '+reqStruct.wishlist_cart_details.customer_phone_number; 
                    res.successMessage  = '';
                    res.statusCode      = '400';
                    RETURN res; 
                }
            }
            else{
                res.status          = 'Error';
                res.errorMessage    = 'Details can not be empty'; 
                res.successMessage  = '';
                res.statusCode      = '400';
                RETURN res;
            }
        }
        RETURN res;
    }
    public class RequestStructure{
        public cls_wishlist_cart_details wishlist_cart_details;
    }
    class cls_wishlist_cart_details {
        public String customer_phone_number;
        public String type;
        public cls_item_details[] item_details;
    }
    class cls_item_details {
        public String sf_id;
        public String product_code;
        public String quantity;
    }
}