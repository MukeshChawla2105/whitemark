public class GetWondersoftToken {
    public HttpResponse GetWondersoftTokenDetails(String EP,String UN, String PW, String SMN){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(EP);
        String username = UN;
        String password = PW;
        String ServiceMethodName = SMN;
        
        request.setHeader('Content-Length', '0');
        request.setHeader('Username', username);
        request.setHeader('Password', password);
        request.setHeader('SERVICE_METHODNAME', ServiceMethodName);
        request.setHeader('Accept', '*/*');
        request.setHeader('Content-Type', 'application/json');
        
        request.setMethod('POST');
        HttpResponse response = http.send(request);
        
        return response;
    }
    
    
}