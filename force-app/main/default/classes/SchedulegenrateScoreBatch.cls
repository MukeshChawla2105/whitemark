global class SchedulegenrateScoreBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      genrateScoreBatch batchInstance = new genrateScoreBatch(); 
      Database.executeBatch(batchInstance, 100);
       
       //This batch Will run everyday at 12AM
       //System.schedule('SchedulegenrateScoreBatch Runs at 12AM everyday : ', '0 0 0 ? * * *', new SchedulegenrateScoreBatch());
   }
}