@isTest
public class GetCallHistoryDetails_Test {
    @testSetup 
    static void setup() {
        List<Task> tsks= new List<Task>();
        for (Integer i = 0; i < 10; i++) {
            tsks.add(New Task(
                AbasoftId__c='Sample'+i,
                callRecordingURL__c='',
                Call_Status__c='PENDING',
                Status='Open'
            ));
        }
        insert tsks;
    }
    static testmethod void testQueueable() {
        Test.setMock(HttpCalloutMock.class, new CallHistorycalloutMock());

        Test.startTest();  
        //system.enqueueJob(New GetCallHistoryDetails('2020-07-07','2020-07-07'));
        ScheduleQueueableGetCallHistoryDetails m = new ScheduleQueueableGetCallHistoryDetails();
        String sch = '0 0 12 * * ?';
        String jobID = system.schedule('ScheduleGetCallHistoryDetails_Batch', sch, m);
        Test.stopTest(); 
        
    }

    static testmethod void testQueueable1() {
        Test.setMock(HttpCalloutMock.class, new CallHistorycalloutMockErrorHandling());

        Test.startTest();  
        //system.enqueueJob(New GetCallHistoryDetails('2020-07-07','2020-07-07'));
        ScheduleQueueableGetCallHistoryDetails m = new ScheduleQueueableGetCallHistoryDetails();
        String sch = '0 0 12 * * ?';
        String jobID = system.schedule('ScheduleGetCallHistoryDetails_Batch', sch, m);
        Test.stopTest(); 
        
    }

}