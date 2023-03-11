@istest
public class usertrackingandScorecardTriggertest {
	
  @isTest(SeeAllData=true)
 static void validateHelloWorld() {
    User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'SYSTEM ADMINISTRATOR'].Id,
     LastName = 'Admin',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
);
     INSERT U;
 user_tracking__c b = new user_tracking__c();
     insert b;
     Scorecard__c sc = new Scorecard__c();
     sc.Enabled__C = true;
     insert sc;
     sc.Enabled__C = false;
     update sc;
         
 
 }
    @isTest(SeeAllData=true)
 static void validateHelloWorld1() {
    
     Scorecard__c sc = new Scorecard__c();
     sc.Enabled__C = true;
     insert sc;
     sc.Enabled__C = false;
     update sc;
         
 
 }
}