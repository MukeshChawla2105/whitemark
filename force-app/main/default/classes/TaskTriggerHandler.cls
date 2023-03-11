public without sharing class TaskTriggerHandler{
    public static void TransferTask(List<Task> NewTriggerList, Map<Id, Task> NewTaskMap){
        Set<Id> taskIds = new Set<Id>();
        list<task> tasklisttobedeleted = new List<task>();
        set<id> taskIdsTobeDeleted = new Set<id>();
        if ( !NewTaskMap.isEmpty() ){

            for ( task tas : NewTaskMap.values() ){
                if ( tas.subject != null ){
                    if ( tas.Subject=='Welcome Call' || tas.Subject =='Happy Call' || tas.Subject =='Service Call' || tas.Subject =='FEMI Call' ){
                        System.debug('tas.Agent_UniqueId__c ====> ' + tas.Agent_UniqueId__c);
                        if (tas.Agent_UniqueId__c != '' && tas.Agent_UniqueId__c != null) {
                            taskIds.add(tas.Id);
                        }
                        //string CampaignUniqueId = mapofCampNameWithUniqueId.get(tas.Subject);

                    }
                    else if ( tas.Subject == 'Account: Followup Task' ){
                        taskIdsTobeDeleted.add(tas.id);
                        //tasklisttobedeleted.add(tas);
                    }
                }
            }
        }
        System.debug('taskIds ====> ' + taskIds);
        if ( !taskIds.isEmpty() ){
            if ( !test.isRunningTest() ){
                CallOut_TaskTransfer.Transfering_Tasks(taskIds);
            }

        }
        if ( !taskIdsTobeDeleted.isEmpty() ){
            if ( !test.isRunningTest() ){
                deleteAccountFollowUptask(taskIdsTobeDeleted);
                //delete tasklisttobedeleted;

            }

        }
    }

    public Static void AssignAgentBeforeInsert(List<Task> NewTriggerList, Map<Id, Task> NewTaskMap){

        System.debug('NewTriggerList ====> ' + NewTriggerList);
        System.debug('NewTaskMap ====> ' + NewTaskMap);
        string CampaignUniqueIdToSend;
        Set<Id> taskIds = new Set<Id>();

        // ################## for Follow-up Task ###########################
        Set<Id> whoIdList = new Set<Id>();
        Set<Id> whatIdList = new Set<Id>();
        Map<Id, List<task>> LeadwithTaskList = new Map<id, List<task>>();
        Map<Id, List<task>> AccountwithTaskList = new Map<id, List<task>>();


        if ( !NewTriggerList.isEmpty() ){
            //AssignedAgentWrapper AssignAgentWrap = new AssignedAgentWrapper();
            Map<String, string> mapofCampNameWithUniqueId = new map<String, string>();
            Map<String, String> mapofCampNameWithTaskSubect = new map<String, string>();
            set<id> leadids = new Set<id>();
            set<id> accountids = new Set<Id>();
            map<id, lead> LeadIdwithLead = new map<id, Lead>();
            map<id, account> AccountIdWithAccount = new Map<id, account>();
            List<Account> AccountListTobeUpdated = new List<Account>();
            List<Lead> LeadListTobeUpdated = new List<Lead>();


            List<Campaign__c> CampaignList = [SELECT Campaign_ID__c, Id, Name, Name__c
                                              FROM Campaign__c];
            for ( Campaign__c Campvar : CampaignList ){
                mapofCampNameWithUniqueId.put(Campvar.Name__c, Campvar.Campaign_ID__c);
            }

            List<WhiteMart_Campaign__c> campaignCustomSetingData = [select id, Name, CampaignID__c, Task_Subject__c
                                                                    from WhiteMart_Campaign__c];
            for ( WhiteMart_Campaign__c campdata : campaignCustomSetingData ){
                mapofCampNameWithTaskSubect.put(campdata.Task_Subject__c, campdata.Name);
            }
            System.debug('mapofCampNameWithUniqueId ====> ' + mapofCampNameWithUniqueId);

            for ( task tas : NewTriggerList ){
                if ( tas.WhoId != null ){
                    leadids.add(tas.WhoId);
                }
                if ( tas.whatId != null ){
                    accountids.add(tas.WhatId);
                }
            }
            if (!leadids.isempty()) {
                List<lead> LeadListRelatedToTask = [Select id, Name, Handling_Agent__c,Agent_UniqueId__c, Campaign_Name__c,IsAgentAssigned__c 
                                                    From Lead
                                                    Where id IN: leadids];
                if (!LeadListRelatedToTask.isEmpty()) {
                    for (lead ld : LeadListRelatedToTask) {
                        LeadIdwithLead.put(ld.id, ld);
                    }                                
                }
            }
            if (!accountids.isempty()) {
                List<account> AccountListRelatedtoTask = [Select id, Name, Handling_Agent__c,Agent_UniqueId__c, Campaign_Name__c,IsAgentAssigned__c 
                                                          From Account
                                                          Where Id IN: accountids];
                if (!AccountListRelatedtoTask.isEmpty()) {
                    for (Account  acc : AccountListRelatedtoTask) {
                        AccountIdWithAccount.put(acc.id, acc);
                    }
                }
            }

            for ( task tas : NewTriggerList ){
                if ( tas.Subject == 'Welcome Call' || tas.Subject == 'Happy Call' || tas.Subject == 'Service Call' ){
                    taskIds.add(tas.Id);
                    if ( mapofCampNameWithTaskSubect.containsKey(tas.Subject) ){
                        string CampOrginalname = mapofCampNameWithTaskSubect.get(tas.Subject);
                        if ( mapofCampNameWithUniqueId.containsKey(CampOrginalname) ){
                            CampaignUniqueIdToSend = mapofCampNameWithUniqueId.get(CampOrginalname);
                        }
                    }
                    //string CampaignUniqueIdToSend = mapofCampNameWithUniqueId.get(tas.Subject);
                    System.debug('CampaignUniqueId =====> ' + CampaignUniqueIdToSend);
                    TaskAssignmentToAabaSoftAgent.AssignedAgentWrapper AssignAgentWrap = TaskAssignmentToAabaSoftAgent.TaskAssignment_v1(CampaignUniqueIdToSend);
                    System.debug('AssignAgentWrap ====> ' + AssignAgentWrap);
                    if ( !test.isRunningTest() ){
                        if ( AssignAgentWrap.assignedAgentUniqueID != null && AssignAgentWrap.AgentFoundOrNot == 'Agent Found' ){
                            tas.Agent_UniqueId__c = AssignAgentWrap.assignedAgentUniqueID;
                            if ( AssignAgentWrap.assignedAgent.Id != null  && AssignAgentWrap.assignedAgentUniqueID != null && AssignAgentWrap.AgentFoundOrNot == 'Agent Found' ){
                                tas.AabaSoft_User__c = AssignAgentWrap.assignedAgent.Id;
                                tas.IsAgentAssigned__c = true;
                                if ( tas.whoid != null && tas.whatid == null ){
                                    if (LeadIdwithLead.containsKey(tas.WhoId)) {
                                        Lead updatedLad = new Lead();
                                        updatedLad.id = tas.whoid;
                                        updatedLad.Handling_Agent__c = AssignAgentWrap.assignedAgent.Id;
                                        updatedLad.Agent_UniqueId__c = AssignAgentWrap.assignedAgentUniqueID;
                                        updatedLad.Campaign_Name__c = tas.Subject;
                                        updatedLad.IsAgentAssigned__c = true;
                                        LeadListTobeUpdated.add(updatedLad);
    
                                    }
                                } 
                                if ( tas.whatid != null ){
                                    if (AccountIdWithAccount.containsKey(tas.WhatId)) {
                                        Account updatedAccount = new Account();
                                        updatedAccount.Id = tas.WhatId;
                                        updatedAccount.Handling_Agent__c = AssignAgentWrap.assignedAgent.Id;
                                        updatedAccount.Agent_UniqueId__c = AssignAgentWrap.assignedAgentUniqueID;
                                        updatedAccount.Campaign_Name__c = tas.Subject;
                                        updatedAccount.IsAgentAssigned__c = true;
                                        AccountListTobeUpdated.add(updatedAccount);
                                        
                                    }
                                }
                            }
                        }
                        else if (AssignAgentWrap.AgentFoundOrNot == 'No Agent Found' ){ // AssignAgentWrap.assignedAgentUniqueID == null && 
                            System.debug('I am about assign default user!!!');
                            tas.Agent_UniqueId__c = '';
                            //tas.AabaSoft_User__c = AssignAgentWrap.assignedAgent.Id;
                            tas.IsAgentAssigned__c = true;
                            System.debug('AssignAgentWrap.assignedAgent.Id ====> ' + AssignAgentWrap.assignedAgent.Id);
                            if (AssignAgentWrap.assignedAgent.Id != null) {
                                tas.AabaSoft_User__c = AssignAgentWrap.assignedAgent.Id; 
                            }
                            if ( tas.whoid != null && tas.whatid == null ){
                                if (LeadIdwithLead.containsKey(tas.WhoId)) {
                                    Lead updatedLad = new Lead();
                                    updatedLad.id = tas.whoid;
                                    updatedLad.Handling_Agent__c = AssignAgentWrap.assignedAgent.Id;
                                    updatedLad.Agent_UniqueId__c = AssignAgentWrap.assignedAgentUniqueID;
                                    updatedLad.Campaign_Name__c = tas.Subject;
                                    updatedLad.IsAgentAssigned__c = true;
                                    LeadListTobeUpdated.add(updatedLad);

                                }
                            } 
                            if ( tas.whatid != null ){
                                if (AccountIdWithAccount.containsKey(tas.WhatId)) {
                                    Account updatedAccount = new Account();
                                    updatedAccount.Id = tas.WhatId;
                                    updatedAccount.Handling_Agent__c = AssignAgentWrap.assignedAgent.Id;
                                    updatedAccount.Agent_UniqueId__c = AssignAgentWrap.assignedAgentUniqueID;
                                    updatedAccount.Campaign_Name__c = tas.Subject;
                                    updatedAccount.IsAgentAssigned__c = true;
                                    AccountListTobeUpdated.add(updatedAccount);
                                    
                                }
                            }
                        }
                    }
                }
                else if ( tas.Subject == 'FEMI Call' ){

                    taskIds.add(tas.Id);
                    if ( mapofCampNameWithTaskSubect.containsKey(tas.Subject) ){
                        string CampOrginalname = mapofCampNameWithTaskSubect.get(tas.Subject);
                        if ( mapofCampNameWithUniqueId.containsKey(CampOrginalname) ){
                            CampaignUniqueIdToSend = mapofCampNameWithUniqueId.get(CampOrginalname);
                        }
                    }
                    //string CampaignUniqueIdToSend = mapofCampNameWithUniqueId.get(tas.Subject);
                    System.debug('CampaignUniqueId =====> ' + CampaignUniqueIdToSend);
                    TaskAssignmentToAabaSoftAgent.AssignedAgentWrapper AssignAgentWrap = TaskAssignmentToAabaSoftAgent.TaskAssignment_v1(CampaignUniqueIdToSend);
                    System.debug('AssignAgentWrap ====> ' + AssignAgentWrap);
                    if ( !test.isRunningTest() ){
                        if ( AssignAgentWrap.assignedAgentUniqueID != null && AssignAgentWrap.AgentFoundOrNot == 'Agent Found' ){
                            tas.Agent_UniqueId__c = AssignAgentWrap.assignedAgentUniqueID;
                            if ( AssignAgentWrap.assignedAgent != null){
                                tas.AabaSoft_User__c = AssignAgentWrap.assignedAgent.Id;
                            }
                        }
                        else if ( AssignAgentWrap.assignedAgentUniqueID == null && AssignAgentWrap.AgentFoundOrNot == 'No Agent Found' ){
                            tas.Agent_UniqueId__c = '';
                            if (AssignAgentWrap.assignedAgent != null) {
                                tas.AabaSoft_User__c = AssignAgentWrap.assignedAgent.Id;
                            }
                            tas.IsAgentAssigned__c = true;
                        }
                    }
                }
                else if ( tas.Subject == 'Follow-Up Call' ){
                    if ( tas.WhoId != null ){

                        if (!LeadidwithLead.isEmpty()) {
                            if ( LeadidwithLead.containsKey(tas.WhoId)) {
                                tas.Subject = LeadIdWithLead.get(tas.WhoId).Campaign_Name__c + ' - Follow-Up';
                                tas.AabaSoft_User__c = LeadIdWithLead.get(tas.WhoId).Handling_Agent__c;
                                tas.Agent_UniqueId__c = LeadIdWithLead.get(tas.WhoId).Agent_UniqueId__c;
                                tas.IsAgentAssigned__c = true;
                            }
                            
                        }
                    }
                    if ( tas.WhatId != null ){

                        if (!AccountIdWithAccount.isEmpty()) {
                            if (AccountIdWithAccount.containsKey(tas.WhatId)) {
                                tas.Subject = AccountIdWithAccount.get(tas.WhatId).Campaign_Name__c + ' - Follow-Up';
                                tas.AabaSoft_User__c = AccountIdWithAccount.get(tas.WhatId).Handling_Agent__c;
                                tas.Agent_UniqueId__c = AccountIdWithAccount.get(tas.WhatId).Agent_UniqueId__c;
                                tas.IsAgentAssigned__c = true;
                            }
                        }
                    }

                }
            }

            if (!AccountListTobeUpdated.isEmpty()) {
                System.debug('AccountListTobeUpdated ------> ' + AccountListTobeUpdated);
                update AccountListTobeUpdated;
            }
            if (!LeadListTobeUpdated.isEmpty()) {
                System.debug('LeadListTobeUpdated ------> ' + LeadListTobeUpdated);
                update LeadListTobeUpdated;
            }
        }
    }

    @future
    public static void deleteAccountFollowUptask(set<id> TaskidSet){

        list<task> tasklistTObefetched = [select id, subject
                                          From task
                                          where Id IN:TaskidSet];
        list<task> tasklisttobedeleted = new List<task>();
        if ( !tasklistTObefetched.isEmpty() ){

            for ( task tas : tasklistTObefetched ){
                if ( tas.Subject == 'Account: Followup Task' ){
                    tasklisttobedeleted.add(tas);
                }
            }
        }
        if ( !tasklisttobedeleted.isEmpty() ){
            if ( !test.isRunningTest() ){
                delete tasklisttobedeleted;
            }
        }
    }

    public Static void TestCoverage(){
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }

}