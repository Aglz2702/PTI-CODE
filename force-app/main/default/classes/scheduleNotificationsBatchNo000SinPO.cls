global class scheduleNotificationsBatchNo000SinPO implements Schedulable{
	global void execute(SchedulableContext sc) {
		NotificationsBatchNo000SinPO b = new NotificationsBatchNo000SinPO();
    	database.executebatch(b,200);
	}
}