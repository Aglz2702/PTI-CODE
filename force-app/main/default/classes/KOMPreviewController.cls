public with sharing class KOMPreviewController {
	public KOMPreviewController() {
		
	}
	public PageReference callPDF() {
		Id idKOM = apexpages.currentpage().getparameters().get('id');
		PageReference pageRef = new PageReference('/apex/KOMPDFPreview');
		pageRef.setRedirect(true);
		pageRef.getParameters().put('idKOM', idKOM);
		return pageRef;
	}
}