/**
 *  @Name           TestContactTrigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Rodolfo Ramirez <rodolfo@doitcloud.consulting>
 *  @Description    Test method for Docusign web service
**/
@isTest
public class WebServiceMockImpl implements WebServiceMock {
   public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

        DocusignNetApi30.EnvelopeStatus envStatus = new DocusignNetApi30.EnvelopeStatus();
        envStatus.EnvelopeID = '1';
    
        DocusignNetApi30.CreateAndSendEnvelopeResponse_element respElement = new DocusignNetApi30.CreateAndSendEnvelopeResponse_element();
        respElement.CreateAndSendEnvelopeResult = envStatus;
    
        response.put('response_x', respElement);
    }
}