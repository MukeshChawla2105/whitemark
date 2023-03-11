public class TextMessageTextLocal {
    
    public static void sendSMS(string numberse){
        
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails =[SELECT id, Api_Key__c, Message__c, Sender__c from Text_Local_API_Details__c];
        
        string apikey = apiDetails.Api_Key__c;
        string messages = apiDetails.Message__c;
        string sender = apiDetails.Sender__c;
        numberse = '918374728729,9618518945';
        
        HttpRequest req = new HttpRequest();   
        
         req.setEndpoint('https://api.textlocal.in/send/?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(messages,'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberse,'UTF-8')+'');
     //   req.setEndpoint('https://api.textlocal.in/bulk_json?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(messages,'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberse,'UTF-8')+'' );
        
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        Http http = new Http();
        
        HTTPResponse res = http.send(req);
        string response = res.getBody();
        system.debug('response'+response);
        system.debug('res.getStatusCode()'+res.getStatus());
        
    }
}