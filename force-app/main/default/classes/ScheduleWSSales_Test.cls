@isTest
public class ScheduleWSSales_Test {
    @testSetup 
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
        msg1.Name='WondersoftPullSales';
        msg1.Service_MethodName__c='PullSales';
        
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
        
        List<RecordType > RT= [SELECT DeveloperName,Id,SobjectType FROM RecordType WHERE DeveloperName = 'PersonAccount'];
        
        Account acc= New Account();
        acc.RecordTypeId=RT[0].Id;
        acc.LastName='Sample';
        acc.Status__c='Active';
        acc.Type='Customer';
        acc.Phone='9632147856';
        
        insert acc;
    
    }
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2023';
    public static testmethod void testWSSaleschedule(){
        Test.setMock(HttpCalloutMock.class, new WSSalesCalloutMock());
        Test.startTest();
        String jobId = System.schedule('WondersoftSalesApexTest',CRON_EXP, new ScheduleWSSales()); 
        String jobId2 = System.schedule('WondersoftPrevSalesApexTest',CRON_EXP, new ScheduleWSPrevSales());  
        String jobId3 = System.schedule('WondersoftSalesRetApexTest',CRON_EXP, new ScheduleWSSalesReturn()); 
        String jobId4 = System.schedule('WondersoftPrevSalesRetApexTest',CRON_EXP, new ScheduleWSPrevSalesReturn());  
        Test.stopTest();    
    }
    
    public static testmethod void TestCoverage(){
        ScheduleWSSales.TestCoverage();
    }

}