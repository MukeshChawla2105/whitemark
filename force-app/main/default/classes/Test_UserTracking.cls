@isTest
public class Test_UserTracking {
    @isTest
    public static void test_method(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
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
        User_Tracking__c userTrack = new User_Tracking__c();
        userTrack.Member__c = u.Id;
        userTrack.Checkin_Datetime__c = system.today();
        insert userTrack;
    }
}