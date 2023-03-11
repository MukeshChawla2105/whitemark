@RestResource(urlMapping='/createLeadOrTask/*')
global class CreateLeadOrTask {
    
    @httpPost
    global static responseWrapper createLeadOrCreateTask(){
        responseWrapper responseJSON = new responseWrapper();
        try{
            system.debug('LeadRequestList::'+RestContext.request.requestBody.tostring());
            LeadDetails_client leadClientRec = LeadDetails_client.parse(RestContext.request.requestBody.tostring());
            system.debug('leadInfoRec ::'+leadClientRec);
            system.debug('leadInfoRec.Phone::'+leadClientRec.Phone);
            
            List<Lead> LdList = new List<Lead>();
            List<Account> Acclist = new List<Account>();
            
            if(!String.isBlank(leadClientRec.Phone)){
                String s2 = String.valueof(leadClientRec.Phone).right(10);
                string PhoneNumberForLike = '%'+s2;
                system.debug('Phone Number For Like :: ' + PhoneNumberForLike);
                LdList = [Select id, Company, Email, Phone, FirstName, LastName, OwnerId From Lead where IsConverted = false And phone LIKE: PhoneNumberForLike limit 1] ;
                Acclist = [Select id,Name,Website, Phone,OwnerId  From Account where phone LIKE: PhoneNumberForLike limit 1] ;
                system.debug('LdList>>'+LdList);
                system.debug('Account List>>'+Acclist);
                lead createLd = new lead();
                
                task tsk = new task();
                tsk.Subject = 'Missed Called';
                tsk.Status = 'Open';
                tsk.Priority = 'Normal';
                
                if(LdList.isEmpty() && Acclist.isEmpty()){
                    if(leadClientRec.FirstName != null){	
                        createLd.FirstName = string.valueOf(leadClientRec.FirstName);	
                    }
                    if(leadClientRec.LastName != null){	
                        createLd.LastName = string.valueOf(leadClientRec.LastName);	
                    }
                    if(leadClientRec.Phone != null){	
                        createLd.Phone = string.valueOf(leadClientRec.Phone);	
                    }
                    insert createLd;
                    // if (createLd.Id != null) {
                    //     tsk.Subject = 'Sales Call';
                    //     tsk.OwnerId = createLd.OwnerId;
                    //     insert tsk;
                        
                    // }
                    responseJSON.Message = 'Lead And Task Created Successfully';
                    responseJSON.Success = True;
                    responseJSON.CreatedRecordId = createLd.Id;
                }
                
                else if(!LdList.isEmpty() && Acclist.isEmpty()){
                    tsk.OwnerId = LdList[0].OwnerId;
                    tsk.WhoId = LdList[0].id;
                    insert tsk;
                    responseJSON.Message = 'Task Created Successfully on Lead';
                    responseJSON.Success = True;
                    responseJSON.CreatedRecordId = tsk.Id;
                }
                else if(LdList.isEmpty() && !Acclist.isEmpty()){
                    //tsk.Subject = 'Missed Called';
                    tsk.OwnerId = Acclist[0].OwnerId;
                    //tsk.Status = 'Open';
                    //tsk.Priority = 'Normal';
                    tsk.WhatId = Acclist[0].id;
                    insert tsk;
                    responseJSON.Message = 'Task Created Successfully on Account';
                    responseJSON.Success = True;
                    responseJSON.CreatedRecordId = tsk.Id;
                }	
                
            }
            else{
                responseJSON.Message = 'Please Provide Phone No.';
                responseJSON.Success = False;
            }
        }
        catch(exception e){
            System.debug('The following exception has occurred: ' + e.getMessage() + 'at ' + e.getLineNumber());
            responseJSON.Message = 'Some Error Occured--> ' + e.getMessage();
            responseJSON.Success = False;
        }
        return responseJSON;
    }
      
    global class responseWrapper {
        
        global String Message;			//message string
        global boolean Success ;		// Success String
        //global String LeadId ;
        global String CreatedRecordId ;			//CreatedRecordId
    }
    
}