public class TextMessageProcess {
    @auraEnabled
    public static string sendSMS(String recordId){
        
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails =[SELECT id, Api_Key__c, Message__c, Sender__c from Text_Local_API_Details__c];
        list<Account> LstAccount = [select id, lastname, phone from account where ID =: recordId];
        if(LstAccount[0].phone != null){
            String plPhoneNumber = LstAccount[0].phone.right(10);
            
            if(plPhoneNumber.isNumeric() == false  ){
                RETURN 'Please Enter Valid Phone Number..!!';
            }
            string apikey = apiDetails.Api_Key__c;
            string messages = apiDetails.Message__c;
            string sender = apiDetails.Sender__c;
            string numberse = plPhoneNumber;
            string test = string.valueof(false);
            
            HttpRequest req = new HttpRequest();        
            req.setEndpoint('https://api.textlocal.in/send/?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(messages,'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberse,'UTF-8')+'&test='+EncodingUtil.urlEncode(test,'UTF-8')+'');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            
            Http http = new Http();
            
            HTTPResponse res = http.send(req);
            string response = res.getBody();
            system.debug('response'+response);
            ResponseStructure resBody  = (ResponseStructure) JSON.deserialize(response,ResponseStructure.class);
            if(resBody.status == 'failure') {
                Execption__c e = new Execption__c();
                e.Class_Name__c = 'TextMessageProcess';
                e.Method_Name__c = 'sendSMS';
                e.Ececption_Message__c = response;
                INSERT e;
                RETURN 'Exception Occured..!!';
                
            }else{
                RETURN 'Message Sent SuccessFully..!!';
            }
        }
        RETURN 'Cannot Find Phone Number..!!';     
    }
    public class ResponseStructure {
        public String status;
    }    
}