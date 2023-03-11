public without sharing class CallOut_TaskTransfer{
    //private static final String CustomerEndpoint = 'http://at228.ofabi.com/whitemartapi/api/customer_info';System.Label.MyLabelName
    private static final String CustomerEndpoint = System.Label.CustomerEndpoint;
    //private static final String GetCustomerAPIKey = 'd569c0d54acc05a16947d7b97c92693c30e81f2d832428c9e4576a95c3a11237791dd33e77b39995';
    private static final String GetCustomerAPIKey = System.Label.GetCustomerAPIKey;
    @future(callout = true)
    public static void Transfering_Tasks(Set<Id> TasksIds){

        JSON2Apex JSONWrapObject = new JSON2Apex();
        List<CustomerData> CustomerDataList = new List<CustomerData>();
        DataInfo datainfoWarp = new DataInfo();
        Set<id> accountids = new Set<id>();
        set<id> leadids = new set<id>();
        Map<string, string> accountIdwithPhone = new Map<string, string>();
        Map<string, string> LeadIdwithPhone = new Map<string, string>();
        Map<String, String> mapofCampNameWithTaskSubect = new map<String, string>();
        Map<String, string> mapofCampNameWithUniqueId = new map<String, string>();

        List<Task> taskList = [SELECT callRecordingURL__c, Call_Status__c, Id, OwnerId, Status, Subject, WhatId, whoId, Agent_UniqueId__c, AabaSoft_User__c, AabaSoft_User__r.CampaignID__c, Follow_Up_date__c
                               FROM Task
                               Where Id IN:TasksIds];


        for ( task tas : taskList ){
            if ( tas.whoId != null ){
                leadids.add(tas.WhoId);
            }
            if ( tas.WhatId != null ){
                accountids.add(tas.WhatId);
            }
        }
        if ( !leadids.isEmpty() ){
            List<lead> leadlist = [select id, phone
                                   from lead
                                   where Id IN:leadids and Phone != null];
            System.debug('leadlist =====> ' + leadlist);
            if ( !leadlist.isEmpty() ){
                for ( lead ld : leadlist ){
                    LeadIdwithPhone.put(ld.Id, ld.Phone);
                }
            }
            System.debug('LeadIdwithPhone =====> ' + LeadIdwithPhone);
        }
        if ( !accountids.isEmpty() ){
            list<account> accountlist = [select id, Phone
                                         from Account
                                         where Id IN:accountids and phone != null];
            System.debug('accountlist ====> ' + accountlist);
            if ( !accountlist.isEmpty() ){
                for ( account acc : accountlist ){
                    accountIdwithPhone.put(acc.id, acc.phone);
                }
            }
            System.debug('accountIdwithPhone ====> ' + accountIdwithPhone);
        }

        List<AbbaSoft_User__c> AabaSoftUser = [SELECT AabaSoft_UserName__c, Agent_Unique_Id__c, CampaignID__c, Contact_Number__c, CreatedOn__c, First_Name__c, HashCode__c, Id, Last_Name__c, Password__c, Username__c, Email_Id__c
                                               FROM AbbaSoft_User__c];

        List<Campaign__c> CampaignList = [SELECT Campaign_ID__c, Id, Name, Name__c
                                          FROM Campaign__c];
        
        if ( !CampaignList.isEmpty() ){
            for ( Campaign__c Campvar : CampaignList ){
                mapofCampNameWithUniqueId.put(Campvar.Name__c, Campvar.Campaign_ID__c);
            }

        }
        List<WhiteMart_Campaign__c> campaignCustomSetingData = [select id, Name, CampaignID__c, Task_Subject__c
                                                                from WhiteMart_Campaign__c];
        if ( !campaignCustomSetingData.isEmpty() ){
            for ( WhiteMart_Campaign__c campdata : campaignCustomSetingData ){
                mapofCampNameWithTaskSubect.put(campdata.Task_Subject__c, campdata.Name);
            }

        }

        System.debug('mapofCampNameWithUniqueId ====> ' + mapofCampNameWithUniqueId);
        integer i = 0;
        string phoneNumber = '';
        string phonenumberv1 = '';
        for ( task tsk : taskList ){
            CustomerData CustomWrap = new CustomerData();
            System.debug('tsk.whoId ====> ' + tsk.whoId);
            System.debug('tsk.whatId ====> ' + tsk.WhatId);
            if ( tsk.whoId != null ){
                String ObjectName = String.valueOf(( tsk.whoId ).getsobjecttype());
                if ( !LeadIdwithPhone.isEmpty() ){
                    if ( LeadIdwithPhone.containsKey(tsk.WhoId) ){
                        phoneNumber = string.valueOf(LeadIdwithPhone.get(tsk.WhoId)).right(10);
                    }
                }
                System.debug('Phonenumber ======> ' + phoneNumber);
                System.debug('phonenumberv1 ======> ' + phonenumberv1);
            }
            else if ( tsk.WhatId != null ){
                String ObjectName = String.valueOf(( tsk.WhatId ).getsobjecttype());
                if ( !accountIdwithPhone.isEmpty() ){
                    if ( accountIdwithPhone.containsKey(tsk.WhatId) ){
                        phoneNumber = String.valueOf(accountIdwithPhone.get(tsk.WhatId)).right(10);
                    }
                }
                System.debug('phoneNumber =======> ' + phoneNumber);
                System.debug('phonenumberv1 =======> ' + phonenumberv1);
            }

            if ( tsk.Subject == 'Welcome Call' || tsk.Subject == 'Service Call' || tsk.Subject == 'Happy Call' || tsk.Subject == 'FEMI Call' ){
                CustomWrap.mobileNumber = phoneNumber; //s1.right(3);
                CustomWrap.dataUniqueID = String.valueOf(tsk.Id);
                if ( tsk.Agent_UniqueId__c != null ){
                    CustomWrap.agentUniqueID = String.valueOf(tsk.Agent_UniqueId__c);
                }
                else{
                    CustomWrap.agentUniqueID = '';
                }
                //CustomWrap.agentUniqueID = TaskAssignmentToAabaSoftAgent.TaskAssignment(mapofCampNameWithUniqueId.get('CampaignOne'));
                if ( tsk.Follow_Up_date__c != null ){
                    CustomWrap.scheduleDateTime = String.valueOf(tsk.Follow_Up_date__c);
                }
                else{
                    CustomWrap.scheduleDateTime = String.valueOf(system.now().addminutes(1));
                }
                if ( tsk.AabaSoft_User__c != null ){
                    CustomWrap.campaignUniqueID = String.valueOf(tsk.AabaSoft_User__r.CampaignID__c);
                }
                else{
                    if ( mapofCampNameWithTaskSubect.containsKey(tsk.Subject) ){
                        string CampOrginalname = mapofCampNameWithTaskSubect.get(tsk.Subject);
                        if ( mapofCampNameWithUniqueId.containsKey(CampOrginalname) ){
                            CustomWrap.campaignUniqueID = mapofCampNameWithUniqueId.get(CampOrginalname);
                        }
                    }
                }
                if ( phoneNumber != null  && (CustomWrap.agentUniqueID != null && CustomWrap.agentUniqueID != '')){
                    CustomerDataList.add(CustomWrap);
                }

            }
            /*if ( tsk.Subject == 'Happy Call' ){
                CustomWrap.mobileNumber = phoneNumber;
                CustomWrap.dataUniqueID = String.valueOf(tsk.Id);
                if ( tsk.Agent_UniqueId__c != null ){
                    CustomWrap.agentUniqueID = String.valueOf(tsk.Agent_UniqueId__c);
                }
                else{
                    CustomWrap.agentUniqueID = '';
                }
                if ( tsk.Follow_Up_date__c != null ){
                    CustomWrap.scheduleDateTime = String.valueOf(tsk.Follow_Up_date__c);
                }
                else{
                    CustomWrap.scheduleDateTime = String.valueOf(system.now().addminutes(1));
                }
                //CustomWrap.campaignUniqueID = String.valueOf(tsk.AabaSoft_User__r.CampaignID__c);\
                if ( tsk.AabaSoft_User__c != null ){
                    CustomWrap.campaignUniqueID = String.valueOf(tsk.AabaSoft_User__r.CampaignID__c);
                }
                else{
                    if ( mapofCampNameWithTaskSubect.containsKey(tsk.Subject) ){
                        string CampOrginalname = mapofCampNameWithTaskSubect.get(tsk.Subject);
                        if ( mapofCampNameWithUniqueId.containsKey(CampOrginalname) ){
                            CustomWrap.campaignUniqueID = mapofCampNameWithUniqueId.get(CampOrginalname);
                        }
                    }
                }
                if ( phoneNumber != null ){
                    CustomerDataList.add(CustomWrap);
                }
            }
            if ( tsk.Subject == 'Service Call' ){
                CustomWrap.mobileNumber = phoneNumber;
                CustomWrap.dataUniqueID = String.valueOf(tsk.Id);
                if ( tsk.Agent_UniqueId__c != null ){
                    CustomWrap.agentUniqueID = String.valueOf(tsk.Agent_UniqueId__c);
                }
                else{
                    CustomWrap.agentUniqueID = '';
                }
                //CustomWrap.agentUniqueID = String.valueOf(AabaSoftUser[i].Agent_Unique_Id__c);
                if ( tsk.Follow_Up_date__c != null ){
                    CustomWrap.scheduleDateTime = String.valueOf(tsk.Follow_Up_date__c);
                }
                else{
                    CustomWrap.scheduleDateTime = String.valueOf(system.now().addminutes(1));
                }
                //CustomWrap.campaignUniqueID = String.valueOf(tsk.AabaSoft_User__r.CampaignID__c);
                if ( tsk.AabaSoft_User__c != null ){
                    CustomWrap.campaignUniqueID = String.valueOf(tsk.AabaSoft_User__r.CampaignID__c);
                }
                else{
                    if ( mapofCampNameWithTaskSubect.containsKey(tsk.Subject) ){
                        string CampOrginalname = mapofCampNameWithTaskSubect.get(tsk.Subject);
                        if ( mapofCampNameWithUniqueId.containsKey(CampOrginalname) ){
                            CustomWrap.campaignUniqueID = mapofCampNameWithUniqueId.get(CampOrginalname);
                        }
                    }
                }
                // if (!mapofCampNameWithUniqueId.isEmpty()) {
                //     CustomWrap.campaignUniqueID = mapofCampNameWithUniqueId.get('Campaignthree');
                // }
                if ( phoneNumber != null ){
                    CustomerDataList.add(CustomWrap);
                }
            }
            if ( tsk.Subject == 'FEMI Call' ){
                CustomWrap.mobileNumber = phoneNumber;
                CustomWrap.dataUniqueID = String.valueOf(tsk.Id);
                if ( tsk.Agent_UniqueId__c != null ){
                    CustomWrap.agentUniqueID = String.valueOf(tsk.Agent_UniqueId__c);
                }
                else{
                    CustomWrap.agentUniqueID = '';
                }
                //CustomWrap.agentUniqueID = String.valueOf(AabaSoftUser[i].Agent_Unique_Id__c);
                if ( tsk.Follow_Up_date__c != null ){
                    CustomWrap.scheduleDateTime = String.valueOf(tsk.Follow_Up_date__c);
                }
                else{
                    CustomWrap.scheduleDateTime = String.valueOf(system.now().addminutes(1));
                }
                //CustomWrap.scheduleDateTime = String.valueOf(system.now().addminutes(1));
                //CustomWrap.campaignUniqueID = String.valueOf(tsk.AabaSoft_User__r.CampaignID__c);
                if ( tsk.AabaSoft_User__c != null ){
                    CustomWrap.campaignUniqueID = String.valueOf(tsk.AabaSoft_User__r.CampaignID__c);
                }
                else{
                    if ( mapofCampNameWithTaskSubect.containsKey(tsk.Subject) ){
                        string CampOrginalname = mapofCampNameWithTaskSubect.get(tsk.Subject);
                        if ( mapofCampNameWithUniqueId.containsKey(CampOrginalname) ){
                            CustomWrap.campaignUniqueID = mapofCampNameWithUniqueId.get(CampOrginalname);
                        }
                    }
                }
                if ( phoneNumber != null ){
                    CustomerDataList.add(CustomWrap);
                }
            }*/
        }
        JSONWrapObject.CustomerData = CustomerDataList;


        Map<String, String> responseMap = AabaSoftGenerateAccessToken.GenerateAccessToken();
        //Map<String, string> Bodymap = new Map<String, String>();
        //Bodymap.put('apiKey', responseMap.get('Key'));

        System.debug('API Key ======> ' + String.valueof(responseMap.get('Key')));
        if ( String.valueof(responseMap.get('Key')) != null ){
            datainfoWarp.numberOfRecords = String.valueOf(CustomerDataList.size());
            datainfoWarp.apiKey = String.valueof(GetCustomerAPIKey);
            //datainfoWarp.dataInfoKey = '9C662EC4-2323-4C15-AAFD-1EBFG6067SB';
            datainfoWarp.dataInfoTime = String.valueOf(system.now());
        }
        JSONWrapObject.DataInfo = datainfoWarp;
        string SerializedWrap = Json.serialize(JSONWrapObject);
        System.debug('SerializedWrap =====> ' + SerializedWrap);
        HttpRequest req = new HttpRequest(  );
        req.setEndpoint(CustomerEndpoint);
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Content-Length', String.valueOf(( 'application/json' ).length()));
        req.setHeader('Authorization', 'Bearer ' + responseMap.get('Access_token'));
        req.setBody(String.valueOf(SerializedWrap));
        Http http = new Http(  );
        if ( CustomerDataList.size() > 0 ){

            System.debug('Iam about to callout');
            HTTPResponse res = http.send(req);
            system.debug('res.getBody()::' + res.getBody());
            HttpUtility.httpReqHelper('CallOut_TaskTransfer', 'Transfering_Tasks', 'POST', req, res);
        }
    }

    //@future(callout = true)
    public static void transferFEMICallDetails(Set<id> taskIds){

        Set<id> accountids = new Set<id>();
        set<id> leadids = new set<id>();
        Map<string, string> accountIdwithPhone = new Map<string, string>();
        Map<string, string> LeadIdwithPhone = new Map<string, string>();

        JSON2Apex JSONWrapObject = new JSON2Apex();
        List<CustomerData> CustomerDataList = new List<CustomerData>();
        DataInfo datainfoWarp = new DataInfo();

        List<Task> taskList = [SELECT callRecordingURL__c, Call_Status__c, Id, OwnerId, Status, Subject, WhatId, whoId, Agent_UniqueId__c, AabaSoft_User__c, AabaSoft_User__r.CampaignID__c, Follow_Up_date__c, Product_Purchase_Date__c
                               FROM Task
                               Where Id IN:taskIds];

        for ( task tas : taskList ){
            if ( tas.whoId != null ){
                leadids.add(tas.WhoId);
            }
            if ( tas.WhatId != null ){
                accountids.add(tas.WhatId);
            }
        }
        if ( !leadids.isEmpty() ){
            List<lead> leadlist = [select id, phone
                                   from lead
                                   where Id IN:leadids and Phone != null];
            System.debug('leadlist =====> ' + leadlist);
            if ( !leadlist.isEmpty() ){
                for ( lead ld : leadlist ){
                    LeadIdwithPhone.put(ld.Id, ld.Phone);
                }
            }
            System.debug('LeadIdwithPhone =====> ' + LeadIdwithPhone);
        }
        if ( !accountids.isEmpty() ){
            list<account> accountlist = [select id, Phone
                                         from Account
                                         where Id IN:accountids and phone != null];
            System.debug('accountlist ====> ' + accountlist);
            if ( !accountlist.isEmpty() ){
                for ( account acc : accountlist ){
                    accountIdwithPhone.put(acc.id, acc.phone);
                }
            }
            System.debug('accountIdwithPhone ====> ' + accountIdwithPhone);
        }

        List<AbbaSoft_User__c> AabaSoftUser = [SELECT AabaSoft_UserName__c, Agent_Unique_Id__c, CampaignID__c, Contact_Number__c, CreatedOn__c, First_Name__c, HashCode__c, Id, Last_Name__c, Password__c, Username__c, Email_Id__c
                                               FROM AbbaSoft_User__c];

        List<Campaign__c> CampaignList = [SELECT Campaign_ID__c, Id, Name, Name__c
                                          FROM Campaign__c];
        Map<String, string> mapofCampNameWithUniqueId = new map<String, string>();
        for ( Campaign__c Campvar : CampaignList ){
            mapofCampNameWithUniqueId.put(Campvar.Name__c, Campvar.Campaign_ID__c);
        }
        System.debug('mapofCampNameWithUniqueId ====> ' + mapofCampNameWithUniqueId);
        integer i = 0;
        string phoneNumber = '';
        string phonenumberv1 = '';

        for ( task tsk : taskList ){

            CustomerData CustomWrap = new CustomerData();
            System.debug('tsk.whoId ====> ' + tsk.whoId);
            System.debug('tsk.whatId ====> ' + tsk.WhatId);
            if ( tsk.WhatId != null ){
                String ObjectName = String.valueOf(( tsk.WhatId ).getsobjecttype());

                if ( !accountIdwithPhone.isEmpty() ){
                    if ( accountIdwithPhone.containsKey(tsk.WhatId) ){
                        phoneNumber = String.valueOf(accountIdwithPhone.get(tsk.WhatId)).right(10);
                    }
                }
                System.debug('phoneNumber =======> ' + phoneNumber);
                System.debug('phonenumberv1 =======> ' + phonenumberv1);
            }
            if ( tsk.Subject.containsIgnoreCase('FEMI Call') ){
                date todaydate = system.today();
                date Firstdateofthemonth = todaydate.toStartOfMonth();
                System.debug('Firstdateofthemonth ====> ' + Firstdateofthemonth);
                date fifteenthofthemonth = Firstdateofthemonth.addDays(15);
                date sixteenthofthemonth = Firstdateofthemonth.addDays(16);
                date ENDofthemonth = Firstdateofthemonth.addDays(30);

                date onemonthbackdate = todaydate.addMonths(-1);
                System.debug('onemonthbackdate =====> ' + onemonthbackdate);
                date Firstdateofthebackmonth = onemonthbackdate.toStartOfMonth();
                date fifteenthofthebackmonth = Firstdateofthebackmonth.addDays(15);
                //date sixteenthofthebackmonth = Firstdateofthebackmonth.addDays(16);
                //date ENDofthebackmonth = Firstdateofthebackmonth.addDays(30);

                date Twomonthbackdate = todaydate.addMonths(-2);
                System.debug('onemonthbackdate =====> ' + onemonthbackdate);
                date Firstdateofthetwobackmonth = Twomonthbackdate.toStartOfMonth();
                date sixteenthofthetwobackmonth = Firstdateofthetwobackmonth.addDays(16);
                Integer numberOfDays = Date.daysInMonth(sixteenthofthetwobackmonth.year(), sixteenthofthetwobackmonth.month());
                Date lastDayOfMonth = Date.newInstance(sixteenthofthetwobackmonth.year(), sixteenthofthetwobackmonth.month(), numberOfDays);


                // system.today().day() == 2 &&
                if ( system.today().day() == 2 && tsk.Product_Purchase_Date__c >= Firstdateofthebackmonth && tsk.Product_Purchase_Date__c <= fifteenthofthebackmonth && tsk.Subject == 'FEMI Call' ){
                    CustomWrap.mobileNumber = phoneNumber; //s1.right(3);
                    CustomWrap.dataUniqueID = String.valueOf(tsk.Id);
                    CustomWrap.agentUniqueID = String.valueOf(tsk.Agent_UniqueId__c);
                    CustomWrap.scheduleDateTime = String.valueOf(system.now().addminutes(1));
                    CustomWrap.campaignUniqueID = String.valueOf(tsk.AabaSoft_User__r.CampaignID__c);
                    // if (!mapofCampNameWithUniqueId.isEmpty()) {
                    //     CustomWrap.campaignUniqueID = mapofCampNameWithUniqueId.get('CampaignOne');
                    // }
                    if ( phoneNumber != null ){
                        CustomerDataList.add(CustomWrap);
                    }


                }
                //system.today().day() == 2 &&
                if ( system.today().day() == 2 && tsk.Product_Purchase_Date__c >= sixteenthofthetwobackmonth && tsk.Product_Purchase_Date__c <= lastDayOfMonth && tsk.Subject == 'FEMI Call' ){
                    CustomWrap.mobileNumber = phoneNumber; //s1.right(3);
                    CustomWrap.dataUniqueID = String.valueOf(tsk.Id);
                    CustomWrap.agentUniqueID = String.valueOf(tsk.Agent_UniqueId__c);
                    CustomWrap.scheduleDateTime = String.valueOf(system.now().addminutes(1));
                    CustomWrap.campaignUniqueID = String.valueOf(tsk.AabaSoft_User__r.CampaignID__c);
                    // if (!mapofCampNameWithUniqueId.isEmpty()) {
                    //     CustomWrap.campaignUniqueID = mapofCampNameWithUniqueId.get('CampaignOne');
                    // }
                    if ( phoneNumber != null ){
                        CustomerDataList.add(CustomWrap);
                    }


                }
            }
        }
        JSONWrapObject.CustomerData = CustomerDataList;


        Map<String, String> responseMap = AabaSoftGenerateAccessToken.GenerateAccessToken();

        System.debug('API Key ======> ' + String.valueof(responseMap.get('Key')));
        if ( String.valueof(responseMap.get('Key')) != null ){
            datainfoWarp.numberOfRecords = String.valueOf(CustomerDataList.size());
            datainfoWarp.apiKey = String.valueof(GetCustomerAPIKey);
            //datainfoWarp.dataInfoKey = '9C662EC4-2323-4C15-AAFD-1EBFG6067SB';
            datainfoWarp.dataInfoTime = String.valueOf(system.now());
        }
        JSONWrapObject.DataInfo = datainfoWarp;
        string SerializedWrap = Json.serialize(JSONWrapObject);
        System.debug('SerializedWrap =====> ' + SerializedWrap);
        HttpRequest req = new HttpRequest(  );
        req.setEndpoint(CustomerEndpoint);
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Content-Length', String.valueOf(( 'application/json' ).length()));
        req.setHeader('Authorization', 'Bearer ' + responseMap.get('Access_token'));
        req.setBody(String.valueOf(SerializedWrap));
        Http http = new Http(  );
        if ( CustomerDataList.size() > 0 ){
            HTTPResponse res = http.send(req);
            system.debug('res.getBody()::' + res.getBody());
            HttpUtility.httpReqHelper('CallOut_TaskTransfer', 'transferFEMICallDetails', 'POST', req, res);
        }
    }

    public static void TransferFollowUpTask(Set<id> TaskIds){

        JSON2Apex JSONWrapObject = new JSON2Apex();
        List<CustomerData> CustomerDataList = new List<CustomerData>();
        DataInfo datainfoWarp = new DataInfo();
        Set<id> accountids = new Set<id>();
        set<id> leadids = new set<id>();
        Map<string, string> accountIdwithPhone = new Map<string, string>();
        Map<string, string> LeadIdwithPhone = new Map<string, string>();
        map<id, Lead> LeadIdwithLead = new Map<id, Lead>();
        Map<Id, Account> AccountIdWithAccount = new Map<id, Account>();

        List<Task> taskList = [SELECT callRecordingURL__c, Call_Status__c, Id, OwnerId, Status, Subject, WhatId, whoId, Agent_UniqueId__c, AabaSoft_User__c, AabaSoft_User__r.CampaignID__c, Follow_Up_date__c, Product_Purchase_Date__c
                               FROM Task
                               Where Id IN:taskIds];

        for ( task tas : taskList ){
            if ( tas.whoId != null ){
                leadids.add(tas.WhoId);
            }
            if ( tas.WhatId != null ){
                accountids.add(tas.WhatId);
            }
        }
        if ( !leadids.isEmpty() ){
            List<lead> leadlist = [select id, phone
                                   from lead
                                   where Id IN:leadids and Phone != null];
            System.debug('leadlist =====> ' + leadlist);
            if ( !leadlist.isEmpty() ){
                for ( lead ld : leadlist ){
                    LeadIdwithPhone.put(ld.Id, ld.Phone);
                }
            }
            System.debug('LeadIdwithPhone =====> ' + LeadIdwithPhone);
        }
        if ( !accountids.isEmpty() ){
            list<account> accountlist = [select id, Phone
                                         from Account
                                         where Id IN:accountids and phone != null];
            System.debug('accountlist ====> ' + accountlist);
            if ( !accountlist.isEmpty() ){
                for ( account acc : accountlist ){
                    accountIdwithPhone.put(acc.id, acc.phone);
                }
            }
            System.debug('accountIdwithPhone ====> ' + accountIdwithPhone);
        }

        List<AbbaSoft_User__c> AabaSoftUser = [SELECT AabaSoft_UserName__c, Agent_Unique_Id__c, CampaignID__c, Contact_Number__c, CreatedOn__c, First_Name__c, HashCode__c, Id, Last_Name__c, Password__c, Username__c, Email_Id__c
                                               FROM AbbaSoft_User__c];

        List<Campaign__c> CampaignList = [SELECT Campaign_ID__c, Id, Name, Name__c
                                          FROM Campaign__c];
        Map<String, string> mapofCampNameWithUniqueId = new map<String, string>();
        for ( Campaign__c Campvar : CampaignList ){
            mapofCampNameWithUniqueId.put(Campvar.Name__c, Campvar.Campaign_ID__c);
        }
        System.debug('mapofCampNameWithUniqueId ====> ' + mapofCampNameWithUniqueId);
        integer i = 0;
        string phoneNumber = '';
        string phonenumberv1 = '';
        for ( task tsk : taskList ){
            CustomerData CustomWrap = new CustomerData();
            System.debug('tsk.whoId ====> ' + tsk.whoId);
            System.debug('tsk.whatId ====> ' + tsk.WhatId);
            if ( tsk.whoId != null ){
                String ObjectName = String.valueOf(( tsk.whoId ).getsobjecttype());
                if ( !LeadIdwithPhone.isEmpty() ){
                    if ( LeadIdwithPhone.containsKey(tsk.WhoId) ){
                        phoneNumber = string.valueOf(LeadIdwithPhone.get(tsk.WhoId)).right(10);
                    }
                }
                System.debug('Phonenumber ======> ' + phoneNumber);
                System.debug('phonenumberv1 ======> ' + phonenumberv1);
            }
            else if ( tsk.WhatId != null ){
                String ObjectName = String.valueOf(( tsk.WhatId ).getsobjecttype());
                if ( !accountIdwithPhone.isEmpty() ){
                    if ( accountIdwithPhone.containsKey(tsk.WhatId) ){
                        phoneNumber = String.valueOf(accountIdwithPhone.get(tsk.WhatId)).right(10);
                    }
                }
                System.debug('phoneNumber =======> ' + phoneNumber);
                System.debug('phonenumberv1 =======> ' + phonenumberv1);
            }

            if ( tsk.Subject.containsIgnoreCase('Follow-Up') ){
                CustomWrap.mobileNumber = phoneNumber; //s1.right(3);
                CustomWrap.dataUniqueID = String.valueOf(tsk.Id);
                CustomWrap.agentUniqueID = String.valueOf(tsk.Agent_UniqueId__c);
                //CustomWrap.agentUniqueID = TaskAssignmentToAabaSoftAgent.TaskAssignment(mapofCampNameWithUniqueId.get('CampaignOne'));
                if ( tsk.Follow_Up_date__c != null ){
                    CustomWrap.scheduleDateTime = String.valueOf(tsk.Follow_Up_date__c);
                }
                else{
                    CustomWrap.scheduleDateTime = String.valueOf(system.now().addminutes(1));
                }
                CustomWrap.campaignUniqueID = String.valueOf(tsk.AabaSoft_User__r.CampaignID__c);
                if ( phoneNumber != null ){
                    CustomerDataList.add(CustomWrap);
                }

            }
        }
        JSONWrapObject.CustomerData = CustomerDataList;


        Map<String, String> responseMap = AabaSoftGenerateAccessToken.GenerateAccessToken();
        //Map<String, string> Bodymap = new Map<String, String>();
        //Bodymap.put('apiKey', responseMap.get('Key'));

        System.debug('API Key ======> ' + String.valueof(responseMap.get('Key')));
        if ( String.valueof(responseMap.get('Key')) != null ){
            datainfoWarp.numberOfRecords = String.valueOf(CustomerDataList.size());
            datainfoWarp.apiKey = String.valueof(GetCustomerAPIKey);
            //datainfoWarp.dataInfoKey = '9C662EC4-2323-4C15-AAFD-1EBFG6067SB';
            datainfoWarp.dataInfoTime = String.valueOf(system.now());
        }
        JSONWrapObject.DataInfo = datainfoWarp;
        string SerializedWrap = Json.serialize(JSONWrapObject);
        System.debug('SerializedWrap =====> ' + SerializedWrap);
        HttpRequest req = new HttpRequest(  );
        req.setEndpoint(CustomerEndpoint);
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Content-Length', String.valueOf(( 'application/json' ).length()));
        req.setHeader('Authorization', 'Bearer ' + responseMap.get('Access_token'));
        req.setBody(String.valueOf(SerializedWrap));
        Http http = new Http(  );
        if ( CustomerDataList.size() > 0 ){

            System.debug('Iam about to callout');
            HTTPResponse res = http.send(req);
            system.debug('res.getBody()::' + res.getBody());
            HttpUtility.httpReqHelper('CallOut_TaskTransfer', 'Transfering_Tasks', 'POST', req, res);
        }
    }

    public class DataInfo{
        public String numberOfRecords;
        //public String dataInfoKey;
        public String dataInfoTime;
        public String apiKey;
    }

    public class CustomerData{
        public String dataUniqueID;
        public String mobileNumber;
        public String agentUniqueID;
        public String scheduleDateTime;
        public String campaignUniqueID;
    }

    public class JSON2Apex{
        public DataInfo DataInfo;
        public List<CustomerData> CustomerData;

    }

}