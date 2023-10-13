public with sharing class SetPDFPreviewController {
	public Date dat{get;set;}
	public SetPDFPreviewController() {
		
	}
	public PageReference callPDF() {
		Id idwo = apexpages.currentpage().getparameters().get('id');
		PageReference pageRef = new PageReference('/apex/dailyReportPreview');
		pageRef.setRedirect(true);
		pageRef.getParameters().put('idWO', idwo);
		pageRef.getParameters().put('date', dat.format());
		return pageRef;
	}
}