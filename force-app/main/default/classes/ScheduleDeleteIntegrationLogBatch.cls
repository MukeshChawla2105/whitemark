public with sharing class ScheduleDeleteIntegrationLogBatch implements Schedulable {
    public void Execute(SchedulableContext bc){
        datetime todaydate = System.today();
        datetime tendaysagodate = System.today().addDays(-10);
        Database.executeBatch(new DeleteIntegrationLogBatch(tendaysagodate.year(), tendaysagodate.month(), tendaysagodate.day()));
    }
}