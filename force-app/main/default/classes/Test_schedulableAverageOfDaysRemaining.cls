/**
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/

@isTest
private class Test_schedulableAverageOfDaysRemaining {
	
	@isTest static void test_method_one() {
		// Implement test code 
	}
	
	@isTest static void test_method_two() {
		// Implement test code
		String CRON_EXP = '0 0 0 15 3 ? 2030';

  		System.schedule('Test_schedulableAverageOfDaysRemaining', CRON_EXP, new schedulableBatchAverageOfDaysRemaining());
	}
	
}