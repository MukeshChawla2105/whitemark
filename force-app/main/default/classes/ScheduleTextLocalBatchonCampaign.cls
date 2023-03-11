global class ScheduleTextLocalBatchonCampaign implements Schedulable{
    
    global String dailyCronExpression = '0 0 13 * * ?';
    global String monthlyCronExpression = '0 0 13 1 * ?';
    global String weeklyCronExpression = '0 0 13 ? * 1';
    
    global void execute(SchedulableContext SC) {
    }
    
    public static void scheduleThis(String recordId){
        system.debug('recordis'+recordId);
        BatchonCampaignTextLocalImmediately shn = new BatchonCampaignTextLocalImmediately(recordId); 
        database.executeBatch(shn ,30);
        
        
    }
    
}