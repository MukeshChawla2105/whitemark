public without sharing class AabaSoftGenerateAccessToken{
    private static final String Agentendpoint = 'http://at228.ofabi.com/whitemartapi/api/agents';
    private static final String CampaignEndpoint = 'http://at228.ofabi.com/whitemartapi/api/campaigns';
    private static final String CustomerEndpoint = 'http://at228.ofabi.com/whitemartapi/api/customer_info';
    private static final String username = 'UAT718157';
    private static final String password = '40FC0743-FE87-4D80-A261-94DE106CEC07';
    private static final String grant_type = 'password';
    private static final String GetAgentAPIKey = 'd569c0d54acc05a16947d7b97c92693c30e81f2d832428c9e4576a95c3a11237791dd33e77b39995';
    private static final String GetCampaignAPIKey = 'd569c0d54acc05a16947d7b97c92693c30e81f2d832428c9e4576a95c3a11237791dd33e77b39995';
	/*Public static Authentication_Details__mdt authDetail = new Authentication_Details__mdt();
    public AabaSoftGenerateAccessToken(){
        
        authDetail = [Select Id,Agentendpoint__c,CampaignEndpoint__c,CustomerEndpoint__c,GetAgentAPIKey__c,GetCampaignAPIKey__c,grant_type__c,password__c,username__c From Authentication_Details__mdt ];
    }*/
    public Static Map<String, String> GenerateAccessToken(){
        Map<String, String> responseMap = new Map<String, String>();
        try{
			Authentication_Details__mdt authDetail = [Select Id,Agentendpoint__c,CampaignEndpoint__c,CustomerEndpoint__c,GetAgentAPIKey__c,GetCampaignAPIKey__c,grant_type__c,password__c,username__c From Authentication_Details__mdt];
            AabaSoft_BackEndAPI__mdt AabaSoftAPI = [SELECT Accept__c, apiSecretKey__c, Auth_Header__c, Auth_Key__c, Content_Type__c, DeveloperName, End_Point_URL__c, Id, Label, MasterLabel, Method__c, QualifiedApiName
                                                    FROM AabaSoft_BackEndAPI__mdt];
            System.debug('AabaSoftAPI ====> ' + AabaSoftAPI);
            HttpRequest req = new HttpRequest( );
            req.setEndpoint(AabaSoftAPI.End_Point_URL__c);
            req.setMethod(AabaSoftAPI.Method__c);
            req.setHeader('Content-Type', AabaSoftAPI.Content_Type__c);
            req.setHeader('Content-Length', String.valueOf(AabaSoftAPI.Content_Type__c.length()));
            req.setHeader('Accept', AabaSoftAPI.Accept__c);
            req.setHeader('apiSecretKey', AabaSoftAPI.apiSecretKey__c);
            string Encodedurl = 'UserName=' + string.valueOf(authDetail.username__c) + '&Password=' + string.valueOf(authDetail.password__c) + '&grant_type=' + String.valueOf(authDetail.grant_type__c);
            req.setBody(String.valueOf(Encodedurl));
            req.setTimeout(60 * 1000);

            Http http = new Http(  );
            HTTPResponse res = http.send(req);
            system.debug('res.getBody()::' + res.getBody());
            if ( res.getStatusCode() == 200 || res.getStatusCode() == 201 ){
                Map<String, Object> m = ( Map<String, Object> )JSON.deserializeUntyped(res.getBody());
                responseMap.put('Access_token', m.get('access_token').toString());
                responseMap.put('Refresh_token', m.get('refresh_token').toString());
                responseMap.put('Key', m.get('Key').toString());

            }
            System.debug('responseMap =====> ' + responseMap);

        }
        catch ( Exception e ){
            System.debug(' The error has occurred ======> ' + e.getStackTraceString());
        }

        return responseMap;
    }

    public static void getAgentList(){
        List<AbbaSoft_User__c> AabasoftUserlist = new List<AbbaSoft_User__c>();
        List<AbbaSoft_User__c> AabasoftUserlistTobeUpdated = new List<AbbaSoft_User__c>();
        list<AbbaSoft_User__c> ExistingAabasoftusers = new list<AbbaSoft_User__c>();
        
        try{
            Authentication_Details__mdt authDetail = [Select Id,Agentendpoint__c,CampaignEndpoint__c,CustomerEndpoint__c,GetAgentAPIKey__c,GetCampaignAPIKey__c,grant_type__c,password__c,username__c From Authentication_Details__mdt];
            Map<String, String> responseMap = GenerateAccessToken();
            Map<String, string> Bodymap = new Map<String, String>();
            Bodymap.put('apiKey', String.valueOf(authDetail.GetAgentAPIKey__c));
            System.debug('Bodymap =====> ' + Bodymap);
            System.debug(' Serialize Bodymap ======> ' + Json.serialize(Bodymap));
            HttpRequest req = new HttpRequest(  );
            req.setEndpoint(authDetail.Agentendpoint__c);
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json');
            req.setHeader('Content-Length', String.valueOf(( 'application/json' ).length()));
            req.setHeader('Authorization', 'Bearer ' + responseMap.get('Access_token'));
            req.setBody(String.valueOf(Json.serialize(Bodymap)));
            Http http = new Http(  );
            HTTPResponse res = http.send(req);
            system.debug('res.getBody()::' + res.getBody());
            if ( res.getStatusCode() == 200 || res.getStatusCode() == 000 ){
                Map<String, Object> m = ( Map<String, Object> )JSON.deserializeUntyped(res.getBody());
                System.debug('m======> ' + m);
                if ( m.containsKey('Agents') ){
                    List<Object> AgentList = ( List<Object> )m.get('Agents');
                    integer i = 0;
                    if ( !AgentList.isEmpty() ){
                        for ( Object AgentObj : AgentList ){
                            i++;
                            Map<String, Object> AgentMap = ( Map<String, Object> )AgentObj;
                            AbbaSoft_User__c Aabasoftuser = new AbbaSoft_User__c();
                            Aabasoftuser.Agent_Unique_Id__c = String.valueOf(AgentMap.get('AgentUniqueID'));
                            Aabasoftuser.AabaSoft_UserName__c = String.valueOf(AgentMap.get('AgentName'));
                            Aabasoftuser.Contact_Number__c = String.valueOf(AgentMap.get('MobileNumber'));
                            Aabasoftuser.CampaignID__c = String.valueOf(AgentMap.get('CampaignUniqueID'));
                            Aabasoftuser.First_Name__c = String.valueOf(AgentMap.get('FirstName'));
                            Aabasoftuser.Last_Name__c = String.valueOf(AgentMap.get('LastName'));
                            Aabasoftuser.Username__c = String.valueOf(AgentMap.get('UserName'));
                            Aabasoftuser.Password__c = String.valueOf(AgentMap.get('Password'));
                            Aabasoftuser.Email_Id__c = String.valueOf(AgentMap.get('EmailAddress'));
                            Aabasoftuser.CreatedOn__c = (DateTime) JSON.deserialize('"' + String.valueOf(AgentMap.get('CreatedOn')) + '"', DateTime.class);
                            //Aabasoftuser.Assignment_Id__c = ;
                            //Datetime.valueOf(AgentMap.get('CreatedOn'));
                            if (String.valueOf(AgentMap.get('CampaignUniqueID')) != null) {
                                ExistingAabasoftusers = [select id,CampaignID__c From AbbaSoft_User__c  where CampaignID__c =:String.valueOf(AgentMap.get('CampaignUniqueID'))];
                                System.debug('ExistingAabasoftusers =====> ' + ExistingAabasoftusers);
                                // if (!ExistingAabasoftusers.isEmpty()) {
                                //     Aabasoftuser.Assignment_Id__c = ExistingAabasoftusers.size()+1;
                                // }
                                // else {
                                //     Aabasoftuser.Assignment_Id__c = 1;
                                // }

                                List<Campaign__c> ExistingcampList = [SELECT Campaign_ID__c, Id, Name, Name__c
                                                                      FROM Campaign__c
                                                                      where Campaign_ID__c = :String.valueOf( AgentMap.get( 'CampaignUniqueID' ) )];
                                if (!ExistingcampList.isEmpty()) {
                                    Aabasoftuser.Campaign__c = ExistingcampList[0].id;
                                }
                            }
                            if ( String.valueOf(AgentMap.get('AgentUniqueID')) != null ){
                                List<AbbaSoft_User__c> ExistingAabasoftUserList = [SELECT AabaSoft_UserName__c, Agent_Unique_Id__c, CampaignID__c, Contact_Number__c, CreatedOn__c, First_Name__c, HashCode__c, Id, Last_Name__c, Password__c, Username__c, Email_Id__c
                                                                                   FROM AbbaSoft_User__c
                                                                                   where Agent_Unique_Id__c = :String.valueOf( AgentMap.get( 'AgentUniqueID' ) )]; //
                                if ( ExistingAabasoftUserList.isEmpty() ){
                                    if (!ExistingAabasoftusers.isEmpty()) {
                                        Aabasoftuser.Assignment_Id__c = ExistingAabasoftusers.size()+1;
                                    }
                                    else {
                                        Aabasoftuser.Assignment_Id__c = 1;
                                    }
                                    insert Aabasoftuser;
                                    //AabasoftUserlist.add(Aabasoftuser);
                                }
                                else if (!ExistingAabasoftUserList.isEmpty()) {
                                    Aabasoftuser.id = ExistingAabasoftUserList[0].id;
                                    //AabasoftUserlistTobeUpdated.add(Aabasoftuser);
                                    update Aabasoftuser;
                                }
                            }
                        }
                    }
                }
                System.debug('AabasoftUserlist ======> ' + AabasoftUserlist);
                // if ( !AabasoftUserlist.isEmpty() ){
                //     insert AabasoftUserlist;
                // }
                // if (!AabasoftUserlistTobeUpdated.isEmpty()) {
                //     update AabasoftUserlistTobeUpdated;
                // }
            }
        }
        catch ( Exception e ){
            System.debug(' The error has occured due to ======>  ' + e.getStackTraceString());
        }
    }

    public static void getCampaignDetailsList(){
        List<Campaign__c> CAMPList = new List<Campaign__c>();
        List<Campaign__c> CAMPListToBeUpdated = new List<Campaign__c>();
        map<String, WhiteMart_Campaign__c> CampUniqueIDwithName = new map<String, WhiteMart_Campaign__c>();
        list<WhiteMart_Campaign__c> WHCampListTobeInserted = new list<WhiteMart_Campaign__c>();
        list<WhiteMart_Campaign__c> WHCampListTobeUpdated = new list<WhiteMart_Campaign__c>();


        try{
            Authentication_Details__mdt authDetail = [Select Id,Agentendpoint__c,CampaignEndpoint__c,CustomerEndpoint__c,GetAgentAPIKey__c,GetCampaignAPIKey__c,grant_type__c,password__c,username__c From Authentication_Details__mdt];
            list<WhiteMart_Campaign__c> whitemartCampcustomsetting = [select id, name, CampaignID__c from WhiteMart_Campaign__c];
            for (WhiteMart_Campaign__c WH_Camp : whitemartCampcustomsetting) {
                CampUniqueIDwithName.put(WH_Camp.CampaignID__c, WH_Camp);    
            }
            Map<String, String> responseMap = GenerateAccessToken();
            Map<String, string> Bodymap = new Map<String, String>();
            Bodymap.put('apiKey', responseMap.get('Key'));
            System.debug('Bodymap =====> ' + Bodymap);
            System.debug(' Serialize Bodymap ======> ' + Json.serialize(Bodymap));
            HttpRequest req = new HttpRequest(  );
            req.setEndpoint(authDetail.CampaignEndpoint__c);
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json');
            req.setHeader('Content-Length', String.valueOf(( 'application/json' ).length()));
            req.setHeader('Authorization', 'Bearer ' + responseMap.get('Access_token'));
            req.setBody(String.valueOf(Json.serialize(Bodymap)));
            Http http = new Http(  );
            HTTPResponse res = http.send(req);
            system.debug('res.getBody()::' + res.getBody());
            if ( res.getStatusCode() == 200 || res.getStatusCode() == 000 ){
                Map<String, Object> m = ( Map<String, Object> )JSON.deserializeUntyped(res.getBody());
                System.debug('m======> ' + m);

                if ( m.containsKey('Campaigns') ){
                    List<Object> CampaignList = ( List<Object> )m.get('Campaigns');
                    if ( !CampaignList.isEmpty() ){
                        for ( Object CampObj : CampaignList ){
                            Map<String, Object> CampMap = ( Map<String, Object> )CampObj;
                            Campaign__c CAMP = new Campaign__c();
                            CAMP.Name__c = String.valueOf(CampMap.get('CampaignName'));
                            CAMP.Campaign_ID__c = String.valueOf(CampMap.get('CampaignUniqueID'));
                            CAMP.CreatedOn__c = (DateTime) JSON.deserialize('"' + String.valueOf(CampMap.get('CreatedOn')) + '"', DateTime.class);
                            //Datetime.valueOf(CampMap.get('CreatedOn'));
                            System.debug('String.valueOf(CampMap.get(CampaignUniqueID)) ====> ' + String.valueOf(CampMap.get('CampaignUniqueID')));
                            if ( String.valueOf(CampMap.get('CampaignUniqueID')) != null ){
                                List<Campaign__c> ExistingcampList = [SELECT Campaign_ID__c, Id, Name, Name__c
                                                                      FROM Campaign__c
                                                                      where Campaign_ID__c = :String.valueOf( CampMap.get( 'CampaignUniqueID' ) )];
                                if ( ExistingcampList.isEmpty() ){
                                    CAMPList.add(CAMP);
                                }
                                if ( !ExistingcampList.isEmpty() ){
                                    CAMP.id = ExistingcampList[0].id;
                                    CAMPListToBeUpdated.add(CAMP);
                                }
                                // if (CampUniqueIDwithName.isEmpty) {
                                //     WhiteMart_Campaign__c WH_campSetting = new WhiteMart_Campaign__c();
                                //     WH_campSetting.name = String.valueOf(CampMap.get('CampaignName'));
                                //     WH_campSetting.CampaignID__c = String.valueOf(CampMap.get('CampaignUniqueID'));
                                //     WHCampListTobeInserted.add(WH_campSetting);
                                // }
                                //else if (!CampUniqueIDwithName.isEmpty) {
                                    /*WhiteMart_Campaign__c WH_campSetting = new WhiteMart_Campaign__c();
                                    WH_campSetting.name = String.valueOf(CampMap.get('CampaignName'));
                                    WH_campSetting.CampaignID__c = String.valueOf(CampMap.get('CampaignUniqueID'));
                                    if (CampUniqueIDwithName.containsKey(String.valueOf(CampMap.get('CampaignUniqueID')))) {
                                        WH_campSetting.id = CampUniqueIDwithName.get(String.valueOf(CampMap.get('CampaignUniqueID'))).id;
                                        WHCampListTobeUpdated.add(WH_campSetting);
                                    }
                                    else{
                                        WHCampListTobeInserted.add(WH_campSetting);

                                    }*/
                                //}
                            }
                        }
                    }
                }
                System.debug('CAMPList ======> ' + CAMPList);
                if ( !CAMPList.isEmpty() ){
                    insert CAMPList;
                }
                if (!CAMPListToBeUpdated.isEmpty()) {
                    update CAMPListToBeUpdated;
                }
                /*if (!WHCampListTobeUpdated.isEmpty()) {
                    update WHCampListTobeUpdated;
                }
                if (!WHCampListTobeInserted.isEmpty()) {
                    insert WHCampListTobeInserted;
                }*/
            }
        }
        catch ( Exception e ){
            System.debug(' The error has occured due to ======>  ' + e.getStackTraceString());
        }
    }

}