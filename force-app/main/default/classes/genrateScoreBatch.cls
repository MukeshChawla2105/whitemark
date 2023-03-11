global class genrateScoreBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
                 
        String query = 'SELECT Budget_Amount__c,Industry,isLeadScored__c, HasOptedOutOfEmail,Status,Campaign_Country_Code__c,LeadSource,City,Company,Country,CountryCode,Customer_Feedback__c,Date_of_Birth__c,District__c,Elapsed_Time_First_Contact__c,Email,Enquiry_Type__c,FirstName,First_contact_date_time__c,Gender__c,Updated_Phone__c,GeocodeAccuracy,Id,Include__c,Interested_Product__c,LastName,Lead_Id__c,Lead_Key__c,Lead_Number__c,Longitude,Loss_Reason__c,MiddleName,Next_Steps__c,No_of_Agents__c,NumberOfEmployees,Occupation__c,Owner__c,Payment_Mode__c,Phone_formatted__c,PhotoUrl,Product_Category__c,Religion__c,State,Title,Website,Wedding_Anniversary_Date__c FROM Lead where IsLeadScored__c = false';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Lead> LeadsToBeScored) {
        
        system.debug('==========Lead List ===== ' + LeadsToBeScored);
        
        // process each batch of records default size is 200
        Map<id, Lead> LeadMapToBeUpdated = new Map<id, Lead>();
        Decimal totalScore = 0;
        decimal MaximumScore = 0;
        List<Scorecard__c> ScoreList = [SELECT Enabled__c,Total_Weight__c,(SELECT Field_Name__c,Field_Type__c,Matching_Type__c,Matching_Value__c,Related_Object__c,Scorecard_Execution_Criteria_Name__c,Scorecard__c,Sequence__c FROM Execution_Criteria_Entry__R) FROM Scorecard__c where enabled__c = true];
        map<string,String> expectedValuebyCriteria = new Map<String,String>();
        map<string,Decimal> allotedMarksbyCriteria = new Map<String,Decimal>();
        map<string,String> leadValueForFields = new Map<String,String>();
        for(Scorecard__c scr:ScoreList){
            for(Execution_Criteria_Entry__c exe:scr.Execution_Criteria_Entry__R){
                expectedValuebyCriteria.put(exe.Field_Name__c,exe.Matching_Value__c);
                allotedMarksbyCriteria.put(exe.Field_Name__c,exe.Sequence__c);
            }
        }
        system.debug('expectedValuebyCriteria'+expectedValuebyCriteria);    
        system.debug('allotedMarksbyCriteria'+allotedMarksbyCriteria);
        
        for(String fieldval : expectedValuebyCriteria.keyset()){
            for(Lead ld:LeadsToBeScored)  {
                lead leadtobeupdated = new lead();
                MaximumScore = MaximumScore+allotedMarksbyCriteria.get(fieldval);
                if(expectedValuebyCriteria.get(fieldval) == String.valueOf(ld.get(fieldval))){
                    totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                }
                leadtobeupdated.Lead_Score__c = totalScore;
                leadtobeupdated.Maximum_Score__c = MaximumScore;
                leadtobeupdated.Id = ld.Id;
                leadtobeupdated.IsLeadScored__c = true;
                LeadMapToBeUpdated.put(ld.id, leadtobeupdated);
            }
        }
            update LeadMapToBeUpdated.values();
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()]; 
    }

}