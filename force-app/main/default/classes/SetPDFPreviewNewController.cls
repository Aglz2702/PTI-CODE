public with sharing class SetPDFPreviewNewController {
	public Date dat{get;set;}
	public SetPDFPreviewNewController() {
		
	}
	public PageReference callPDF() {
		Id idwo = apexpages.currentpage().getparameters().get('id');
		PageReference pageRef = new PageReference('/apex/dailyReportNew');
		pageRef.setRedirect(true);
		pageRef.getParameters().put('idWO', idwo);
		pageRef.getParameters().put('date', dat.format());
		return pageRef;
	}
}