public class PostClicktoCall {
    @InvocableMethod
    public static List <Results> PostClicktoCalldetails (List<Requests> requestList) {
        String authorizationHeader;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(requestList[0].Endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        authorizationHeader = 'Bearer ' + requestList[0].accessToken;
        request.setHeader('Authorization', authorizationHeader);
        
        //String payload = '{"sourceMobileNumber":"'+EncodingUtil.urlEncode(requestList[0].sourceMobileNumber,'UTF-8')+'","destinationMobileNumber":"'+EncodingUtil.urlEncode(requestList[0].destinationMobileNumber,'UTF-8')+'"}';
        String payload = '{"sourceMobileNumber":"'+requestList[0].sourceMobileNumber+'","destinationMobileNumber":"'+requestList[0].destinationMobileNumber+'"}';
        
        System.debug(payload);
        
        request.setBody(payload);
        //request.setBody('{"sourceMobileNumber":"9344784735","destinationMobileNumber":"7550072663"}');
        HttpResponse response = http.send(request);    
        
        Results curResult = new Results();
        String responseJSON = response.getBody();
        
        
        if (response.getStatusCode() != 200) {
            System.debug('---->Call out The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            return null;
        } else {
            JSONclicktocall curCallmessage = JSONclicktocall.parse(responseJSON);        
            curResult.isSuccess = curCallmessage.isSuccess;
            curResult.Message = curCallmessage.message;
            curResult.uniqueCallId = curCallmessage.data;
            
            List<Results> ResultsList = new List<Results>();
            ResultsList.add(curResult);
            return resultsList;
        }
        
        
    }
    public class Requests {
        @InvocableVariable(label='Click to Call Endpoint URL' description='clicktocall Endpoint URL for callout' required=true)
        public String Endpoint;
        
        @InvocableVariable(label='Access Token' description='Access Token for Integration' required=true)
        public String accessToken;
        
        @InvocableVariable(label='Source Mobile Number' description='sourceMobileNumber for callout' required=true)
        public String sourceMobileNumber;
        
        @InvocableVariable(label='Destination Mobile Number' description='destinationMobileNumber for Integration' required=true)
        public String destinationMobileNumber;
        
    }
    
    public class Results {
        @InvocableVariable(label='isSuccess' description='isSuccess for callout')
        public Boolean isSuccess;
        
        @InvocableVariable(label='Message' description='Call out result message')
        public String Message;
        
        @InvocableVariable(label='Unique call Id' description='Unique call Id')
        public String uniqueCallId;
        
    }
    
}