global class TextLocalBulkMessage_Campaign {
    @auraEnabled
    global static string sendBulkSMS(String recordId, string message){
        system.debug('recordId'+recordId);
        system.debug('message'+message);
        if(message != null || message != ''){
            if(message.contains('Invalid Numbers')){
                system.debug('containes');
                Return 'Invalid Numbers';
            }               
        } 
        
        if(recordId != null ||recordId != ''  && message == null || message == '' ){ 
            List<string> lst = new List<string> ();
            Campaign Campaigndata = new Campaign();
            Campaigndata =[select id, name, Scheduled_at__c, Scheduled_Date_Time__c from Campaign WHERE id=: recordId];
            List<CampaignMember> listofcam = [SELECT ContactId, phone, Contact.Name, Contact.Phone, LeadId FROM CampaignMember WHERE CampaignId=: recordId];
            for(CampaignMember c : listofcam){
                if(c.Phone != null){
                    lst.add(c.Phone);
                }
            }
            system.debug('lst'+lst);
            BatchonCampaignTextLocalImmediately shn = new BatchonCampaignTextLocalImmediately(recordId, lst); 
            
            if(Campaigndata.Scheduled_at__c != null || Campaigndata.Scheduled_at__c != ''){
                if(Campaigndata.Scheduled_at__c == 'Immediately'){
                    database.executeBatch(shn ,2); 
                }else
                    if( Campaigndata.Scheduled_at__c == 'Specific Date/Time' && Campaigndata.Scheduled_Date_Time__c != null){
                        database.executeBatch(shn,30); 
                    }else{
                        return 'please select scheduled Date/Time';
                    }
            }else{
                return 'please select scheduled at';
            }
        }
        return 'Message Successfully Sent..';
        
    }
    @auraEnabled
    public static string toastMessage(String message, List<string> InvalidNumbers){
        system.debug('message'+message);
        if(message != null || message != ''){
            Return 'Invalid Numbers Found. Messages cannot be sent to this Numbers'+message+'';
        }
        Return 'Message sent Successfully..';
    }
}