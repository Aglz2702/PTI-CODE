global class scheduleResetNotificationsBatch implements Schedulable{
	global void execute(SchedulableContext sc) {
		ResetNotificationsBatch b = new ResetNotificationsBatch();
    	database.executebatch(b,200);
	}
}