global class scheduleNotificationBatchNo00 implements Schedulable{
	global void execute(SchedulableContext sc) {
		NotificationsBatchNo00 b = new NotificationsBatchNo00();
    	database.executebatch(b,200);
	}
}