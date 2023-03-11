global class BatchonCampaignTextLocalImmediately implements Database.Batchable<sObject>,Database.stateful, Database.AllowsCallouts{
    
    List<string> lststring = new List<string>();
    private String strParameter;
    public List<String> lstphonenumbers = new List<string>();
    public BatchonCampaignTextLocalImmediately(String strParam, list<string> phonenumbers) {
        strParameter = strParam;
        for(string s : phonenumbers){
            lstphonenumbers.add(s);
        }
        lstphonenumbers = phonenumbers;
        system.debug('strParameter'+strParameter);
        system.debug('ph'+lstphonenumbers);
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query = 'SELECT ContactId, Contact.Name, phone, Contact.Phone, LeadId FROM CampaignMember WHERE CampaignId=: strParameter ' ;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<CampaignMember> scope) {
        system.debug('scope'+scope);
        system.debug('scope.size()'+scope.size());
        system.debug('strParameter'+strParameter);
        system.debug('lstphonenumbers'+lstphonenumbers);
        string dateTimeStr;
        
        list<Campaign> c = [select id, Scheduled_at__c, Scheduled_Date_Time__c from Campaign where id=: strParameter];
        if(c[0].Scheduled_Date_Time__c != null ){
            system.debug('test'+c[0].Scheduled_Date_Time__c);
            DateTime dt = c[0].Scheduled_Date_Time__c;
            dateTimeStr = dt.format('yyyy-MM-dd-hh-mm-ss');
            system.debug('datetime'+dateTimeStr);
        }
        
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails =[SELECT id, Api_Key__c, Message__c, Sender__c from Text_Local_API_Details__c];
        if(scope != null){
            for(CampaignMember cont:scope ){
                if(cont.Phone != null && cont.Phone.isNumeric() == true){  
                    system.debug('con'+cont.Phone);
                    lststring.add(cont.Phone.right(10));
                }
            }   
        }
        system.debug('lststring'+lststring);
        system.debug('lststring.size()'+lststring.size());
        string apikey = apiDetails.Api_Key__c;
        string messages = apiDetails.Message__c;
        string sender = apiDetails.Sender__c;
        string numberse = string.valueof(lststring);
        // string numberse = '8374728729,scd';
        string test = string.valueof(true);
        
        HttpRequest req = new HttpRequest();  
        req.setEndpoint('https://api.textlocal.in/send/?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(messages,'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberse,'UTF-8')+'&test='+EncodingUtil.urlEncode(test,'UTF-8')+'&scheduledFor='+EncodingUtil.urlEncode(dateTimeStr,'UTF-8')+'');
        //  req.setEndpoint('https://api.textlocal.in/send/?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(messages,'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberse,'UTF-8')+'&test='+EncodingUtil.urlEncode(test,'UTF-8')+'');
        
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        Http http = new Http();
        
        HTTPResponse res = http.send(req);
        string response = res.getBody();
        system.debug('response'+response);
        
        if(response.contains('Invalid number')){
            system.debug('failed');
            Execption__c e = new Execption__c();
            e.Class_Name__c = 'TextMessageProcess';
            e.Method_Name__c = 'sendSMS';
            e.Ececption_Message__c = response;
            INSERT e;
            //TextLocalBulkMessage_Campaign.sendBulkSMS('failed');            
        }else{
            system.debug('success');
            // TextLocalBulkMessage_Campaign.sendBulkSMS('success');
        }
    }   
    global void finish(Database.BatchableContext BC) {
        system.debug('lststring'+lststring.size());
        system.debug('lstphonenumbers'+lstphonenumbers.size());
        set<string> set1 = new set<string>(lstphonenumbers);
        
        set1.removeAll(lststring); 
        system.debug('set1'+set1);
        string invalidnumbers = string.valueOf(set1);
        List<string> listed = new List<string>();
        listed.addall(set1);
        system.debug('listed'+listed);
        string passvalue = 'Invalid Numbers. Could not process for this numbers'+listed+'';
        system.debug('passvalue'+passvalue);
        // TextLocalBulkMessage_Campaign.toastMessage(invalidnumbers, listed);
        TextLocalBulkMessage_Campaign.sendBulkSMS('', passvalue);
        
    }  
}