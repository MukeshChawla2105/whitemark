/**
* Author	:	Jitendra Zaa
* Desc		:	Controller class for LEX component CircularProgress.
* 			:	On the basis of field API name passed, it calculates percentage of completion.
* */
public class CircularProgressController {    
    @AuraEnabled
    public static scorewrapper computePercentage(String recordId){
        scorewrapper scw = new scorewrapper();
        Integer retVal = 0 ;
        String query = null;
        List<Lead> ldList = [Select id,Maximum_Score__c,Lead_Score__c from lead where id =:recordId];
        try{
            if(ldList.size() > 0){
                retVal = Integer.valueOf( ( ldList[0].Lead_Score__c / ldList[0].Maximum_Score__c  ) * 100 );  
                scw.thresholdScore = ldList[0].Maximum_Score__c;
                scw.minimumScore = ldList[0].Lead_Score__c;
                scw.recievedpercenetage = retVal;
            } 
        }
        catch(Exception e){
        }
        return scw;    
    }         

    public class scorewrapper{
        @AuraEnabled
        public Decimal thresholdScore {get;set;}
        @AuraEnabled
        public Decimal minimumScore {get;set;}
        @AuraEnabled
        public Integer recievedpercenetage {get;set;}
    }
}