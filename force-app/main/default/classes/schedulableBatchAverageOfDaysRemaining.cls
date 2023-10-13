/**
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/

global class schedulableBatchAverageOfDaysRemaining implements Schedulable {
	global void execute(SchedulableContext sc) {
		AverageOfDaysRemainingBatch b = new AverageOfDaysRemainingBatch();
		database.executebatch(b); 
	}
}