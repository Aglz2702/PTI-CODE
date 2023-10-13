/**
 *  @Name           schedulableBatchDailyReport
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Class that allows to schedule the Batch process
**/
global class schedulableBatchDailyReport implements Schedulable{

	global void execute(SchedulableContext sc) {
    	DailyReportBatch b = new DailyReportBatch(true, false);
    	database.executebatch(b,50);
  	}

}