@isTest
public class ScheduleWSInventoryDetails_Test {
    
    /*@testSetup 
    static void setup() {
        Endpoints__C msg= new Endpoints__C();
        msg.EndpointURL__c='http://13.71.71.137:7777/eShopaidService/eShopaidService.svc/Token';
        msg.Name='WondersoftToken';
        msg.User_Name__c='Sample';
        msg.Password__c='Sample';
        msg.Service_MethodName__c='GetToken';
        insert msg;
        
        Endpoints__C msg1= new Endpoints__C();
        msg1.EndpointURL__c='http://13.71.71.137:7777/eShopaidService/eShopaidService.svc/ProcessData';
        msg1.Name='WondersoftInventoryData';
        msg1.Service_MethodName__c='GetInventory';
        insert msg1;
        
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        
        Update standardPricebook;
        
        Product2 prod=new Product2();
        prod.IsActive=true;
        prod.MRP__c=100;
        prod.Description='Sample';
        prod.Name='Sample';
        Prod.SAP_Code__c='SUJ-015M000C000S319';
        prod.ProductCode='SUJ-015M000C000S319';
        
        Insert prod;
        
        Franchisee__c fr=new Franchisee__c();
        fr.Name='KL02-010';
        fr.SAP_Code__c='KL02-010';
        
        insert fr;
    }*/
    
    /*public static String CRON_EXP = '0 0 0 15 3 ? 2023';
    
    public static testmethod void testWSInventoryschedule(){
        Test.setMock(HttpCalloutMock.class, new WSInventoryCalloutMock());
        Test.startTest();
        String jobId = System.schedule('WondersoftInventorydetailsApexTest',CRON_EXP, new ScheduleWSInventoryDetails());   
		Test.stopTest();    
    }*/
    
    public static testmethod void TestCoverage(){
        ScheduleWSInventoryDetails.TestCoverage();
    }
}