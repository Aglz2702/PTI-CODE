/**
 *  @Name           TestContactTrigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Rodolfo Ramirez <rodolfo@doitcloud.consulting>
 *  @Description    Test method for Docusign web service
**/

@isTest
public class DocusignNetApi30MockImpl implements WebServiceMock {
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
       
      System.debug(LoggingLevel.INFO, 'DocusignNetApi30MockImpl.doInvoke() - ' +
        '\n request: ' + request +
        '\n response: ' + response +
        '\n endpoint: ' + endpoint +
        '\n soapAction: ' + soapAction +
        '\n requestName: ' + requestName +
        '\n responseNS: ' + responseNS +
        '\n responseName: ' + responseName +
        '\n responseType: ' + responseType);

      if(request instanceOf DocusignNetApi30.CreateAndSendEnvelope_element) {
        response.put( 'response_x', new DocusignNetApi30.CreateAndSendEnvelopeResponse_element());
      }
      else if(request instanceOf DocusignNetApi30.CreateEnvelope_element) {
        response.put( 'response_x', new DocusignNetApi30.CreateEnvelopeResponse_element());
      }
      else if(request instanceOf DocusignNetApi30.CreateEnvelopeFromTemplates_element) {
        response.put( 'response_x', new DocusignNetApi30.CreateEnvelopeFromTemplatesResponse_element());
      }
      else if(request instanceOf DocusignNetApi30.CreateEnvelopeFromTemplatesAndForms_element) {
        response.put( 'response_x', new DocusignNetApi30.CreateEnvelopeFromTemplatesAndFormsResponse_element());
      }
      else if(request instanceOf DocusignNetApi30.RequestRecipientToken_element) {
        response.put( 'response_x', new DocusignNetApi30.RequestRecipientTokenResponse_element());
      }
      else if(request instanceOf DocusignNetApi30.RequestSenderToken_element) {
        response.put( 'response_x', new DocusignNetApi30.RequestSenderTokenResponse_element());
      }
      else if(request instanceOf DocusignNetApi30.SendEnvelope_element) {
        response.put( 'response_x', new DocusignNetApi30.SendEnvelopeResponse_element());
      }
   }
}