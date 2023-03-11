public class GetCallHistoryDetails implements Queueable, Database.AllowsCallouts{
    
    Map<String, Integration_Metadata__mdt> metamap= new Map<String, Integration_Metadata__mdt>();
    Map<String, CallHistoryData> chMap	= new Map<String, CallHistoryData>();
    List<Integration_Metadata__mdt> msgs= new  List<Integration_Metadata__mdt>();
    List<Task> pendingcallTsks= new List<Task>();
    List<Task> callTsksList= new List<Task>();
    
    GetAbasoftToken.Requests req= new GetAbasoftToken.Requests();
    List<GetAbasoftToken.Requests> reqList= new List<GetAbasoftToken.Requests>();
    List<GetAbasoftToken.Results> resList = new List<GetAbasoftToken.Results>();
    
    Private String FromDate;
    Private String ToDate;
    Private String authorizationHeader;
    
    public GetCallHistoryDetails(String FD,String TD){
        this.FromDate= FD;
        this.ToDate= TD;
    }
    
    public void execute( QueueableContext qc ){
        //Get connection parameters from Metadata
        msgs = [SELECT DeveloperName, MasterLabel, ClientId__c,ClientSecret__c,Endpoint__c,Password__c,UserName__c 
                FROM Integration_Metadata__mdt];
        pendingcallTsks = [SELECT AbasoftId__c,callRecordingURL__c,Call_Duration_In_Seconds__c,Call_StartedOn__c,Call_Status__c,Destination_Mobile_Number__c,Id,Source_Mobile_Number__c,Status,Subject,WhatId,WhoId FROM Task WHERE Call_Status__c = 'PENDING' ];
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
        request.setTimeout(2 * 60 * 1000);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        authorizationHeader = 'Bearer ' + resList[0].access_token;
        request.setHeader('Authorization', authorizationHeader);
        
        String payload = '{"fromDate":"'+FromDate+'","toDate":"'+ToDate+'"}';
        
        request.setBody(payload);
        HttpResponse response = http.send(request); // send the request for getting call History details   
        
        if (response.getStatusCode() != 200) {
            System.debug('---->Call out The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            String responseJSON = response.getBody();//Get the response body of call history
            
            JSONCallHistory callhistorydataJSON= JSONCallHistory.parse(responseJSON);
            
            for(integer i=0;i<callhistorydataJSON.data.size();i++){
                chMap.put(callhistorydataJSON.data[i].uniqueIdentifier, callhistorydataJSON.data[i]);
            }
            
            for(Task ct: pendingcallTsks){
                
                If(chMap.containsKey(ct.AbasoftId__c)){
                    Task tsk= new Task();
                    tsk.Id= ct.Id;
                    String timevalue= chMap.get(ct.AbasoftId__c).duration;
                    String[] strTimeSplit = timevalue.split(':');
                    tsk.Call_Duration_In_Seconds__c = (Integer.valueOf(strTimeSplit[0])*3600)+(Integer.valueOf(strTimeSplit[1])*60)+Integer.valueOf(strTimeSplit[2]);
                    tsk.callRecordingURL__c = chMap.get(ct.AbasoftId__c).callRecordingURL;
                    tsk.Call_Status__c = chMap.get(ct.AbasoftId__c).callStatus;
                    tsk.Status='Completed';
                    
                    callTsksList.add(tsk);   
                }
            }
            update(callTsksList);
        }
 
    }
    
}