global class scheduleNotificationBatchNo000 implements Schedulable{
	global void execute(SchedulableContext sc) {
		NotificationsBatchNo000 b = new NotificationsBatchNo000();
    	database.executebatch(b,200);
	}
}