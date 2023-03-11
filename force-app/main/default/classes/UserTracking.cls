public class UserTracking {
    public UserTracking() {

    }

    @AuraEnabled
    public static UserTrack OnpageLoad(string userId){
        UserTrack usr = new UserTrack();
        list<User_Tracking__c> userTracking = [select id,Checkin_Datetime__c,Checkout_Datetime__c,Member__c from User_Tracking__c where Member__c =: userId and CreatedDate  = TODAY limit 1];
        if(!userTracking.isEmpty()){
          
            usr.checkin = true;
            if(userTracking[0].Checkout_Datetime__c != null)
                usr.checkout = true;
            else
                usr.checkout = false;
        }else{
            usr.checkin = false;
            usr.checkout = true;
        }
        
        return usr;
    }
    
    @AuraEnabled
    public static String UserCheckin(string userId){
        /*if(System.now().time() < Time.newInstance(08, 59, 00, 00)){
            
        }else{}*/
        
        
        String eventStatus = 'Something went wrong';
        string groupName = '';
        DateTime dt = DateTime.now();
        String dayOfWeek = dt.format('EEEE');
        /*if(dayOfWeek == 'Sunday'){
            eventStatus = 'You can not checkin on sunday.';
        	return eventStatus;
        }
        
        if(System.now().time() < Time.newInstance(08, 59, 00, 00)){
            eventStatus = 'You can not checkin before 9:00 AM.';
        	return eventStatus;
        }*/
            
        map<string,string> mapofGroupNameBySourceIntent = new map<string,string>();
        if(userId != null){
            list<User_Tracking__c> userTracking = new list<User_Tracking__c>();
            list<Assignment_Group_Member__c> agmList = new list<Assignment_Group_Member__c>();
            userTracking = [select id,Checkin_Datetime__c,Checkout_Datetime__c,Member__c from User_Tracking__c where Member__c =: userId and CreatedDate  = TODAY limit 1];
            system.debug('userTracking::'+userTracking);
            agmList = [select id,Group_Member__c,Assignment_Group__r.name from Assignment_Group_Member__c where Group_Member__c =: userId];
            system.debug('agmList::'+agmList);
            if(userTracking.isEmpty()){
                //list<Source_Intent_And_Group_Name__mdt> groupNameSourceIntent = [select id,Group_Name__c,Source_Intent__c from Source_Intent_And_Group_Name__mdt];

                /*if(!groupNameSourceIntent.isEmpty()){
                    for(Source_Intent_And_Group_Name__mdt signMeta : groupNameSourceIntent){
                        mapofGroupNameBySourceIntent.put(signMeta.Group_Name__c,signMeta.Source_Intent__c);
                    }
                }*/

                User_Tracking__c userTrackRec = new User_Tracking__c(); 
                userTrackRec.Member__c = userId;
                userTrackRec.Checkin_Datetime__c = DateTime.now();
                insert userTrackRec;
                system.debug('userTrackRec::'+userTrackRec.Id);
                string queueId = [SELECT Id, Type FROM Group WHERE Type = 'Queue' AND Name = 'Lead Default Queue' limit 1].Id;
                system.debug('queueId::'+queueId);
                list<Lead> queueLeadListTobePass = new list<Lead>();
                queueLeadListTobePass = [SELECT Address,Budget_Amount__c,Campaign_Comment__c,Campaign_Country_Code__c,City,Company,Country,CountryCode,CreatedById,CreatedDate,Created_Sec__c,
                                         Created_time__c,Date_of_Birth__c,District__c,Elapsed_Time_First_Contact__c,Email,Enquiry_Type__c,Feedback_Comments__c,FirstName,
                                         First_contact_date_time__c,Franchisee_Name__c,Gender__c,GeocodeAccuracy,HasOptedOutOfEmail,Id,Include__c,IndividualId,Industry,Interested_Product__c,
                                         IsConverted,IsDeleted,IsLeadScored__c,IsUnreadByOwner,is_Lead_Scored__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastName,LastReferencedDate,
                                         LastViewedDate,Latitude,LeadSource,Lead_Id__c,Lead_Key__c,Lead_Number__c,Loss_Reason__c,MasterRecordId,Maximum_Score__c,
                                         MiddleName,MobilePhone,Name,Next_Followup_Date_Time__c,No_of_Agents__c,NumberOfEmployees,Occupation__c,OwnerId,Owner__c,Payment_Mode__c,Phone,
                                         Phone_formatted__c,PhotoUrl,PostalCode,Product_Category__c,Rating,Religion__c,Salutation,SMS_Campaign__c,SMS_Missed_Call__c,SourceMobileNumber__c,
                                         State,StateCode,Status,Street,Suffix,SystemModstamp,Title,Updated_Phone__c,Website,Wedding_Anniversary_Date__c,IsManuallyCreated__c FROM Lead where ownerid  =: queueId];
                
                system.debug('queueLeadListTobePass::'+queueLeadListTobePass);
                
                
                
                if(!agmList.isEmpty()){
                    for(Assignment_Group_Member__c agm : agmList){
                        agm.Out_Of_Office__c = false;

                    }

                    update agmList;
                    
                    if(!queueLeadListTobePass.isEmpty()){
                   LeadAssignmentExecutionCriteria.validateEntryCriteria(queueLeadListTobePass); 
                }
                    /*for(Assignment_Group_Member__c agm : agmList){
                        RoundRobinLeadAssignment.assignLeadsToBDS(mapofGroupNameBySourceIntent.get(agm.Assignment_Group__r.name));
                    }*/
                    
                }
                
                eventStatus = 'Checkin successful';
            }else{
                eventStatus = 'Your checkin was already created.';
            }
            
        }else{
            eventStatus = 'User is not registered in system.Please contact to your admin.';
        }
        

        return eventStatus;
    }

    @AuraEnabled
    public static String UserCheckout(string userId){
        String eventStatus = 'Something went wrong';
        if(userId != null){
            list<User_Tracking__c> userTracking = new list<User_Tracking__c>();
            list<Assignment_Group_Member__c> agmList = new list<Assignment_Group_Member__c>();
            userTracking = [select id,Checkin_Datetime__c,Checkout_Datetime__c,Member__c from User_Tracking__c where Member__c =: userId and createddate = TODAY limit 1];
            agmList = [select id,Group_Member__c from Assignment_Group_Member__c where Group_Member__c =: userId];
            if(!userTracking.isEmpty()){
                for(User_Tracking__c ut : userTracking){
                    ut.Checkout_Datetime__c = DateTime.now();
                }
                update userTracking;
                if(!agmList.isEmpty()){
                    for(Assignment_Group_Member__c agm : agmList){
                        agm.Out_Of_Office__c = true;
                    }

                    update agmList;
                }
                eventStatus = 'Checkout datetime has been updated.';
            }else{
                eventStatus = 'You can not checkout without checkin.';
            }
            
        }else{
            eventStatus = 'User is not registered in system.Please contact to your admin.';
        }
        

        return eventStatus;
    }

    public class UserTrack{
        @AuraEnabled
        public boolean checkin;
        @AuraEnabled
        public boolean checkout;
    }
}