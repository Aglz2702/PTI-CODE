global class scheduleNotificationBatchNo0 implements Schedulable{
	global void execute(SchedulableContext sc) {
		NotificationsBatchNo0 b = new NotificationsBatchNo0();
    	database.executebatch(b,200);
	}
}