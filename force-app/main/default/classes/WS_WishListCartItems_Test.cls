@isTest
public class WS_WishListCartItems_Test {
    @isTest
    public static void cartTest(){
        Account accObj = new Account();
        accObj.Name = 'Test';
        accObj.BillingCity = 'Nagpur';
        accObj.Phone='9895761975';
        
        INSERT accObj;
        String jsonString = '{ "wishlist_cart_details": { "customer_phone_number": "9895761975", "type": "Wish List", "item_details": [ { "product_code": "IMP-052M081C000S050", "quantity": "1.0000" }, { "product_code": "SON-052M081C000S089", "quantity": "1.0000" } ] } }';
        Restrequest req = new Restrequest();
        Wishlist_Cart_Items__c wcObj = new Wishlist_Cart_Items__c();
        wcObj.Type__c='Wish List';
        wcObj.Customer__c=accObj.id; 
        
        INSERT wcObj;
        req.requestURI = 'services/apexrest/WS_WishListCartItems';
        req.httpMethod = 'Post';
        RestContext.request = req;
        req.requestBody = Blob.valueOf(jsonString);
        WS_WishListCartItems.getRespone(); 
    }
    @isTest
    public static void cartTest_1(){
        Account accObj = new Account();
        accObj.Name = 'Test';
        accObj.BillingCity = 'Nagpur';
        accObj.Phone='9895761979';
        
        INSERT accObj;
        String jsonString = '{ "wishlist_cart_details": { "customer_phone_number": "9895761975", "type": "Wish List", "item_details": [ { "product_code": "IMP-052M081C000S050", "quantity": "1.0000" }, { "product_code": "SON-052M081C000S089", "quantity": "1.0000" } ] } }';
        Restrequest req = new Restrequest();
        Wishlist_Cart_Items__c wcObj = new Wishlist_Cart_Items__c();
        wcObj.Type__c='Wish List';
        wcObj.Customer__c=accObj.id; 
        
        INSERT wcObj;
        req.requestURI = 'services/apexrest/WS_WishListCartItems';
        req.httpMethod = 'Post';
        RestContext.request = req;
        req.requestBody = Blob.valueOf(jsonString);
        WS_WishListCartItems.getRespone(); 
    }
    @isTest
    public static void cartTest_2(){
        Account accObj = new Account();
        accObj.Name = 'Test';
        accObj.BillingCity = 'Nagpur';
        accObj.Phone='9895761975';
        
        INSERT accObj;
        String jsonString = '{ "wishlist_cart_details": null }';
        Restrequest req = new Restrequest();
        
        Wishlist_Cart_Items__c wcObj = new Wishlist_Cart_Items__c();
        wcObj.Type__c='Wish List';
        wcObj.Customer__c=accObj.id; 
        
        INSERT wcObj;
        req.requestURI = 'services/apexrest/WS_WishListCartItems';
        req.httpMethod = 'Post';
        RestContext.request = req;
        req.requestBody = Blob.valueOf(jsonString);
        WS_WishListCartItems.getRespone(); 
    }
}