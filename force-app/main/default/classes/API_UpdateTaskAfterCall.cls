@RestResource(urlMapping = '/SendCallDetails/*')
global with sharing class API_UpdateTaskAfterCall{
    @httpPost
    global static responseWrapper TaskCallDetailsUpdation(){
        responseWrapper responseJSON = new responseWrapper();
        
        try{
            system.debug('Product Request List::' + RestContext.request.requestBody.tostring());
            API_UpdateTaskAfterCallWrapper Call_Details = API_UpdateTaskAfterCallWrapper.parse(RestContext.request.requestBody.tostring());
            List<AbbaSoft_User__c> ExistingAabaSoftAgents = new List<AbbaSoft_User__c>();
            Subtask__c subtask = new Subtask__c();
            task tas = new task();
            
            if ( Call_Details.dataUniqueID != null ){
                tas.TaskRecordId__c = Call_Details.dataUniqueID;
                subtask.Task_RecordId__c =  Call_Details.dataUniqueID;
                List<task> tasklist = [select id, accountId, WhatId, whoId, subject, CreatedDate
                                       from task
                                       where id = :Call_Details.dataUniqueID];
                if ( !tasklist.isEmpty()){
                    if ( tasklist[0].Whatid != null ){
                        tas.WhatId = tasklist[0].accountId;
                        subtask.Related_To__c = tasklist[0].WhatId;
                    }
                    else if ( tasklist[0].whoid != null ){
                        tas.whoId = tasklist[0].accountId;
                        subtask.Lead_Name__c = tasklist[0].whoId;
                    }
                    tas.Subject = tasklist[0].subject;
                    subtask.Subject__c = tasklist[0].subject + ' at :: ' +  String.valueOf(tasklist[0].CreatedDate);
                    if ( Call_Details.CallStatus != null ){
                        subtask.Call_Status__c = Call_Details.CallStatus;
                        tas.Agent_Call_Status__c = Call_Details.CallStatus;
                    }
                    if ( Call_Details.PhoneNumber != null ){
                        subtask.Contact_Number__c = Call_Details.PhoneNumber;
                        tas.Contact_Number__c = Call_Details.PhoneNumber;
                    }
                    if ( Call_Details.callStartTime != null ){
                        subtask.Call_StartedOn__c = datetime.valueOf(Call_Details.callStartTime);
                        tas.Call_StartedOn__c = datetime.valueOf(Call_Details.callStartTime);
                    }
                    if ( Call_Details.callEndTime != null ){
                        subtask.Call_End_Time__c = datetime.valueOf(Call_Details.callEndTime);
                        tas.Call_End_Time__c = datetime.valueOf(Call_Details.callEndTime);
                    }
                    if ( Call_Details.CallDuration != null ){
                        subtask.Call_Duration_In_Seconds__c = decimal.valueOf(Call_Details.CallDuration);
                        tas.Call_Duration_In_Seconds__c = decimal.valueOf(Call_Details.CallDuration);
                    }
                    if ( Call_Details.RecordingLink != null ){
                        subtask.Call_Recording_URL__c = Call_Details.RecordingLink;
                        tas.callRecordingURL__c = Call_Details.RecordingLink;
                    }
                    if ( Call_Details.CampaignId != null ){
                        tas.CampaignID__c = Call_Details.CampaignId;
                        subtask.CampaignID__c = Call_Details.CampaignId;
                    }
                    if ( Call_Details.AgentUniqueId != null ){
                        //tas.AabaSoft_User__c = Call_Details.AgentUniqueId;
                        ExistingAabaSoftAgents = [SELECT Contact_Number__c, First_Name__c, HashCode__c, Id, Last_Name__c, Name, Password__c, Agent_Unique_Id__c, Username__c, Email_Id__c
                                                  FROM AbbaSoft_User__c
                                                  Where Agent_Unique_Id__c = :Call_Details.AgentUniqueId];
                        if ( !ExistingAabaSoftAgents.isEmpty() ){
                            subtask.AabaSoft_User__c = ExistingAabaSoftAgents[0].id;
                            tas.AabaSoft_User__c = ExistingAabaSoftAgents[0].id;
                            
                            tas.AbasoftId__c = Call_Details.AgentUniqueId;
                            subtask.AbasoftId__c = Call_Details.AgentUniqueId;
                            insert subtask;
                            
                            responseJSON.Message = 'Call Details Recieved Successfully';
                            responseJSON.Success = true;
                            responseJSON.AgentName = ExistingAabaSoftAgents[0].First_Name__c + ' ' + ExistingAabaSoftAgents[0].Last_Name__c;
                            if ( subtask.Id != null ){
                                System.debug('task ki id ====> ' + subtask.Id);
                                JSON_Payload__c JP = new JSON_Payload__c();
                                JP.TaskRecordId__c = subtask.Id;
                                JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                                insert JP;
                            }
                        }
                        else{
                            responseJSON.Message = 'AgentUniqueId Does not exist in the system!!';
                            responseJSON.Success = true;
                            
                        }
                    }
                }
                else{
                    responseJSON.Message = 'dataUniqueId Does not exist in the system!!';
                    responseJSON.Success = true;
                }
                
            }
            else{
                responseJSON.Message = 'dataUniqueId is Empty!!';
                responseJSON.Success = true;
                
            }
            
        }
        catch ( Exception e ){
            System.debug('The Error has occured ======> ' + e.getStackTraceString());
            Execption__c ex = new Execption__c();
            ex.Class_Name__c = 'API_UpdateTaskAfterCall';
            ex.Ececption_Message__c = e.getMessage();
            ex.Method_Name__c = 'TaskCallDetailsUpdation';
            ex.Stack_Trace__c = e.getStackTraceString();
            insert ex;
            
            responseJSON.Message = 'Some Error has occured!! Please Check your JSON Payload';
            responseJSON.Success = false;
            JSON_Payload__c JP = new JSON_Payload__c();
            JP.Payload_Description__c = e.getMessage() + 'at line number ==> ' + e.getLineNumber();
            JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
            System.debug(' JP ======> ' + JP);
            insert JP;
            
        }
        return responseJSON;
    }
    
    global class responseWrapper{
        global String Message;            //message string
        global boolean Success;        // Success String
        global String AgentName;
        
    }
    
}