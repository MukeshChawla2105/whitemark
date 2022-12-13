@isTest
public class WS_FranchiseeInventorySync_Test {
    @isTest
    public static void testMethod_1(){
        String jsonString = '{ "franchisee_details": null }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/franchiseeInventorySync';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        WS_FranchiseeInventorySync.getRespon();
    }
    @isTest
    public static void testMethod_2(){
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        accObj.Phone = '9786543210';
        INSERT accObj;
        
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        UPDATE standardPricebook;
        
        Franchisee__c franObj=new  Franchisee__c();
        franObj.SAP_Code__c =  'KL09-007';
        INSERT franObj;
        
        Inventory__c invObj = new Inventory__c();
        invObj.Franchisee__c = franObj.Id;
        INSERT invObj;
        
        String jsonString = '{ "franchisee_details": { "franchisee_code": "KL09-007", "inventory_details": [ { "product_code": "SAG-022M209C482S157", "available_quantity": "11" }, { "product_code": "SAG-022M209C482S159999", "available_quantity": "19" } ] } }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/franchiseeInventorySync';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        WS_FranchiseeInventorySync.getRespon();
    }
    @isTest
    public static void testMethod_3(){
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        accObj.Phone = '9786543210';
        INSERT accObj;
        
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        UPDATE standardPricebook;
        
        Franchisee__c franObj=new  Franchisee__c();
        franObj.SAP_Code__c =  'KL09-007';
        INSERT franObj;
        
        String jsonString = '{ "franchisee_details": { "franchisee_code": "KL09-007", "inventory_details": [ { "product_code": "SAG-022M209C482S157", "available_quantity": "11" }, { "product_code": "SAG-022M209C482S159999", "available_quantity": "19" } ] } }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/franchiseeInventorySync';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        WS_FranchiseeInventorySync.getRespon();
    }
     @isTest
    public static void testMethod_4(){
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        accObj.Phone = '9786543210';
        INSERT accObj;
        
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        UPDATE standardPricebook;
        
        String jsonString = '{ "franchisee_details": { "franchisee_code": "KL09-007", "inventory_details": [ { "product_code": "SAG-022M209C482S157", "available_quantity": "11" }, { "product_code": "SAG-022M209C482S159999", "available_quantity": "19" } ] } }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/franchiseeInventorySync';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        WS_FranchiseeInventorySync.getRespon();
    }
}