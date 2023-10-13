/**
 *  @Name           TestSchedulableBatchDailyReport
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Test method for schedulableBatchDailyReport class
**/
@isTest
private class TestSchedulableBatchWeeklyReport {
	
	@isTest static void test_method_one() {
		String CRON_EXP = '0 0 0 15 3 ? 2030';

  		System.schedule('TestSchedulableBatchDailyReport', CRON_EXP, new schedulableBatchWeeklyReport());
	}
	
}