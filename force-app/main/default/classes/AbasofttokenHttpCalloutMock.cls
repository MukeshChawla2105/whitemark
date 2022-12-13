@isTest
global class AbasofttokenHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"access_token":"V0HKRrB2ciUMDIleF6xCtVtAtmCOzcFIey_PYfXVeXekCLXh7ivQYDjMtFPxhfMzepUPFbxbAMeEzg-vRzNHQvSt1o52qws3VIjFRJIJZ68hx50qIiAla-gyXby0yRgm9kTk4bC9Z6JwAOKEMjNS1oVYKC6X7pah5yERg58TmZIi6yFsRtwjWNxOzZx-9r6xOR8n1_uzt0bJoIP3tE42xt6u1aIE90QjP8wKqwDu31s","token_type":"bearer","expires_in":299,"refresh_token":"cMxXWMSOeKZAOilSTjvwAsBsBQoSjdSEtHogLjvwX6vn2EKOaY4Q91GusMHbLzSI1nvlrTwTv_mykMEkTlq__yPBAVc_sfZdJbQKbxu5c6-jvV1R3kOoe4w_kIGdDodgQWVNcIvOlJzazj5kAQtmPmtGZZ7EA8qUD35Zjq1IXxe3ukovPGebpyg-44LKWANhgRSPfNNkdI-iAPzUdqTQscgSzhClE6r9Xc69IPLLy4k"}');
        response.setStatusCode(200);
        return response; 
    }
}