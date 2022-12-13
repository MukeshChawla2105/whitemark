global class ScheduleWSPrevSales implements Schedulable{
    global void execute(SchedulableContext SC) {
        DateTime dt= date.today().addDays(-1);
        system.enqueueJob(New GetWondersoftSales(dt.format('YYYY-MM-dd'),dt.format('YYYY-MM-dd'),'Sales'));
    }

}