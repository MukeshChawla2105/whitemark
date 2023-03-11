@isTest
global class TextMessageProcessErrorUnit_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse response = new HTTPResponse(); 
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"warnings":[{"code":3,"message":"Invalid number"}],"errors":[{"code":4,"message":"No recipients specified"}],"status":"Success"}');
        response.setStatusCode(200);
        return response;
    } 
    
    public static testmethod void test(){    
        
         Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails.Api_Key__c = 'NmY0NjU5NmE0ODc0NTU3OTU1NTQzMjczNDgzMzUwMzg=';
        apiDetails.Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart';
        apiDetails.Sender__c = 'WHMART';
        INSERT apiDetails;
        
        Account acc = new Account();
        acc.Name = 'test data';
        acc.Phone = '';
        INSERT acc;
        
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new TextMessageProcessErrorUnit_Test()); 
        TextMessageProcess.sendSMS(acc.Id);        
        Test.stopTest();
        
    }
    public static testmethod void test1(){  
        
         Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails.Api_Key__c = 'NmY0NjU5NmE0ODc0NTU3OTU1NTQzMjczNDgzMzUwMzg=';
        apiDetails.Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart';
        apiDetails.Sender__c = 'WHMART';
        INSERT apiDetails;
        
        Account acc = new Account();
        acc.Name = 'test data';
        acc.Phone = '8377878999';
        INSERT acc;
        
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new TextMessageProcessErrorUnit_Test()); 
        TextMessageProcess.sendSMS(acc.Id);        
        Test.stopTest();
        
    }
}