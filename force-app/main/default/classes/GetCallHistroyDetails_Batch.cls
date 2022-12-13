public with sharing class GetCallHistroyDetails_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    Set<string> abbasoftUniqueIdentifier = new Set<string>();
    Map<String, CallHistoryData> mapOfUniqueIdentifierAndJSONData = new Map<String, CallHistoryData>();
    Exception[] errors = new Exception[0];

    public GetCallHistroyDetails_Batch(Map<String, CallHistoryData> mapOfCallHistoryUniqueIdentifierAndJsonData){
        
        abbasoftUniqueIdentifier.addAll(mapOfCallHistoryUniqueIdentifierAndJsonData.keySet());
        System.debug(abbasoftUniqueIdentifier);
        mapOfUniqueIdentifierAndJSONData.putAll(mapOfCallHistoryUniqueIdentifierAndJsonData);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        RETURN Database.getQueryLocator([SELECT AbasoftId__c,callRecordingURL__c,Call_Duration_In_Seconds__c,Call_StartedOn__c,Call_Status__c,Destination_Mobile_Number__c,Id,Source_Mobile_Number__c,Status,Subject,WhatId,WhoId FROM Task WHERE Call_Status__c = 'PENDING' AND AbasoftId__c=:abbasoftUniqueIdentifier]);
    }

    public void execute(Database.BatchableContext bc, List<Task> scope) {
        try{
            List<Task> callTsksList= new List<Task>();
            for(Task pendingTask: scope){
                    
                If(mapOfUniqueIdentifierAndJSONData.containsKey(pendingTask.AbasoftId__c)){
                    Task tsk= new Task();
                    tsk.Id= pendingTask.Id;
                    String timevalue= mapOfUniqueIdentifierAndJSONData.get(pendingTask.AbasoftId__c).duration;
                    String[] strTimeSplit = timevalue.split(':');
                    tsk.Call_Duration_In_Seconds__c = (Integer.valueOf(strTimeSplit[0])*3600)+(Integer.valueOf(strTimeSplit[1])*60)+Integer.valueOf(strTimeSplit[2]);
                    tsk.callRecordingURL__c = mapOfUniqueIdentifierAndJSONData.get(pendingTask.AbasoftId__c).callRecordingURL;
                    tsk.Call_Status__c = mapOfUniqueIdentifierAndJSONData.get(pendingTask.AbasoftId__c).callStatus;
                    tsk.Status='Completed';
                    
                    callTsksList.add(tsk);   
                }
            }
            update(callTsksList);
        }catch(Exception ex){
            errors.add(ex);
        }
    }

    public void finish(Database.BatchableContext bc) {
        if(!errors.isEmpty()) {

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Errors occurred during batch process.');
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setSaveAsActivity(false);
            mail.setPlainTextBody('Exception are :- '+errors);
            Messaging.sendEmail(new Messaging.Email[] { mail });
        }
    }

}