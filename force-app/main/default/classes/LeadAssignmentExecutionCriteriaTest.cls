@isTest
public class LeadAssignmentExecutionCriteriaTest {
    @isTest
    public static void main(){
        LeadAssignmentExecutionCriteria.TestCoverage();
    }
    @isTest
    public static void roundRobinTestMethod(){
        RoundRobinForBAtchApex.TestCoverage();
    }
    @isTest(seeallData = true)
    public static void CreateLeads(){
        test.startTest();
        LeadAssignmentBatch lab = new LeadAssignmentBatch();
        database.executeBatch(lab);
        test.stopTest();
    }
    @isTest
    public static void batchTestMethod(){
        LeadAssignmentBatch.TestCoverage();
    }
    @isTest(seeallData = true)
    public static void ScheduleBatchTestMethod(){
        
        
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        String CRON_EXP = '0 6 * * * ?';
        
        Test.startTest();
        
        String jobId = System.schedule('Update Contacts',  CRON_EXP, new ScheduleBatchToAssignLeads());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }
}