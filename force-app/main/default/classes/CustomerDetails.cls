public without sharing class CustomerDetails{
    @AuraEnabled
    public static CustomerDetailWrapper CustomerRecord(String PhoneNumber){
         //String PhoneNumber  Where Subject LIKE '%Call'
        //string PhoneNumber = '9000000039';
        System.debug('PhoneNumber ===> ' + PhoneNumber);
        CustomerDetailWrapper customWrap = new CustomerDetailWrapper();
        try{
            List<Account> CustomerAccoundetails = [SELECT Website,Franchisee__r.Name,Gender__pc,Occupation__pc, Religion__pc, Handling_Agent__r.First_Name__c,Wedding_Anniversary__pc, Handling_Agent__r.Last_Name__c, Alternate_Name__c, Feedback__c,Follow_Up_date__c,Interested_Product__c,Industry,Rating,Type,PersonMobilePhone, PersonEmail,AccountSource,AbbaSoft_User__c, Account_Key__c, Alternate_Phone__c,PersonTitle, BillingStreet, Customer_ID__c, Delivery_Option__c, District__c, Email__c, Date_of_Birth__pc, FirstName, Followup_Required__c, Franchisee_SAP_Code__c, Franchisee__c, Id, LastName, MiddleName, Name, Next_Purchase_Date__c, Phone, owner.name,RecordTypeId, Reward_Point__c, Source_Mobile_Number__c, Status__c, TFC_Id__c, Warehouse__c, Wondersoft_ID__c, CreatedDate,ShippingAddress, ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,
                                                        (SELECT AbasoftId__c, Agent_Call_Status__c, callRecordingURL__c, Call_Duration_In_Seconds__c, Call_End_Time__c, Call_StartedOn__c, Call_Start_Time__c, Description , Source_Mobile_Number__c, AabaSoft_User__r.Agent_Unique_Id__c, AabaSoft_User__r.First_Name__c, Status, Subject, TaskSubtype, Type, WhatCount, WhatId, WhoCount, WhoId, Owner.Name, Priority, CreatedDate  FROM Tasks ORDER  BY CreatedDate DESC), 
                                                        (SELECT AbbaSoft_User__c, AccountId, Contact_Franchisee__c, Email, FirstName, Gender__c, Id, IsPersonAccount, LastName, MiddleName, MobilePhone, Name, Occupation__c, PhotoUrl, Religion__c, CreatedDate  FROM Contacts Order by createdDate Desc), 
                                                        (SELECT Id, AccountId, Account_Phone__c, Amount, Budget_Amount__c, Description, District__c, Enquiry_Type__c, Franchisee__c, Loss_Reason__c, Name, Next_Followup_Date_Time__c, OwnerId, Payment_Mode__c, Product_Category__c, Rating_Post_Purchase__c, Rating_Pre_Purchase__c, SourceMobileNumber__c, StageName, Type, Warehouse__c, AabaSoft_User__c, CreatedDate  FROM Opportunities Order by createdDate Desc), 
                                                        (SELECT AabaSoft_User__c,Call_Duration_In_Seconds__c,Call_End_Time__c,Call_Recording_URL__c,Call_StartedOn__c,Call_Status__c,CampaignId__c,Contact_Number__c,Id,Lead_Name__c,Related_To__c,Subject__c,Task__c, CreatedDate  FROM Subtask__r Order by createdDate Desc),
                                                        (SELECT OrderNumber,EffectiveDate,AccountId,Account.Name, Billing_City__c, Billing_Country__c, Happy_Call_Remark__c, Billing_Postal_Code__c, Billing_State__c, Billing_Street__c, Delivery_Option__c, Description, EndDate, Franchisee_Name__c, Franchisee__c, Grand_Total_Discount__c, Happy_Call__c, Interested_New_product__c, Order_Bill_Discounts__c, Order_Created_By_Name__c, Order_Offer_Discounts__c, Order_Scheme_Discounts__c, Order_Source__c, Orde_Total_Discounts__c, Rapidor_Order_Number__c, Region__c, Service_Charge__c, Shipping_City__c, Shipping_Country__c, Shipping_Postal_Code__c, Shipping_State__c, Shipping_Street__c, Total_Amount__c, Total_Paid__c, Total_Taxes__c, Warehouse__c,CreatedDate,Type, EMI_Amount__c,EMI_Date__c  FROM Orders Order by createdDate Desc)
                                                   FROM Account 
                                                   Where Phone = :PhoneNumber];

            if (!CustomerAccoundetails.isEmpty()) {
                System.debug('account subtask ===> ' + CustomerAccoundetails[0].Subtask__r);
            }
                                                   
            if ( !CustomerAccoundetails.isEmpty() ){
                customWrap.CustomerAccDetail = CustomerAccoundetails[0];

            }
            else{
                customWrap.CustomerAccDetail = null;
            }

            //System.debug(' CustomerAccoundetails =====> ' + CustomerAccoundetails);
            //System.debug(' CustomerAccoundetails =====> ' + CustomerAccoundetails[0].Tasks);
            //System.debug(' CustomerAccoundetails =====> ' + CustomerAccoundetails[0].Orders);
            if ( !CustomerAccoundetails.isEmpty() ){
                List<AccountHistory> AccountHistory = [SELECT AccountId, CreatedDate, DataType, Field, Id, NewValue, OldValue
                                                       FROM AccountHistory
                                                       Where AccountId = :CustomerAccoundetails[0].Id];
                List<Opportunity> newlastestOpportunity = [SELECT AccountId, Account_Phone__c, Amount, Budget_Amount__c, Description, District__c, Enquiry_Type__c, Franchisee__c, Loss_Reason__c, Name, Next_Followup_Date_Time__c, OwnerId, Payment_Mode__c, Product_Category__c, Rating_Post_Purchase__c, Rating_Pre_Purchase__c, SourceMobileNumber__c, StageName, Type, Warehouse__c, AabaSoft_User__c 
                                                            FROM Opportunity
                                                            where AccountId =: CustomerAccoundetails[0].Id and StageName != 'Closed Lost' And StageName != 'Closed Won' Order by createdDate Desc LIMIT 1];
                System.debug('newlastestOpportunity ==> '+ newlastestOpportunity);
                if (!newlastestOpportunity.isEmpty()) {
                    customWrap.LatestOpportunity = newlastestOpportunity[0];
                }
                else{
                    customWrap.LatestOpportunity = null;
                }
                if ( !AccountHistory.isEmpty() ){
                    customWrap.CustomerAccHistoryDetail = AccountHistory;
                }
                else{
                    customWrap.CustomerAccHistoryDetail = null;
                }

                System.debug('AccountHistory =====> ' + AccountHistory);
            }
            String phonestring = '0'+PhoneNumber.right(10);
            List<Lead> Leaddetails = [SELECT AbbaSoft_User__c, Handling_Agent__r.First_Name__c, Handling_Agent__r.Last_Name__c,Follow_Up_Date__c,LeadSource,Feedback_Comments__c,Owner_Name__c,Street, State, PostalCode, Country,Activity__c,Wedding_Anniversary_Date__c,Religion__c,Campaign_Name__c,Budget_Amount__c, City, Company, curPhone__c, Customer_Feedback__c, Date_of_Birth__c, Facebook_Campign_Name__c,Campaign_Product_Name__c,District__c, Email, Enquiry_Type__c, First_contact_date_time__c, Franchisee_Name_updated__c, Franchisee_Name__c, Gender__c, Id, Include__c, Interested_Product__c, IsLeadScored__c, IsManuallyCreated__c, is_Lead_Scored__c, LastName, FirstName, Status,
                                             Lead_Assigned_Date__c, Lead_Id__c, Lead_Key__c, Lead_Number__c, Lead_Score__c, Loss_Reason__c, Maximum_Score__c, MiddleName, MobilePhone, Name, Occupation__c, Owner__c, Payment_Mode__c, Phone, Phone_formatted__c, Product_Category__c, SMS_Campaign__c, SourceMobileNumber__c, Updated_Phone__c,Website,Title,Industry,
                                        (SELECT CallDurationInSeconds,Call_Status__c,CreatedDate,Id,Priority,Description,Status,Subject,TaskSubtype,WhatId,WhoId, Who.Name, What.Name FROM Tasks),
                                        (SELECT AabaSoft_User__c,Call_Duration_In_Seconds__c,Call_End_Time__c,Call_Recording_URL__c,Call_StartedOn__c,Call_Status__c,CampaignId__c,Contact_Number__c,Id,Lead_Name__c,Related_To__c,Subject__c,Task__c FROM Subtask__r Order by createdDate Desc)
                                      FROM Lead
                                      Where Phone =: phonestring AND IsConverted = false];
            List<Product_Intrest__c> productIntrestList ;
            if ( !Leaddetails.isEmpty() ){
                customWrap.CustomerLeadDetail = Leaddetails[0];

                productIntrestList = [select name,id,MOP1__c,MOP2__c,MRP__c,Product__c,Quantity__c,Total__c,Product_Name__c from Product_Intrest__c where Lead__c =:Leaddetails[0].Id];
                customWrap.productIntrestDetails = productIntrestList;
            }
            else{
                customWrap.CustomerLeadDetail = null;
            }
            System.debug('Leaddetails ======> ' + Leaddetails);
            if ( !Leaddetails.isEmpty() ){
                List<LeadHistory> LeadHistoryrec = [SELECT CreatedDate, DataType, Field, Id, LeadId, NewValue, OldValue
                                                    FROM LeadHistory
                                                    where LeadId = :Leaddetails[0].id];
                System.debug('LeadHistoryrec =====> ' + LeadHistoryrec);
                if ( !LeadHistoryrec.isEmpty() ){
                    customWrap.CustomerLeadHistoryDetail = LeadHistoryrec;
                }
                else{
                    customWrap.CustomerLeadHistoryDetail = null;
                }
                //customWrap.CustomerLeadHistoryDetail
            }

        }
        catch ( Exception e ){
            System.debug('the error has occured due to =====> ' + e.getStackTraceString());
        }

        return customWrap;
    }
    @AuraEnabled
    public static map<String,Map<String,String>> GetPicklistvalue (){
        
        map<String,Map<String,String>> FinalMap = new map<String,Map<String,String>>();
        
        Map<String,String> lossReasonOptions = new Map<String, String>();

        Map<String,String> HappycallFeedbackMap = new Map<String, String>();
        Map<String,String> interestedProductMap = new Map<String, String>();
        Map<String,String> hpyClOptions = new Map<String, String>();
        Map<String,String> FemiCallStatusOptions = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResultforHappyCallFeed = Order.Happy_call_Feedback_c__c.getDescribe();
        Schema.DescribeFieldResult fieldResultforINtProduct = Order.Interested_New_product__c.getDescribe();
        Schema.DescribeFieldResult fieldResultforHpyCl = Order.Happy_Call__c.getDescribe();
        Schema.DescribeFieldResult fieldResultforLossReason = Opportunity.Loss_Reason__c.getDescribe();
        Schema.DescribeFieldResult fieldResultforfemicallStatus = Order.FEMI_Call_status__c.getDescribe();

        
        List<Schema.PicklistEntry> FemiClValues = fieldResultforfemicallStatus.getPicklistValues();
        List<Schema.PicklistEntry> hpyClValues = fieldResultforHpyCl.getPicklistValues();
        List<Schema.PicklistEntry> IntprodValues = fieldResultforINtProduct.getPicklistValues();
        List<Schema.PicklistEntry> HappyCallfeedValues = fieldResultforHappyCallFeed.getPicklistValues();

        List<Schema.PicklistEntry> reasonValues = fieldResultforLossReason.getPicklistValues();

        
        for (Schema.PicklistEntry p: hpyClValues) {
            hpyClOptions.put(p.getValue(), p.getLabel());
        }
        for (Schema.PicklistEntry p: HappyCallfeedValues) {
            HappycallFeedbackMap.put(p.getValue(), p.getLabel());
        }
        for (Schema.PicklistEntry p: IntprodValues) {
            interestedProductMap.put(p.getValue(), p.getLabel());
        }
        for (Schema.PicklistEntry p: reasonValues) {
            lossReasonOptions.put(p.getValue(), p.getLabel());
        }
        for (Schema.PicklistEntry p: FemiClValues) {
            FemiCallStatusOptions.put(p.getValue(), p.getLabel());
        }
        FinalMap.put('HpyCl',hpyClOptions);
        FinalMap.put('HpyClFeed',HappycallFeedbackMap);
        FinalMap.put('Interestedproduct',interestedProductMap);
        FinalMap.put('reason',lossReasonOptions);
        FinalMap.put('FEMI Call Status',FemiCallStatusOptions);
        
        return FinalMap;        
    }
    
    @AuraEnabled
    public static account updateAccRecord(Account accRecord){
        system.debug('accRecord'+accRecord);
        account accrec = new  account();
        
        Account acc = new Account();
        acc.Id = accRecord.Id;
        acc.Alternate_Phone__c = accRecord.Alternate_Phone__c;
        acc.Alternate_Name__c = accRecord.Alternate_Name__c;
        acc.PersonEmail = accRecord.PersonEmail;
        acc.Gender__pc = accRecord.Gender__pc;
        acc.Occupation__pc = accRecord.Occupation__pc;
        acc.Religion__pc = accRecord.Religion__pc;
        acc.Date_of_Birth__pc = accRecord.Date_of_Birth__pc;
        acc.Wedding_Anniversary__pc	 = accRecord.Wedding_Anniversary__pc;
        acc.Franchisee_Name_Agent_Input__c = accRecord.Franchisee_Name_Agent_Input__c	;
        update acc;
        if (acc.id !=null) {
            accrec = [SELECT Website,Franchisee__r.Name,Gender__pc,Occupation__pc, Religion__pc, AbbaSoft_User__r.First_Name__c,Wedding_Anniversary__pc, AbbaSoft_User__r.Last_Name__c, Alternate_Name__c, Feedback__c,Follow_Up_date__c,Interested_Product__c,Industry,Rating,Type,PersonMobilePhone, PersonEmail,AccountSource,AbbaSoft_User__c, Account_Key__c, Alternate_Phone__c,PersonTitle, BillingStreet, Customer_ID__c, Delivery_Option__c, District__c, Email__c, Date_of_Birth__pc, FirstName, Followup_Required__c, Franchisee_SAP_Code__c, Franchisee__c, Id, LastName, MiddleName, Name, Next_Purchase_Date__c, Phone, owner.name,RecordTypeId, Reward_Point__c, Source_Mobile_Number__c, Status__c, TFC_Id__c, Warehouse__c, Wondersoft_ID__c, CreatedDate,ShippingAddress, ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet
                          From account where Id=:acc.id];
            
        }
        
        return accrec;
    }
    @AuraEnabled
    public static Lead UpdateLeadDetails(Lead Ldrec){
        try {
            update LdRec;
            return LdRec;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            //return e.getMessage();
        }
        //return 'SUCCESS';
    }
    
    @AuraEnabled
    public static GlobalSearchWrapper GlobalSearch(String searchKey, string objectName, string agentId){                //List<List<sObject>>
        System.debug('ObjectName ====> ' + objectName);         
        System.debug('searchKey ====> ' + searchKey);
        System.debug('agentId ====> ' + agentId);
        GlobalSearchWrapper GS_warp = new GlobalSearchWrapper();
            if ( searchKey.length() > 1 ){

            }
            //List<List<sObject>> searchResult = new List<List<sObject>>();
            //List<List<sObject>> searchList = new List<List<sObject>>();
            //String searchQuery = '';
            try{
                /*if (objectName == 'Account' && objectName != null) {
                    String searchStr = '*' + searchKey + '*';
                    searchQuery = 'FIND \'' + searchStr + '\' IN ALL FIELDS RETURNING  Account (Id, Name, AccountNumber, Phone, createdDate)';
                }
                else if (objectName == 'Lead' && objectName != null) {
                    String searchStr = '*' + searchKey + '*';
                    searchQuery = 'FIND \'' + searchStr + '\' IN ALL FIELDS RETURNING  Lead(Id, Name, Email, Company)';
                    
                }
                else if (objectName == 'Contact' && objectName != null) {
                    String searchStr = '*' + searchKey + '*';
                    searchQuery = 'FIND \'' + searchStr + '\' IN ALL FIELDS RETURNING  Contact(Id, Name, Email, MobilePhone)';
                    
                }
                else if (objectName == 'Opportunity' && objectName != null) {
                    String searchStr = '*' + searchKey + '*';
                    searchQuery = 'FIND \'' + searchStr + '\' IN ALL FIELDS RETURNING  Opportunity(Id, Name, StageName, CloseDate)';
                    
                }
                else{
                    String searchStr = '*' + searchKey + '*';
                    searchQuery = 'FIND \'' + searchStr + '\' IN ALL FIELDS RETURNING  Account (Id, Name, AccountNumber, Website), Contact(Id, Name, Email, MobilePhone), Opportunity(Id, Name, StageName, CloseDate),Lead(Id, Name, Email, Company)';

                }
                System.debug('searchQuery =====> ' + searchQuery);
                searchList = search.query(searchQuery);
                System.debug('searchList =====> ' + searchList);*/

            // searchResult = [FIND :searchKey IN ALL FIELDS RETURNING
            //                                 Account (Id, Name, AccountNumber, Website),
            //                                 Contact(Id, Name, Email, MobilePhone),
            //                                 Opportunity(Id, Name, StageName, CloseDate),
            //                                 Lead(Id, Name, Email, Company)];
        
            //String agentId = '';
            String searchStr = '%' + searchKey + '%';
            if (objectName == 'Account' && objectName != null) {
                //String searchStr = '%' + searchKey + '%' ;
                List<Account> AccountList = [SELECT AbbaSoft_User__c,AbbaSoft_User__pc,Agent_UniqueId__c,CreatedDate,Email__c,Handling_Agent__c,Interested_Product__c,Name,Phone 
                                            FROM Account 
                                            where (Name =:searchKey OR Name LIKE:searchStr OR Phone =: searchKey OR Phone Like:searchStr)  LIMIT 100]; //AND Agent_UniqueId__c =: agentId
                GS_warp.AccountRecords = AccountList;
                GS_warp.leadRecords =null;
            }
            else if (objectName == 'Lead' && objectName != null) {
                
                list<Lead> LeadList = [SELECT AbbaSoft_User__c,Agent_UniqueId__c,Company,CreatedDate,Email,Name,Phone,Website 
                                        FROM Lead
                                        Where (Name =:searchKey OR Name LIKE:searchStr OR Phone =: searchKey OR Phone Like:searchStr)  LIMIT 100];
                //searchQuery = 'FIND \'' + searchStr + '\' IN ALL FIELDS RETURNING  Lead(Id, Name, Email, Company)';
                GS_warp.AccountRecords = null;
                GS_warp.leadRecords =LeadList;
                
            }
            else {
                List<Account> AccountList = [SELECT AbbaSoft_User__c,AbbaSoft_User__pc,Agent_UniqueId__c,CreatedDate,Email__c,Handling_Agent__c,Interested_Product__c,Name,Phone 
                                            FROM Account 
                                            where (Name =:searchKey OR Name LIKE:searchStr OR Phone =: searchKey OR Phone Like:searchStr) LIMIT 100];
                
                list<Lead> LeadList = [SELECT AbbaSoft_User__c,Agent_UniqueId__c,Company,CreatedDate,Email,Name,Phone,Website
                                            FROM Lead
                                            Where (Name =:searchKey OR Name LIKE:searchStr OR Phone =: searchKey OR Phone Like:searchStr) LIMIT 100];
                GS_warp.AccountRecords = AccountList;
                GS_warp.leadRecords =LeadList;
                
            }
        }
        catch ( Exception e ){
            //throw new AuraHandledException(e.getMessage());
            System.debug('The Error has occured ========> ' + e.getStackTraceString());
        }
        return GS_warp;
    }

    @AuraEnabled
    public static task MarktaskCompleted(task activitytask){
        try {
            System.debug('task =======> ' + activitytask);
            activitytask.Status = 'Completed';
            update activitytask;
            return activitytask;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
       
    }

    @AuraEnabled
    public static List<taskWrapper> QueryListOfPhoneNumberWithScheduleTime(String HashCode){
        list<Task> TaskForLoggEdinUser  = new list<Task>();
        set<Id> LeadIds = new Set<Id>();
        set<Id> AccountIds = new Set<Id>();

        list<Lead> Leadlist = new List<Lead>();
        list<Account> Accountlist = new List<Account>();
        Map<String, String> IdWithPhone = New Map<String,string>();

        List<taskWrapper> taskWrapperList = new List<taskWrapper>();
        try {
            date todaydate = system.today();
            date TomorrowDate = Date.today().addDays(1);
            TaskForLoggEdinUser = [SELECT AabaSoft_User__c, Agent_Call_Status__c, AbasoftId__c, Agent_UniqueId__c, CampaignID__c, Contact_Number__c, DataUniqueId__c, WhoCount, WhoId, WhatId, who.Phone, What.Phone, who.Name, What.Name, CreatedDate
                                                FROM Task
                                                Where AabaSoft_User__r.HashCode__c =: HashCode and  ActivityDate >=: todaydate and ActivityDate<=: TomorrowDate];

            
            if (!TaskForLoggEdinUser.isEmpty()) {
                for (task tas : TaskForLoggEdinUser) {
                    if (tas.whoId !=null) {
                        String WhoObjectName = String.valueOf((tas.whoId).getsobjecttype());
                        if (WhoObjectName == 'Lead') {
                            LeadIds.add(tas.whoId);
                        }
                    }
                    if (tas.WhatId != null) {
                        String WhatObjectName = String.valueOf((tas.WhatId).getsobjecttype());
                        if(WhatObjectName == 'Account') {
                            AccountIds.add(tas.whatid);
                        }

                    }  
                }
            }
            if (!LeadIds.isEmpty()) {
                Leadlist =[Select Id, Name,Phone From Lead Where Id IN: LeadIds];
                if (!LeadList.isEmpty()) {
                    for (Lead ld : leadlist) {
                        IdWithPhone.put(ld.Id, ld.Phone);
                    }
                }
            }
            if (!AccountIds.isEmpty()) {
                Accountlist =[Select Id, Name,Phone From Account Where Id IN: AccountIds];
                if (!Accountlist.isEmpty()) {
                    for (Account acc : Accountlist) {
                        IdWithPhone.put(acc.Id, acc.Phone);
                    }
                }
            }
            for (Task taskrec : TaskForLoggEdinUser) {
                taskWrapper taskwrap = new taskWrapper();
                taskwrap.CustomerName = taskrec.who.name;
                taskwrap.taskId = taskrec.id;
                if (taskrec.whoId != null && String.valueOf((taskrec.whoId).getsobjecttype()) == 'Lead' && taskrec.whatId == null) {
                    taskwrap.CustomerPhone = IdWithPhone.get(taskrec.WhoId);
                }
                else if (taskrec.whatId != null && String.valueOf((taskrec.WhatId).getsobjecttype()) == 'Account') {
                    taskwrap.CustomerPhone = IdWithPhone.get(taskrec.WhatId);
                }
                taskwrap.taskScheduledateTime = taskrec.CreatedDate.addHours(2);
                taskWrapperList.add(taskWrap);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return taskWrapperList;
    } 

    @AuraEnabled
    public static String UpdateFeedback(String Feedback, date Followupdate, string InterestedProduct, ID recordId, string LossReasonForAPex){
        System.debug('Feedback ====> ' + Feedback);
        System.debug('Followupdate ====> ' + Followupdate);
        System.debug('InterestedProduct ====> ' + InterestedProduct);
        System.debug('recordId ====> ' + recordId);

        String sObjName = recordId.getSObjectType().getDescribe().getName();
        if (sObjName == 'Account') {
            Account UpdatedAcc = new Account();
            UpdatedAcc.id = recordId;
            UpdatedAcc.Feedback__c = Feedback;
            UpdatedAcc.Follow_Up_date__c = Followupdate;
            UpdatedAcc.Interested_Product__c = InterestedProduct;
            update UpdatedAcc;

            List<Opportunity> newlastestOpportunity = [SELECT AccountId, Account_Phone__c, Amount, Budget_Amount__c, Description, District__c, Enquiry_Type__c, Franchisee__c, Loss_Reason__c, Name, Next_Followup_Date_Time__c, OwnerId, Payment_Mode__c, Product_Category__c, Rating_Post_Purchase__c, Rating_Pre_Purchase__c, SourceMobileNumber__c, StageName, Type, Warehouse__c, AabaSoft_User__c 
                                                            FROM Opportunity
                                                            where AccountId =: recordId and StageName != 'Closed Lost' And StageName != 'Closed Won' Order by createdDate Desc LIMIT 1];
                System.debug('newlastestOpportunity ==> '+ newlastestOpportunity);
                if (!newlastestOpportunity.isEmpty()) {
                    opportunity opptobeupdated = new Opportunity();
                    opptobeupdated.Loss_Reason__c = LossReasonForAPex;
                    opptobeupdated.id = newlastestOpportunity[0].id;
                    //update opptobeupdated;
                }
        }
        else if (sObjName == 'Lead') {
            lead ld = new Lead();
            ld.Id = recordId;
            ld.Follow_Up_Date__c = Followupdate;
            ld.Feedback_Comments__c = Feedback;
            ld.Interested_Product__c = InterestedProduct;
            update ld;
        }
        return 'SUCCESS';

    }

    @AuraEnabled
    public static List <String> getPiklistValues() {
        List<String> plValues = new List<String>();
         
        //Get the object type from object name. Here I've used custom object Book.
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('order');
         
        //Describe the sObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
         
        //Get the specific field information from field name. Here I've used custom field Genre__c of Book object.
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Happy_Call__c').getDescribe();
         
        //Get the picklist field values.
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
         
        //Add the picklist values to list.
        for(Schema.PicklistEntry plv: picklistvalues) {
            plValues.add(plv.getValue());
        }
        plValues.sort();
        return plValues;
    }

    @AuraEnabled
    public static String markOppCloseLost(String OpportunityRecid, string LossReason){

        System.debug('OpportunityRecid ===> ' + OpportunityRecid);
        List<Opportunity> OpportunitiesList = [Select Id, name, Account_Phone__c, StageName, AccountId 
                                                From Opportunity 
                                                where Id =:OpportunityRecid AND StageName != 'Closed Won' AND StageName != 'Closed Lost'
                                                ORDER BY CreatedDate DESC
                                                LIMIT 1];

        System.debug('OpportunitiesList ===> ' + OpportunitiesList);
        if (OpportunitiesList.size()>0 || !OpportunitiesList.isEmpty()) {
            OpportunitiesList[0].StageName = 'Closed Lost'; //
            OpportunitiesList[0].Loss_Reason__c = LossReason;
            update OpportunitiesList[0];
        }
        return 'Success';
    }


    @AuraEnabled
     public static string updateAccountOrder (String orderRecId, String HappycallValue, string interestedProd, List<String> HappycallFeedValues,String HappyCallRemark){
        System.debug('orderRecId=====> ' + orderRecId);
        System.debug('HappycallValue=====> ' + HappycallValue);
        System.debug('interestedProd=====> ' + interestedProd);
        System.debug('HappycallFeedValues=====> ' + HappycallFeedValues);
        String happcallFeedString = '';
        if (!HappycallFeedValues.isEmpty()) {
            happcallFeedString =   String.join(HappycallFeedValues, ';');
        }
         try{

            List<order> Orderlist = [SELECT AccountId,ActivatedById,ActivatedDate,BillingAddress,BillingCity,BillingCountry,BillingCountryCode,BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStateCode,BillingStreet,Billing_City__c,Billing_Country__c,Billing_Postal_Code__c,Billing_State__c,Billing_Street__c,CompanyAuthorizedById,ContractId,CreatedById,CreatedDate,CustomerAuthorizedById,Delivery_Option__c,Description,EffectiveDate,EndDate,Franchisee_Name__c,Franchisee__c,Grand_Total_Discount__c,Happy_Call__c,Id,Interested_New_product__c,IsDeleted,IsReductionOrder,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,OrderNumber,Order_Bill_Discounts__c,Order_Created_By_Name__c,Order_Offer_Discounts__c,Order_Scheme_Discounts__c,Order_Source__c,Orde_Total_Discounts__c,OriginalOrderId,OwnerId,Pricebook2Id,Rapidor_Order_Number__c,Region__c,Service_Charge__c,ShippingAddress,ShippingCity,ShippingCountry,ShippingCountryCode,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStateCode,ShippingStreet,Shipping_City__c,Shipping_Country__c,Shipping_Postal_Code__c,Shipping_State__c,Shipping_Street__c,Status,StatusCode,SystemModstamp,TotalAmount,Total_Amount__c,Total_Paid__c,Total_Taxes__c,Type,Warehouse__c 
                                    FROM Order
                                    Where Id=:orderRecId Order BY Createddate Desc LIMIT 1];

            System.debug('Orderlist ===> ' + Orderlist);
                                    if (!Orderlist.isEmpty()) {
                                        order ordTobeUpdated = new Order ();
                                        ordTobeUpdated.Id = orderRecId;
                                        ordTobeUpdated.Happy_Call__c = HappycallValue;
                                        ordTobeUpdated.Interested_New_product__c = interestedProd;
                                        ordTobeUpdated.Happy_call_Feedback_c__c = happcallFeedString;
                                        ordTobeUpdated.Happy_Call_Remark__c = HappyCallRemark;
                                        ordTobeUpdated.AccountId = Orderlist[0].AccountId;
                                        update ordTobeUpdated;
                                    }
             return 'SUCCESS';
         }
         catch(Exception e){
             throw new AuraHandledException(e.getMessage());
         }
     }


    @AuraEnabled
    public static List<OpportunityLineItem> oppLineitemForParticularOPP(String opportunityId){
        System.debug('opportunityId ===> ' + opportunityId);
        try {

            List<OpportunityLineItem> OppLineItemList = [SELECT CreatedDate,DBD__c,Description,EMI__c,Incentive__c,ListPrice,MRP__c,Name,OpportunityId,Product2Id,ProductCode,Quantity,TotalPrice,UnitPrice 
                                                            FROM OpportunityLineItem 
                                                            Where OpportunityId =: opportunityId];   
            System.debug('OppLineItemList ======> ' + OppLineItemList);
            return OppLineItemList;         
        } catch (Exception e) {
            System.debug('the error has occured due to ====>' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<OrderItem> orderProductParticularOrd(string orderId){
        System.debug('orderId ======> ' + orderId); 
        try {
            List<OrderItem> orderProductsList = [SELECT Description,EndDate,ListPrice,Quantity,TotalPrice,UnitPrice, OrderId,OrderItemNumber,OriginalOrderItemId, product2.Name, product2.ProductCode
                                                FROM OrderItem
                                                where OrderId=: orderId];
            System.debug('orderProductsList ====> ' + orderProductsList);
            return orderProductsList;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<PricebookEntry> getPriceBookEntryRecords(String prodId){
        
        List<PricebookEntry> PbList = [Select Id , MRP__c, Name ,Price__c, IsActive , Price_Book_Name__c,UnitPrice from PricebookEntry where Product2Id =:prodId];
        
        return PbList;
    }
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String value){
        try {
            system.debug('objectName-->'+objectName);
            system.debug('filterField-->'+filterField);
            system.debug('searchString-->'+searchString);
            system.debug('value-->'+value);
            string serchstringupdated = '%' + searchString + '%';
            searchString = searchString.replace(' ', '%');
            List<RecordsData> recordsDataList = new List<RecordsData>();
            String query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
            if(String.isNotBlank(value)) {
                query += ' WHERE Id = \''+ value + '\' LIMIT 100';
            } else {
                // query += ' WHERE '+filterField+
                //     ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 49999';
                query += ' WHERE '+filterField+
                     ' LIKE :serchstringupdated OR ' + filterField  + '=: searchString' + ' LIMIT 100';
            }
            system.debug('query-->'+query);
            for(SObject s : Database.query(query)) {
                System.debug('s====> ' +s);
                // RecordsData RD = new RecordsData();
                // RD.label = [select id, name from user where id =: (String)s.get('AO__c')].name;
                // RD.value = (String)s.get('id');
                // recordsDataList.add(RD);
                recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
            }
            System.debug('I am ====> ' + recordsDataList);
            return recordsDataList;
        } catch (Exception err) {
            System.debug('the error has occured due to =====> ' + err.getMessage());
            System.debug('the error has occured at line  =====> ' + err.getLineNumber());
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    }

    @AuraEnabled
    public static Order QueryOrderRec(string orderId){
        try {
            order ord =[SELECT AccountId,EffectiveDate,EMI_Amount__c,EMI_Date__c,FEMI_Call_status__c,Id,Type FROM Order Where Id =: orderId];
            return ord;
            
        } catch (Exception e) {
            System.debug('the eror ====>  ' + e.getLineNumber());
            System.debug('the eror message ====>  ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string updateFemiCallDetailsonOrder(String OrderRecId, String FemiCallStatus, Integer Emiamount, date EMIDate){
        System.debug('OrderRecId ====. ' + OrderRecId);
        System.debug('FemiCallStatus ====. ' + FemiCallStatus);
        System.debug('Emiamount ====. ' + Emiamount);
        System.debug('Emiamount ====. ' + Emiamount);
        try {


            order ord = new order();
            ord.Id = OrderRecId;
            ord.FEMI_Call_status__c = FemiCallStatus;
            ord.EMI_Amount__c = Emiamount;
            ord.EMI_Date__c = EMIDate;
            update ord;
            return 'SUCCESS';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class taskWrapper{
        @AuraEnabled
        public String CustomerName;
        @AuraEnabled
        public String taskId;
        @AuraEnabled
        public String CustomerPhone;
        @AuraEnabled
        public dateTime taskScheduledateTime;
        

    }

    public class GlobalSearchWrapper{
        @AuraEnabled
        public List<Account> AccountRecords;
        @AuraEnabled
        public List<Lead> leadRecords;
    }

    public class CustomerDetailWrapper{
        @AuraEnabled
        public Account CustomerAccDetail;
        @AuraEnabled
        public Opportunity LatestOpportunity;
        @AuraEnabled
        public List<AccountHistory> CustomerAccHistoryDetail;
        @AuraEnabled
        public Lead CustomerLeadDetail;
        @AuraEnabled
        public List<LeadHistory> CustomerLeadHistoryDetail;
        @AuraEnabled
        public List<Product_Intrest__c> productIntrestDetails;

    }

    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

}