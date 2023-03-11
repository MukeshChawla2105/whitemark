public without sharing class AccountTriggerHandler {
    
    Public static void UpdateTaskSubjectOnFieldUpdate(Map<id, Account> AccountOldmap, Map<id, Account> AccountNewMap){
        
        Set<Id> AccountIdsListToFetchTask = new Set<Id>();
        Set<Id> taskIdsListToupdate = new Set<Id>();
        list<task> tskList = new list<task>();
        if(!AccountNewMap.isEmpty()){
            for(Account acc : AccountNewMap.values()){
                if(acc.Next_Purchase_Date__c != Null && acc.Next_Purchase_Date__c != AccountOldmap.get(acc.Id).Next_Purchase_Date__c){
                    AccountIdsListToFetchTask.add(acc.Id);
                }
                if (acc.Follow_Up_date__c != null && acc.Follow_Up_date__c != AccountOldmap.get(acc.id).Follow_Up_date__c) {
                    Task tsk = new Task();
					 tsk.Subject = 'Follow-Up Call';
					 tsk.Status = 'Open';
					 tsk.Priority = 'Normal';
					 tsk.WhatId = acc.ID;
                     tsk.Follow_Up_date__c = acc.Follow_Up_Date__c;
					 tsk.OwnerId = acc.OwnerId;
					 tskList.add(tsk);
                }
            }

            System.debug('task list ===> ' + tskList);
            if (!tskList.isEmpty()) {
                insert tskList;
            }
            
            List<Task> TaskListToUpdate = [Select id, Subject, whoId, WhatId, ActivityDate From Task Where WhatId IN :AccountIdsListToFetchTask ];
            
            List<Task> taskListToBeUpdated = new List<task>();
            if(!TaskListToUpdate.isEmpty()){
                For(Task tas : TaskListToUpdate){
                    if(tas.Subject == 'Happy Call'){
                        tas.Status = 'Completed';
                        taskListToBeUpdated.add(tas);
                    }
                }
            }
            update taskListToBeUpdated;
        }
        
    }

}