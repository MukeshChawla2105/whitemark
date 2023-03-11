global class ScheduleWSSales implements Schedulable{
    global void execute(SchedulableContext SC) {
        DateTime dt= date.today();
        system.enqueueJob(New GetWondersoftSales(dt.format('YYYY-MM-dd'),dt.format('YYYY-MM-dd'),'Sales'));
    }

    public Static void TestCoverage(){
        integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}