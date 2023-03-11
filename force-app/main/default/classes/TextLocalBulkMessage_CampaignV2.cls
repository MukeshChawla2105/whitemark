public class TextLocalBulkMessage_CampaignV2 {
    @auraEnabled
    public static string sendBulkSMS(String recordId){
        List<string> validatednumbers = new List<string>();
        Map<string, string> mapsr = new Map<string, string>();
        Map<string, string> mapsr1 = new Map<string, string>();
        List<string> conList = new List<string>();
        List<string> lst = new List<string>();
        string dateTimeStr;
        
        Campaign Campaigndata = new Campaign();
        Campaigndata =[select id, name, Scheduled_at__c, Text_Message__c,Scheduled_Date_Time__c,isActive from Campaign WHERE id=: recordId];
        if(Campaigndata.isActive == false){
            Return 'Please select active campaign';
        }
        if(Campaigndata.Scheduled_at__c == null || Campaigndata.Scheduled_at__c == ''){
            Return 'Please select Schedule at';
        }
        
        if(Campaigndata.Scheduled_at__c != null || Campaigndata.Scheduled_at__c != ''){
            if(Campaigndata.Scheduled_at__c == 'Specific Date/Time' && Campaigndata.Scheduled_Date_Time__c == null){
                Return 'Please select Scheduled date/time';
            }
            if(Campaigndata.Scheduled_at__c == 'Specific Date/Time' && Campaigndata.Scheduled_Date_Time__c<System.now()){
                Return 'Scheduled date/time should be future date/time';
            }
            if(Campaigndata.Scheduled_Date_Time__c != null ){
                system.debug('test1'+Campaigndata.Scheduled_Date_Time__c);
                DateTime dt = Campaigndata.Scheduled_Date_Time__c;
                dateTimeStr = dt.format('yyyy-MM-dd-hh-mm-ss');
            }
            Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
            apiDetails =[SELECT id, Api_Key__c, Message__c, Sender__c from Text_Local_API_Details__c];
            
            List<CampaignMember> listofcam = [SELECT ContactId,LeadOrContactId, phone, Contact.Name,Name, LeadId FROM CampaignMember WHERE CampaignId=: recordId];
            if(listofcam != null && apiDetails != null ){
                string apikey = apiDetails.Api_Key__c;
                string sender = apiDetails.Sender__c;
                string messages = Campaigndata.Text_Message__c;
                string test1 = string.valueof(false);
                
                for(CampaignMember cont : listofcam ){
                    validatednumbers.add(cont.Phone);
                    mapsr1.put(cont.Phone, cont.Name);
                    if(cont.Phone != null && cont.Phone.isNumeric() == true && cont.Phone != ''){  
                        conList.add(cont.Phone.right(10));
                        lst.add(cont.Phone.right(10));
                        mapsr.put(cont.Phone, cont.Name);
                        string numberse = string.valueof(conList);
                        
                        if(conList.size() == 30){
                            System.debug(conList);
                            for(String s:conList){
                                System.debug(s);
                            }
                            HttpRequest req = new HttpRequest();  
                            if(Campaigndata.Scheduled_at__c == 'Specific Date/Time' && Campaigndata.Scheduled_Date_Time__c != null){
                                req.setEndpoint('https://api.textlocal.in/send/?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(messages,'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberse,'UTF-8')+'&test='+EncodingUtil.urlEncode(test1,'UTF-8')+'&scheduledFor='+EncodingUtil.urlEncode(dateTimeStr,'UTF-8')+'');
                            }else{
                                req.setEndpoint('https://api.textlocal.in/send/?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(messages,'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberse,'UTF-8')+'&test='+EncodingUtil.urlEncode(test1,'UTF-8')+'');
                            }
                            req.setMethod('POST');
                            req.setHeader('Content-Type','application/json');
                            Http http = new Http();
                            
                            HTTPResponse res = http.send(req);
                            string response = '';
                            System.debug(res.getBody());
                            if(res.getBody().containsIgnoreCase('warnings') || res.getBody().containsIgnoreCase('errors')){
                                if(res.getBody().containsIgnoreCase('Invalid number')){
                                        response = response+' Invalid number \n';
                                }
                                if(res.getBody().containsIgnoreCase('No recipients specified')){
                                    response = response+' No recipients specified \n';
                                }
                                if(res.getBody().containsIgnoreCase('Insufficient credits')){
                                        response = response+' Insufficient credits kinldy check with textLocal team \n';
                                }
                                if(res.getBody().containsIgnoreCase('Message too long')){
                                        response = response+' Message too long. \n';
                                }
                                if(res.getBody().containsIgnoreCase('Invalid number format')){
                                        response = response+' Invalid number format. \n';
                                }
                                if(res.getBody().containsIgnoreCase('Invalid sender name')){
                                        response = response+' Invalid sender name. \n';
                                }
                                if(res.getBody().containsIgnoreCase('No sender name specified')){
                                        response = response+' No sender name specified \n';
                                }
                                if(res.getBody().containsIgnoreCase('Invalid Template')){
                                    response = response+' Invalid Template. The message given didnt match any approved templates on your account. \n';
                                }
                                if(res.getBody().containsIgnoreCase('Schedule time is outside that allowed')){
                                    response = response+' Schedule time is outside that allowed. \n';
                                }
                                if(res.getBody().containsIgnoreCase('You cannot send message at this time')){
                                    response = response+' You cannot send message at this time. \n';
                                }
                                return response;
                            }
                            
                            conList.clear();
                        }
                    }
                }
                if(conList != null){
                    
                    string numberses = string.valueOf(conList);
                    HttpRequest req = new HttpRequest(); 
                    if(Campaigndata.Scheduled_at__c == 'Specific Date/Time' && Campaigndata.Scheduled_Date_Time__c != null){
                        req.setEndpoint('https://api.textlocal.in/send/?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(messages,'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberses,'UTF-8')+'&test='+EncodingUtil.urlEncode(test1,'UTF-8')+'&scheduledFor='+EncodingUtil.urlEncode(dateTimeStr,'UTF-8')+'');
                    }else{
                        req.setEndpoint('https://api.textlocal.in/send/?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(messages,'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberses,'UTF-8')+'&test='+EncodingUtil.urlEncode(test1,'UTF-8')+'');
                    }
                    req.setMethod('POST');
                    req.setHeader('Content-Type','application/json');
                    Http http = new Http();
                    
                    HTTPResponse res = http.send(req);
                            string response = '';
                            System.debug(res.getBody());
                            if(res.getBody().containsIgnoreCase('warnings') || res.getBody().containsIgnoreCase('errors')){
                                if(res.getBody().containsIgnoreCase('Invalid number')){
                                    response = response+' Invalid number \n';
                                }
                                if(res.getBody().containsIgnoreCase('No recipients specified')){
                                    response = response+' No recipients specified \n';
                                }
                                if(res.getBody().containsIgnoreCase('Insufficient credits')){
                                        response = response+' Insufficient credits kinldy check with textLocal team \n';
                                }
                                if(res.getBody().containsIgnoreCase('Message too long')){
                                        response = response+' Message too long. \n';
                                }
                                if(res.getBody().containsIgnoreCase('Invalid number format')){
                                        response = response+' Invalid number format. \n';
                                }
                                if(res.getBody().containsIgnoreCase('Invalid sender name')){
                                        response = response+' Invalid sender name. \n';
                                }
                                if(res.getBody().containsIgnoreCase('No sender name specified')){
                                        response = response+' No sender name specified \n';
                                }
                                if(res.getBody().containsIgnoreCase('Invalid Template')){
                                    response = response+' Invalid Template. The message given didnt match any approved templates on your account. \n';
                                }
                                if(res.getBody().containsIgnoreCase('Schedule time is outside that allowed')){
                                    response = response+' Schedule time is outside that allowed. \n';
                                }
                                if(res.getBody().containsIgnoreCase('You cannot send message at this time')){
                                    response = response+' You cannot send message at this time. \n';
                                }
                                return response;
                            }
                }
            }else{
                Return 'Exception Occured. kindly Contact Admin';
            }
            
            for(string key : mapsr.keySet()){
                mapsr1.remove(key);
            }
            string sw ='';
            for(String key:mapsr1.keySet()){
                if(mapsr1.get(key)!=''){
                    sw = sw+mapsr1.get(key);
                }
            }
            if (mapsr1.size()>0){
                string s = 'This Campaign Members has an Invalid Phone numbers. Message delivery could not complete for '+sw;
                Return s;
            }
        }
        return 'Message Successfully Sent..';
        
    }
    
}