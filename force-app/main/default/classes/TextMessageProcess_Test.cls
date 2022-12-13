@isTest
global class TextMessageProcess_Test implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type', 'application/json');
        //  response.setBody('{"test_mode": true,"balance": 16,"batch_id": 99,"cost": 1,"num_messages": 1,"message": {"num_parts": 1, "sender": "WHMART","content": "Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart"},  "receipt_url": "", "custom": "", "messages": [{"id": 1,"recipient": 918374728729}], "status": "success"}');
        response.setBody('{"warnings":[{"code":3,"message":"Invalid number"}],"errors":[{"code":4,"message":"No recipients specified"}],"status":"failure"}');
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
        acc.Phone = '8377878999';
        INSERT acc;
        
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new TextMessageProcess_Test()); 
        TextMessageProcess.sendSMS(acc.Id);        
        Test.stopTest();
        
    }
    public static testmethod void test1(){
        
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails.Api_Key__c = 'NmY0NjU5NmE0ODc0NTU3OTU1NTQzMjczNDgzMzUwMzg=';
        apiDetails.Message__c = 'Hello, you can enable communication with Whitemart on WhatsApp. To start, please click here wa.me/918590136123?text=Hi.\nThanks\nWhitemart';
        apiDetails.Sender__c = 'WHMART';
        INSERT apiDetails; 
        
        Account acc1 = new Account();
        acc1.Name = 'test data';
        acc1.Phone = 'sdkjvcbsdj';
        INSERT acc1;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TextMessageProcess_Test()); 
        TextMessageProcess.sendSMS(acc1.Id);        
        Test.stopTest();
        
    }
}