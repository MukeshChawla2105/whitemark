global class ScheduleWSSalesReturn implements Schedulable{
    global void execute(SchedulableContext SC) {
        DateTime dt= date.today();
        system.enqueueJob(New GetWondersoftSales(dt.format('YYYY-MM-dd'),dt.format('YYYY-MM-dd'),'Return'));
    }

}