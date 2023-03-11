global class ScheduleBatchToAssignLeads implements Schedulable{
    global void execute(SchedulableContext sc) {
        LeadAssignmentBatch batchInstance = new LeadAssignmentBatch();
        Database.executeBatch(batchInstance);
    }
}