public with sharing class DependentPicklistGenerator {
    @AuraEnabled(cacheable=true)
    public static String fetchDependentPicklistValues(){
        Map<String,List<Map<String,List<String>>>> MapOfDependentPicklsit = new Map<String,List<Map<String,List<String>>>>();
        //SELECT Budget_Amount__c,City,Company,Country,CountryCode,Created_Sec__c,Created_time__c,Date_of_Birth__c,Gender__c,Industry,Interested_Product__c,Next_Steps__c,No_of_Agents__c,NumberOfEmployees,Occupation__c,Payment_Mode__c,PostalCode,Product_Category__c,Rating,State,Title,Wedding_Anniversary_Date__c FROM Lead WHERE Rating != null
        for(AggregateResult ag : [SELECT Status,Rating,LeadSource  FROM Lead WHERE Rating != null Group By Status, Rating, LeadSource]){
            Map<String,List<String>> mapOfRatingAndIndustry = new Map<String,List<String>>();
            if(mapOfRatingAndIndustry.containsKey(String.valueOf(ag.get('Rating')))){
                mapOfRatingAndIndustry.get(String.valueOf(ag.get('Rating'))).add(String.valueOf(ag.get('Rating')));
            }else{
                mapOfRatingAndIndustry.put(String.valueOf(ag.get('Status')),new List<String>{String.valueOf(ag.get('Status'))});
            }
            if(MapOfDependentPicklsit.containsKey(String.valueOf(ag.get('LeadSource')))){
                MapOfDependentPicklsit.get(String.valueOf(ag.get('LeadSource'))).add(mapOfRatingAndIndustry);
            }else{
                MapOfDependentPicklsit.put(String.valueOf(ag.get('LeadSource')),new List<Map<String,List<String>>>{mapOfRatingAndIndustry});
            }
        }
        return JSON.serialize(MapOfDependentPicklsit);
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getContactFields(){
        SObjectType contactType = Schema.getGlobalDescribe().get('Lead');
        Map<String,Schema.SObjectField> mfields = contactType.getDescribe().fields.getMap();

        List<String> sObjectDetailsList = new List<String>();
        for(String s : mfields.keySet()){
            sObjectDetailsList.add(String.valueOf(mfields.get(s)));
        }
        return sObjectDetailsList;
    }
}