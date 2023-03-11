@isTest
global class ClicktoCallErrorHttpCalloutMock implements HttpCalloutMock{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"isSuccess":true,"message":"Success","data":"5f044e1f0750b9.80279197"}');
        response.setStatusCode(201);
        return response; 
    }

}