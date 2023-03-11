public with sharing class ScheduleGetCallHistoryDetails_Batch implements Queueable, Database.AllowsCallouts{
    public void execute(QueueableContext context){
        DateTime dt= date.today();

        Map<String, Integration_Metadata__mdt> metamap= new Map<String, Integration_Metadata__mdt>();
        List<Integration_Metadata__mdt> msgs= new  List<Integration_Metadata__mdt>();
        GetAbasoftToken.Requests req= new GetAbasoftToken.Requests();
        List<GetAbasoftToken.Requests> reqList= new List<GetAbasoftToken.Requests>();
        List<GetAbasoftToken.Results> resList = new List<GetAbasoftToken.Results>();
        HttpResponse response;
    
        String fromAndToDate = dt.format('YYYY-MM-dd');
        try{
                
                String authorizationHeader;

                msgs = [SELECT DeveloperName, MasterLabel, ClientId__c,ClientSecret__c,Endpoint__c,Password__c,UserName__c FROM Integration_Metadata__mdt WITH SECURITY_ENFORCED];
                
                for(Integration_Metadata__mdt msg: msgs){
                    metamap.put(msg.DeveloperName, msg);
                }
                //Parameters for access token
                req.Endpoint= metamap.get('Abasoft_Token').Endpoint__c;
                req.UserName=metamap.get('Abasoft_Token').UserName__c;
                req.Password=metamap.get('Abasoft_Token').Password__c;
                req.ClientId= metamap.get('Abasoft_Token').ClientId__c;
                req.ClientSecret=metamap.get('Abasoft_Token').ClientSecret__c;
                
                reqList.add(req);
                resList = GetAbasoftToken.getAbasoftTokendetails(reqList);
                
                //Callout to get the call history details
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                
                //Set the parameters for call history callout request
                request.setEndpoint(metamap.get('Abasoft_Call_History').Endpoint__c);
                //request.setTimeout(2 * 60 * 1000);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                
                authorizationHeader = 'Bearer ' + resList[0].access_token;
                request.setHeader('Authorization', authorizationHeader);
                
                String payload = '{"fromDate":"'+fromAndToDate+'","toDate":"'+fromAndToDate+'"}';
                
                request.setBody(payload);
                response = http.send(request); // send the request for getting call History details   
                
                if (response.getStatusCode() != 200) {
                    System.debug('---->Call out The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
                }else {
                    String responseJSON = response.getBody();//Get the response body of call history
                    
                    JSONCallHistory callhistorydataJSON = JSONCallHistory.parse(responseJSON);

                    Map<String, CallHistoryData> chMap	= new Map<String, CallHistoryData>();

                    if(callhistorydataJSON.data.size() != null){
                        for(integer i=0;i<callhistorydataJSON.data.size();i++){
                            If(callhistorydataJSON.data[i].uniqueIdentifier!=null){
                                chMap.put(callhistorydataJSON.data[i].uniqueIdentifier, callhistorydataJSON.data[i]);
                            }
                        }
                    }

                    if(chMap.size()>0){
                        GetCallHistroyDetails_Batch batchable = new GetCallHistroyDetails_Batch(chMap);
                        Id jobId = Database.executeBatch(batchable, 1000);
                    }
                    
                }
        }catch(Exception e){
            Execption__c ex = new Execption__c();
            ex.Class_Name__c = 'ScheduleGetCallHistoryDetails_Batch';
            ex.Ececption_Message__c = e.getMessage() +'  '+e.getCause()+'  '+e.getLineNumber()+'  '+dt+'  '+fromAndToDate+'  '+response;
            ex.Stack_Trace__c = e.getStackTraceString();
            ex.Method_Name__c = 'execute';
            Insert ex;
            
        }
    }
}