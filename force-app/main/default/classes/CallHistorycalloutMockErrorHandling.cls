@isTest
global class CallHistorycalloutMockErrorHandling implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(request.getEndpoint()=='http://whitemart.aabasoft.in/api/oauth2/token'){
            response.setBody('{"access_token":"V0HKRrB2ciUMDIleF6xCtVtAtmCOzcFIey_PYfXVeXekCLXh7ivQYDjMtFPxhfMzepUPFbxbAMeEzg-vRzNHQvSt1o52qws3VIjFRJIJZ68hx50qIiAla-gyXby0yRgm9kTk4bC9Z6JwAOKEMjNS1oVYKC6X7pah5yERg58TmZIi6yFsRtwjWNxOzZx-9r6xOR8n1_uzt0bJoIP3tE42xt6u1aIE90QjP8wKqwDu31s","token_type":"bearer","expires_in":299,"refresh_token":"cMxXWMSOeKZAOilSTjvwAsBsBQoSjdSEtHogLjvwX6vn2EKOaY4Q91GusMHbLzSI1nvlrTwTv_mykMEkTlq__yPBAVc_sfZdJbQKbxu5c6-jvV1R3kOoe4w_kIGdDodgQWVNcIvOlJzazj5kAQtmPmtGZZ7EA8qUD35Zjq1IXxe3ukovPGebpyg-44LKWANhgRSPfNNkdI-iAPzUdqTQscgSzhClE6r9Xc69IPLLy4k"}');
        
        }else{
            response.setBody('{"message": "No Record Found","errorCode": "NO_RECORD_FOUND","fieldErrors": []}');
        
        }
        //response.setBody('{"isSuccess":true,"message":"Success","data":[{"callStartedOn":"2020-07-07T08:58:00Z","callDate":"2020-07-07T00:00:00","uniqueIdentifier":"1","source":"9072689513","destination":"9061970421","duration":"00:02:27","callRecordingURL":"http://whitemart.aabasoft.in/call/PlayRecording.aspx?q=5f03ebb25ab153.75089421","callStatus":"ANSWER"},{"callStartedOn":"2020-07-07T09:01:00Z","callDate":"2020-07-07T00:00:00","uniqueIdentifier":"2","source":"9072689513","destination":"9745049831","duration":"00:01:53","callRecordingURL":"http://whitemart.aabasoft.in/call/PlayRecording.aspx?q=5f03ec857d0a26.64012663","callStatus":"ANSWER"}]}');
        response.setStatusCode(200);
        return response; 
    }
}