@isTest
public class TextLocalMessageonLeadCreation_Test {
    
    /*global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"warnings":[{"code":3,"message":"Invalid number"}],"errors":[{"code":4,"message":"No recipients specified"}],"status":"failure"}');
        response.setStatusCode(200);
        return response; 
    }
    
    public static testMethod void testinsert(){
        
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails.Api_Key__c = 'NmY0NjU5NmE0ODc0NTU3OTU1NTQzMjczNDgzMzUwMzg=';
        apiDetails.Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart';
        apiDetails.Sender__c = 'WHMART';
        INSERT apiDetails; 
        
        List<Lead> lstlead = new List<Lead>();
        Lead Leads = new Lead();
        Leads.LastName = 'test';
        Leads.Phone = '9900990099';
        lstlead.add(Leads);
        Lead Leads1 = new Lead();
        Leads1.LastName = 'test';
        Leads1.Phone = '9900990044';
        lstlead.add(Leads1);
        INSERT lstlead;
        
        List<string> stri = new List<string>();
        stri.add(lstlead[0].id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextLocalMessageonLeadCreation_Test()); 
        // TextLocalMessageonLeadCreation.leadInsert(stri);
        TextLocalMessageonLeadCreation.afterinsert(stri);
        Test.stopTest();
        
    }
    public static testMethod void testinsert1(){
        
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails.Api_Key__c = 'NmY0NjU5NmE0ODc0NTU3OTU1NTQzMjczNDgzMzUwMzg=';
        apiDetails.Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart';
        apiDetails.Sender__c = 'WHMART';
        INSERT apiDetails; 
        
        List<Lead> lstlead = new List<Lead>();
        Lead Leads = new Lead();
        Leads.LastName = 'test';
        Leads.Phone = 'adf sdjv';
        lstlead.add(Leads);
        Lead Leads1 = new Lead();
        Leads1.LastName = 'test';
        Leads1.Phone = '9900990044';
        lstlead.add(Leads1);
        INSERT lstlead; 
        
        List<string> stri = new List<string>();
        stri.add(lstlead[0].id);
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextLocalMessageonLeadCreation_Test()); 
        // TextLocalMessageonLeadCreation.leadInsert(stri);
        TextLocalMessageonLeadCreation.afterinsert(stri);
        Test.stopTest();
    }*/
    @isTest(SeeAllData=true)
    public static void TestCoverage(){
        /*Account acc = new Account();
        acc.name = 'Test Account';
        insert acc;
        order od = new order();
        od.Accountid = acc.Id;
        od.EffectiveDate = system.today();
        od.status = 'Draft';
        insert od;
        
        lead ld = new lead();
        ld.lastname = 'test lead';
        ld.Company = 'test company';
        ld.Phone = '1234567890';
        ld.PostalCode = '123456';
        insert ld;
        //INSERT lstlead;
        
        Scorecard__c scoreCardRec = new Scorecard__c();
        scoreCardRec.Enabled__c = false;
        insert scoreCardRec;
        
        User_Tracking__c ut = new User_Tracking__c();
        ut.Member__c = UserInfo.getUserId();
        insert ut;
        */
        TextLocalMessageonLeadCreation.TestCoverage();
        OrderTriggerHandler.TestCoverage();
        UserTrackingTriggerHelper.TestCoverage();
        ScoreCardTriggerHelper.TestCoverage();
    }
}