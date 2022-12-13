public class GetWondersoftData {
    public HttpResponse GetWSData(String EP, String Auth, String SMN,String FD, String TD){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(EP);
        String curAuthToken = Auth;
        String ServiceMethodName = SMN;
        String FromDate = FD;
        String ToDate = TD;
        
        request.setHeader('Content-Length', '0');
        request.setHeader('HEADER_PAGINGENABLED', '0');
        request.setHeader('Authorization', curAuthToken);
        request.setHeader('HEADER_FROMDATE', FromDate);
        request.setHeader('HEADER_TODATE', ToDate);
        request.setHeader('SERVICE_METHODNAME', ServiceMethodName);
        request.setHeader('Accept', '*/*');
        request.setHeader('Content-Type', 'application/json');
        
        request.setMethod('POST');
        HttpResponse response = http.send(request);
        
        return response;
    }
    
}