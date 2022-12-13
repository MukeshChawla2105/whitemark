@isTest
public class WS_CustomerDetailSyncTest {
    @isTest
    public static void testMethod1(){
        Account accObj = new Account();
        accObj.Name = 'Test Account';
        accObj.Phone = '9786543210';
        INSERT accObj;
        
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        UPDATE standardPricebook;
        
        Franchisee__c franObj=new  Franchisee__c();
        franObj.SAP_Code__c =  'KL09-007';
        INSERT franObj;
        
        String jsonString = '{ "customer_details": [ { "customer_last_name": "asas", "billing_address": { "billing_postal_code": "", "billing_country": "India", "billing_city": " California", "billing_state": "Kerala", "billing_street": "Oakland" }, "reward_point": "", "mailing_address": { "mailing_state": "Kerala", "mailing_city": " California", "mailing_street": "Oakland", "mailing_postal_code": "", "mailing_country": "India" }, "customer_first_name": "Random First Name_2", "gender": "Male", "alternate_phone": "9679020101", "email": "admin+1643806111000@rapidor.coo", "customer_phone_number": "9679020101" } ] }';
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/customerDetailsSync';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        req.requestBody = Blob.valueof(jsonString);
        
        WS_CustomerDetailSync.getRespone();
    }
}