@istest
public class WishlistCartItemSMSBatch_Test {
    @testSetup static void setup() {
        Text_Local_API_Details__c textObj=new Text_Local_API_Details__c();
        textObj.Name='Seltos';
        textObj.Message__c='today is thursday';
        textObj.Admin_Email__c='whitemart@invalid.com';
        textObj.Sender__c='Local Server';
        textObj.Api_Key__c = '1212121212';
        INSERT textObj;
        
        Account accObj = new Account();
        accObj.Name = 'Test';
        accObj.BillingCity = 'Nagpur';
        accObj.Phone='9895761975';
        INSERT accObj;
        
        Product2 proObj=new Product2();
        proObj.SAP_Code__c ='sag-022m209c480000';
        proObj.Name='test001';
        proObj.Brand__c = 'BAJAJ';
        proObj.Family = 'Air Conditioner';
        INSERT proObj;
        
        Wishlist_Cart_Items__c wcObj = new Wishlist_Cart_Items__c();
        wcObj.Type__c='Wish List';
        wcObj.Customer__c=accObj.Id;
        wcObj.Product__c = proObj.Id;
        INSERT wcObj;
    }
    static testmethod void positiveTest() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/WishlistCartItemSMSBatch';
        req.httpMethod = 'POST';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WishlistCartItemSMSMock());
        WishlistCartItemSMSBatchSchedular batchObj = new WishlistCartItemSMSBatchSchedular();
        SchedulableContext sc;
        batchObj.execute(sc);
        Test.stopTest();
    }
}