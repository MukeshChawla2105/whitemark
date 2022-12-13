@isTest
public class WS_OnlineSales_Test {
    @isTest
    public static void caseTest(){
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        UPDATE standardPricebook;
        
        Franchisee__c franObj=new  Franchisee__c();
        franObj.SAP_Code__c =  'kl07-050';
        INSERT franObj;
        
        Product2 prod=new Product2();
        prod.IsActive=true;
        prod.Description='Test';
        prod.Name='Test';
        Prod.SAP_Code__c='llo-052m198c000s059';
        prod.ProductCode='llo-052m198c000s059';
        
        INSERT prod;
        
        String jsonString = '{ "customer_details": { "customer_phone_number": "9895761975", "customer_first_name": "Vinoth", "customer_last_name": "Kumar", "alternate_phone": "9895761975", "gender": "Male", "email": "vinoth_3@webandcrafts.com", "reward_point": "", "customer_feedback": "", "feegdback_comments": "", "delivery_option": "Whitemart", "mailing_address": { "mailing_street": "Webandcrafts, Infopark", "mailing_city": "Thrissur", "mailing_postal_code": "686006", "mailing_state": "Kerala", "mailing_country": "India" }, "billing_address": { "billing_street": "Webandcrafts, Infopark", "billing_city": "Thrissur", "billing_postal_code": "686006", "billing_state": "Kerala", "billing_country": "India" }, "order_details": { "order_status": "Draft", "franchisee_code": "KL07-050", "order_date": "21/01/2022", "total_value": "31500.0000", "total_tax": "4805.0800", "order_line_items": [ { "product_code": "LLO-052M198C000S059", "qyantity": "1.0000", "unit_price": "42991.0000", "coupon_code_availed": "WM_C_001", "coupon_code_discount": "0.0000", "value": "31500.0000", "tax": "4805.0800" } ] } } }';
        Restrequest req = new Restrequest();
        req.requestURI = 'services/apexrest/onlineSales';
        req.httpMethod = 'Post';
        RestContext.request = req;
        req.requestBody = Blob.valueOf(jsonString);
        WS_OnlineSales.getRespone();
    }
    @isTest
    public static void caseTest_1(){
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        UPDATE standardPricebook;
        
        Franchisee__c franObj=new  Franchisee__c();
        franObj.SAP_Code__c =  'kl07-050';
        INSERT franObj;
        
        String jsonString = '{ "customer_details":null }';
        Restrequest req = new Restrequest();
        req.requestURI = 'services/apexrest/onlineSales';
        req.httpMethod = 'Post';
        RestContext.request = req;
        req.requestBody = Blob.valueOf(jsonString);
        WS_OnlineSales.getRespone();
    }
}