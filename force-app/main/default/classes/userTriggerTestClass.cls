@isTest
public class userTriggerTestClass {
    
    static testMethod void validateHelloWorld() {
        User_Tracking__c usertrack = new User_Tracking__c(Checkin_Datetime__c=system.now(), Member__c = userinfo.getUserId());
        
        Test.startTest();
        // Insert book
        insert usertrack;
        
        Test.stopTest();
        
        // Retrieve the new book
        usertrack = [SELECT id, Checkin_Datetime__c, Member__c FROM User_Tracking__c WHERE Id =:usertrack.Id];
        System.debug('Price after trigger fired: ' + usertrack);
        
    }
    
}