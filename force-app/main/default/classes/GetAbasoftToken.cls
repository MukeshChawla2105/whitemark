public class GetAbasoftToken {
    
    @InvocableMethod
    public static List <Results> getAbasoftTokendetails (List<Requests> requestList) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(requestList[0].Endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String payload = 'username='+EncodingUtil.urlEncode(requestList[0].UserName,'UTF-8')+'&password='+EncodingUtil.urlEncode(requestList[0].Password,'UTF-8')+'&clientId='+EncodingUtil.urlEncode(requestList[0].clientId,'UTF-8')+'&clientSecret='+EncodingUtil.urlEncode(requestList[0].clientSecret,'UTF-8')+'&grant_type=password';
        System.debug(payload);
        
        request.setBody(payload);
        HttpResponse response = http.send(request);
        
        Results curResult = new Results();
        String responseJSON = response.getBody();
        
        
        // Parse the JSON response
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            return null;
        } else {
            System.debug(response.getBody());
            JSONAccessToken curAccess_token = JSONAccessToken.parse(responseJSON);        
            curResult.access_token = curAccess_token.access_token;
            curResult.refresh_token = curAccess_token.refresh_token;
            
            List<Results> ResultsList = new List<Results>();
            ResultsList.add(curResult);
            return resultsList;
        }  
    }
    
    
    public class Requests {
        @InvocableVariable(label='Endpoint URL' description='Endpoint URL for callout' required=true)
        public String Endpoint;
        
        @InvocableVariable(label='User Name' description='User Name for Integration' required=true)
        public String UserName;
        
        @InvocableVariable(label='Password' description='Password for Integration' required=true)
        public String Password;
        
        @InvocableVariable(label='ClientId' description='ClientId for Integration' required=true)
        public String ClientId;
        
        @InvocableVariable(label='ClientSecret' description='ClientSecret for Integration' required=true)
        public String ClientSecret;
        
    }
    
    public class Results {
        @InvocableVariable(label='Access Token' description='Access token for callout')
        public String access_token;
        
        @InvocableVariable(label='Refresh Token' description='Refresh token for callout')
        public String refresh_token;
        
    }
    
}