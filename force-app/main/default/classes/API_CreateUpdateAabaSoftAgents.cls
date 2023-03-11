@RestResource(urlMapping = '/CreateUpdateAgentRecord/*')
global with sharing class API_CreateUpdateAabaSoftAgents{
    @httpPost
    global static responseWrapper CreateUpdateAgent(){
        responseWrapper responseJSON = new responseWrapper();
        try{
            system.debug('Product Request List::' + RestContext.request.requestBody.tostring());
            API_CreateUpdateAabaSoftAgentsWrapper AabaSoft_Agent_Detail = API_CreateUpdateAabaSoftAgentsWrapper.parse(RestContext.request.requestBody.tostring());
            System.debug('AabaSoft_Agent_Detail  AgentID ====> ' + AabaSoft_Agent_Detail.AgentUniqueId);
            System.debug('AabaSoft_Agent_Detail  AgentID ====> ' + AabaSoft_Agent_Detail.UserName);
            System.debug('AabaSoft_Agent_Detail  AgentID ====> ' + AabaSoft_Agent_Detail.Password);

            List<AbbaSoft_User__c> ExistingAabaSoftAgents = new List<AbbaSoft_User__c>();


            if ( AabaSoft_Agent_Detail.UserName != null && AabaSoft_Agent_Detail.Password != null && AabaSoft_Agent_Detail.AgentUniqueId != Null ){
                AbbaSoft_User__c AS_Agent = new AbbaSoft_User__c();
                if ( AabaSoft_Agent_Detail.FirstName != null ){
                    AS_Agent.First_Name__c = AabaSoft_Agent_Detail.FirstName;
                }
                if ( AabaSoft_Agent_Detail.LastName != null ){
                    AS_Agent.Last_Name__c = AabaSoft_Agent_Detail.LastName;
                }
                if ( AabaSoft_Agent_Detail.UserName != null ){
                    AS_Agent.Username__c = AabaSoft_Agent_Detail.UserName;
                }
                if ( AabaSoft_Agent_Detail.EmailAddress != null ){
                    AS_Agent.Email_Id__c = AabaSoft_Agent_Detail.EmailAddress;
                }
                if ( AabaSoft_Agent_Detail.ContactNumber != null ){
                    AS_Agent.Contact_Number__c = AabaSoft_Agent_Detail.ContactNumber;
                }
                if ( AabaSoft_Agent_Detail.Password != null ){
                    AS_Agent.Password__c = AabaSoft_Agent_Detail.Password;
                }
                if ( AabaSoft_Agent_Detail.AgentUniqueId != null ){
                    AS_Agent.Agent_Unique_Id__c = AabaSoft_Agent_Detail.AgentUniqueId;
                }
                /*if (AabaSoft_Agent_Detail.CampaignId != null) {
                 AS_Agent.CampaignID__c = AabaSoft_Agent_Detail.CampaignId;
                 }*/

                ExistingAabaSoftAgents = [SELECT AabaSoft_UserName__c, Agent_Unique_Id__c, Assignment_Id__c, CampaignID__c, Campaign__c, Contact_Number__c, Email_Id__c, First_Name__c, HashCode__c, Id, IsTaskAssigned__c, Last_Name__c, Name, OwnerId, Password__c, Username__c
                                          FROM AbbaSoft_User__c
                                          Where Agent_Unique_Id__c = :AabaSoft_Agent_Detail.AgentUniqueId];
                System.debug('ExistingAabaSoftAgents ====> ' + ExistingAabaSoftAgents);


                if ( !ExistingAabaSoftAgents.isEmpty() ){
                    if ( ExistingAabaSoftAgents[0].CampaignID__c != AabaSoft_Agent_Detail.CampaignId ){
                        list<Campaign__c> camplist = [SELECT Campaign_ID__c, Campaign_Subject__c, CreatedById, CreatedDate, CreatedOn__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Last_RRid__c, Name, Name__c, OwnerId, 
                                                        (select id, Assignment_Id__c from AbbaSoft_Users__r)
                                                        FROM Campaign__c
                                                        where Campaign_ID__c = :AabaSoft_Agent_Detail.CampaignId];
                        if ( !camplist.isEmpty() ){
                            AS_Agent.Campaign__c = camplist[0].id;
                            AS_Agent.CampaignID__c = AabaSoft_Agent_Detail.CampaignId;
                            if ( camplist[0].AbbaSoft_Users__r.size() > 0 ){
                                AS_Agent.Assignment_Id__c = caculateLargestNumber(camplist[0].AbbaSoft_Users__r) + 1;
                                AS_Agent.IsTaskAssigned__c = false;
                                //AS_Agent.Assignment_Id__c = camplist[0].AbbaSoft_Users__r.size() + 1;
                            }
                            else{
                                AS_Agent.Assignment_Id__c = 1;
                            }

                        }
                    }
                    AS_Agent.Id = ExistingAabaSoftAgents[0].Id;
                    Update AS_Agent;
                    responseJSON.Message = 'Agent Details is Updated Successfully';
                    responseJSON.Success = true;
                    responseJSON.AgentName = AS_Agent.First_Name__c + ' ' + AS_Agent.Last_Name__c;
                    if ( AS_Agent.Id != null ){
                        JSON_Payload__c JP = new JSON_Payload__c();
                        JP.AbbaSoft_User__c = AS_Agent.Id;
                        JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                        insert JP;
                    }
                }
                else{
                    list<Campaign__c> camplist = [SELECT Campaign_ID__c, Campaign_Subject__c, CreatedById, CreatedDate, CreatedOn__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Last_RRid__c, Name, Name__c, OwnerId, 
                                                        (select id, Assignment_Id__c from AbbaSoft_Users__r)
                                                  FROM Campaign__c
                                                  where Campaign_ID__c = :AabaSoft_Agent_Detail.CampaignId];
                    if ( !camplist.isEmpty() ){
                        AS_Agent.Campaign__c = camplist[0].id;
                        AS_Agent.CampaignID__c = AabaSoft_Agent_Detail.CampaignId;
                        if ( camplist[0].AbbaSoft_Users__r.size() > 0 ){
                            AS_Agent.Assignment_Id__c = caculateLargestNumber(camplist[0].AbbaSoft_Users__r) + 1;
                            //AS_Agent.Assignment_Id__c = camplist[0].AbbaSoft_Users__r.size() + 1;
                        }
                        else{
                            AS_Agent.Assignment_Id__c = 1;
                        }

                    }

                    insert AS_Agent;
                    responseJSON.Message = 'Agent Record is Created Successfully';
                    responseJSON.Success = true;
                    responseJSON.AgentName = AS_Agent.First_Name__c + ' ' + AS_Agent.Last_Name__c;
                    if ( AS_Agent.Id != null ){
                        JSON_Payload__c JP = new JSON_Payload__c();
                        JP.AbbaSoft_User__c = AS_Agent.Id;
                        JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
                        insert JP;
                    }
                }
            }
            else{
                responseJSON.Message = 'Aither Agent Uniqueid or Username or password is Empty!!!!';
                responseJSON.Success = false;
                responseJSON.AgentName = null;

            }

        }
        catch ( Exception e ){
            System.debug('The Error has occured ======> ' + e.getStackTraceString());
            Execption__c ex = new Execption__c();
            ex.Class_Name__c = 'API_CreateUpdateAabaSoftAgents';
            ex.Ececption_Message__c = e.getMessage();
            ex.Method_Name__c = 'CreateUpdateAgent';
            ex.Stack_Trace__c = e.getStackTraceString();
            insert ex;

            responseJSON.Message = e.getMessage();
            responseJSON.Success = false;
            JSON_Payload__c JP = new JSON_Payload__c();
            JP.Payload_Description__c = e.getMessage() + 'at line number ==> ' + e.getLineNumber();
            JP.Payload_Request__c = String.valueOf(RestContext.request.requestBody.tostring());
            System.debug(' JP ======> ' + JP);
            insert JP;
        }
        return responseJSON;
    }

    public static decimal caculateLargestNumber(List<AbbaSoft_User__c> AabasoftuserUnderOnecamp){
        decimal largestnumber;
        list<Decimal> assignmentIdlist = new List<Decimal>();
        if (!AabasoftuserUnderOnecamp.isEmpty()) {
            for (AbbaSoft_User__c aabaUser : AabasoftuserUnderOnecamp) {
                assignmentIdlist.add(aabaUser.Assignment_Id__c);
            }
        }
        if (!assignmentIdlist.isEmpty()) {
            for (integer i=0;  i < assignmentIdlist.size(); i++) {
                if ( i == 0 ){
                    largestnumber = assignmentIdlist[i];
                }
                else if ( largestnumber < assignmentIdlist[i] ){
                    largestnumber = assignmentIdlist[i];
                }
            }
        }
        system.debug('largestnumber::' + largestnumber);
        return largestnumber;
    }

    global class responseWrapper{
        global String Message;            //message string
        global boolean Success;        // Success String
        global String AgentName;

    }

}