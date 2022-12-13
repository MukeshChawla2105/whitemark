public class BatchLeadPhoneUpdateSchedule implements Schedulable {

    // Every Day at 12 AM, ( 0 0 0 ? * * * )
    public void Execute(SchedulableContext bc){
        Database.executeBatch(new BatchLeadPhoneUpdate());
    }
}