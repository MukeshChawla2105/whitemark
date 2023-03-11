@isTest
public class LeadTriggerHandler_Test {
    @testSetup static void setup() {
        
        DefaultGroupAssignment__c dgc = new DefaultGroupAssignment__c();
        dgc.name = 'Global Lead Team';
        insert dgc;//[Select id,Name,Group_Id__c from DefaultGroupAssignment__c where name = 'Global Lead Team'][0];
        Lead leadObj = new Lead();
        leadObj.Phone = '8055208289';
        leadObj.lastName = 'Kumar_1';
        leadObj.Status = 'New';
        leadObj.LeadSource = 'Facebook';
        leadObj.Enquiry_Type__c = 'Service';
        INSERT leadObj;
    }
    @isTest
    public static void mainTest(){
        DefaultGroupAssignment__c dgc = new DefaultGroupAssignment__c();
        dgc.name = 'Global Lead Team';
        insert dgc;//[Select id,Name,Group_Id__c from DefaultGroupAssignment__c where name = 'Global Lead Team'][0];Lead leadObj_1 = new Lead();
        Lead leadObj_1 = new Lead();
        leadObj_1.Phone = '8055208289';
        leadObj_1.lastName = 'Kumar';
        leadObj_1.Status = 'Call back';
        leadObj_1.LeadSource = 'Facebook';
        leadObj_1.Enquiry_Type__c = 'Service';
        INSERT leadObj_1;
    }
}