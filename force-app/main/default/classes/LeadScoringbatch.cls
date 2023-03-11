public class LeadScoringbatch implements Database.Batchable <Sobject> {
    
    public Database.QueryLocator Start(Database.BatchableContext bc){
        String query = 'SELECT Budget_Amount__c,Industry,HasOptedOutOfEmail,Status,Campaign_Country_Code__c,LeadSource,City,Company,Country,CountryCode,Customer_Feedback__c,Date_of_Birth__c,District__c,Elapsed_Time_First_Contact__c,Email,Enquiry_Type__c,FirstName,First_contact_date_time__c,Gender__c,Updated_Phone__c,GeocodeAccuracy,Id,Include__c,Interested_Product__c,LastName,Lead_Id__c,Lead_Key__c,Lead_Number__c,Longitude,Loss_Reason__c,MiddleName,Next_Steps__c,No_of_Agents__c,NumberOfEmployees,Occupation__c,Owner__c,Payment_Mode__c,Phone_formatted__c,PhotoUrl,Product_Category__c,Religion__c,State,Title,Website,Wedding_Anniversary_Date__c FROM Lead where LastModifiedDate = today AND is_Lead_Scored__c = false';
        return Database.getQueryLocator(query);
    }
    
    public void Execute(Database.BatchableContext bc, List<Lead> LeadToUpdate){
        try{
            Decimal totalScore = 0;
            decimal MaximumScore = 0;
            List<Scorecard__c> ScoreList = [SELECT Enabled__c,Total_Weight__c,(SELECT Field_Name__c,Field_Type__c,Matching_Type__c,Matching_Value__c,Related_Object__c,Scorecard_Execution_Criteria_Name__c,Scorecard__c,Sequence__c FROM Execution_Criteria_Entry__R) FROM Scorecard__c where enabled__c = true];
            map<string,String> expectedValuebyCriteria = new Map<String,String>();
            map<string,Decimal> allotedMarksbyCriteria = new Map<String,Decimal>();
            map<string,String> fieldByMatchingType = new Map<String,String>();
            map<string,String> fieldByFieldType = new Map<String,String>();
            map<string,String> leadValueForFields = new Map<String,String>();
            for(Scorecard__c scr:ScoreList){
                for(Execution_Criteria_Entry__c exe:scr.Execution_Criteria_Entry__R){
                    expectedValuebyCriteria.put(exe.Field_Name__c,exe.Matching_Value__c);
                    fieldByMatchingType.put(exe.Field_Name__c,exe.Matching_Type__c);
                    fieldByFieldType.put(exe.Field_Name__c,exe.Field_Type__c);
                    allotedMarksbyCriteria.put(exe.Field_Name__c,exe.Sequence__c);
                }
            }
            system.debug('expectedValuebyCriteria'+expectedValuebyCriteria);    
            system.debug('allotedMarksbyCriteria'+allotedMarksbyCriteria);    
            
            for(String fieldval : expectedValuebyCriteria.keyset()){
                for(Lead ld:LeadToUpdate)  {
                    MaximumScore = MaximumScore+allotedMarksbyCriteria.get(fieldval);
                    if(fieldByMatchingType.get(fieldval) == 'Date'){
                        if(fieldByMatchingType.get(fieldval) == '<' || fieldByMatchingType.get(fieldval) == '<='){
                            if(date.valueOf(expectedValuebyCriteria.get(fieldval)) <= date.valueOf(ld.get(fieldval))){
                                totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                            }  
                        }else if(fieldByMatchingType.get(fieldval) == '>' || fieldByMatchingType.get(fieldval) == '>='){
                            if(date.valueOf(expectedValuebyCriteria.get(fieldval)) >= date.valueOf(ld.get(fieldval))){
                                totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                            }  
                        }else{
                            if(date.valueOf(expectedValuebyCriteria.get(fieldval)) == date.valueOf(ld.get(fieldval))){
                                totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                            }  
                        } 
                    }else if(fieldByMatchingType.get(fieldval) == 'Number'){
                        if(fieldByMatchingType.get(fieldval) == '<' || fieldByMatchingType.get(fieldval) == '<='){
                            if(Integer.valueOf(expectedValuebyCriteria.get(fieldval)) <= Integer.valueOf(ld.get(fieldval))){
                                totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                            }  
                        }else if(fieldByMatchingType.get(fieldval) == '>' || fieldByMatchingType.get(fieldval) == '>='){
                            if(Integer.valueOf(expectedValuebyCriteria.get(fieldval)) >= Integer.valueOf(ld.get(fieldval))){
                                totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                            }  
                        }else{
                            if(Integer.valueOf(expectedValuebyCriteria.get(fieldval)) == Integer.valueOf(ld.get(fieldval))){
                                totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                            }  
                        } 
                    }else{
                        if(fieldByMatchingType.get(fieldval) == '=='){
                            if(expectedValuebyCriteria.get(fieldval).contains(',')){
                                List<String> commaSeparatedValues = expectedValuebyCriteria.get(fieldval).split(',');
                                for(String Str:commaSeparatedValues){
                                    if(Str == String.valueOf(ld.get(fieldval))){
                                        totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                                    } 
                                }
                            }else{
                                if(expectedValuebyCriteria.get(fieldval) == String.valueOf(ld.get(fieldval))){
                                    totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                                }     
                            } 
                        }else if(fieldByMatchingType.get(fieldval) == '!='){
                            if(expectedValuebyCriteria.get(fieldval) != String.valueOf(ld.get(fieldval))){
                                totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                            }  
                        }else if(fieldByMatchingType.get(fieldval) == 'CONTAINS'){
                            if(String.valueOf(ld.get(fieldval)).contains(expectedValuebyCriteria.get(fieldval))){
                                totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                            }  
                        }else if(fieldByMatchingType.get(fieldval) == 'DOES NOT CONTAIN'){
                            if(!expectedValuebyCriteria.get(fieldval).contains(String.valueOf(ld.get(fieldval)))){
                                totalScore = totalScore+allotedMarksbyCriteria.get(fieldval);
                            }  
                        }
                    }
                    ld.Lead_Score__c=totalScore;
                    ld.Maximum_Score__c = MaximumScore;
                }
            }
            update LeadToUpdate;
        }catch(Exception e){
            System.debug('The Error Message :'+e.getMessage());
            System.debug('The Error Line :'+e.getLineNumber());
        }
        
    }
    
    public void Finish(Database.BatchableContext bc){
        System.debug('Batch Run Successfully');
    }
}