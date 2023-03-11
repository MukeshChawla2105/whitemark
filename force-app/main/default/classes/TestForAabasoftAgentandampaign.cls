@istest
public class TestForAabasoftAgentandampaign {
    
    static testMethod void validateHelloWorld() {
        
        List<Task> tasks = new List<Task>{};
            Task t = new Task(Subject='Welcome Call',Status='New',Priority='Normal',CallType='Outbound');
        
        Campaign__c camp = new Campaign__c(Campaign_Subject__c = 'Happy call', Campaign_ID__c = 'COICVNOVBAP320RN4PNV93F', Name__c = 'Sales');
        AbbaSoft_User__c abauser  = new AbbaSoft_User__c(First_Name__c='mike', Assignment_Id__c=1, Campaign__c = camp.Id, IsTaskAssigned__c= false,
                                                                AabaSoft_UserName__c='mkes@gmail.com');
        
        Test.startTest();
        insert camp;
        insert abauser;
        insert t;
        
        //TaskAssignmentToAabaSoftAgent.TaskAssignment_v1(camp.Campaign_ID__c);
        
        Test.stopTest();
        
        // Retrieve the new book
        abauser = [SELECT First_Name__c FROM AbbaSoft_User__c WHERE Id =:abauser.Id];
    }
    
}