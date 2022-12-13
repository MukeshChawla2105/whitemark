global class WishlistCartItemSMSBatchSchedular implements Schedulable {
    global void execute(SchedulableContext sc) {
        WishlistCartItemSMSBatch batchObj = new WishlistCartItemSMSBatch(); 
        Database.executebatch(batchObj,1);
    }
}