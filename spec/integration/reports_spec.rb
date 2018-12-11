# frozen_string_literal: true

require 'spec_helper'

describe 'Reports', vcr: true do


  it "can #create_conversions_report" do
    conversions_report = CurrencyCloud::Reports.create_conversions_report

    expect(conversions_report.id).to eql('2f06edb7-7ff7-4370-9c32-0512ed1825ae')
    expect(conversions_report.short_reference).to eql('RP-8675452-YNXMLJ')
    expect(conversions_report.description).to eql(nil)
    expect(conversions_report.search_params['scope']).to eql('own')
    expect(conversions_report.report_type).to eql('conversion')
    expect(conversions_report.status).to eql('processing')
    expect(conversions_report.failure_reason).to eql(nil)
    expect(conversions_report.expiration_date).to eql(nil)
    expect(conversions_report.report_url).to eql('')
    expect(conversions_report.account_id).to eql('72970a7c-7921-431c-b95f-3438724ba16f')
    expect(conversions_report.contact_id).to eql('a66ca63f-e668-47af-8bb9-74363240d781')
    expect(conversions_report.created_at).to eql('2018-11-15T14:08:19+00:00')
    expect(conversions_report.updated_at).to eql('2018-11-15T14:08:19+00:00')
  end

  it "can #create_payments_report" do
    payments_report = CurrencyCloud::Reports.create_payments_report

    expect(payments_report.id).to eql('6e3b3230-5cd8-420e-ae52-c6052d55e6fb')
    expect(payments_report.short_reference).to eql('RP-3199188-JPZZXS')
    expect(payments_report.description).to eql(nil)
    expect(payments_report.search_params['scope']).to eql('own')
    expect(payments_report.report_type).to eql('payment')
    expect(payments_report.status).to eql('processing')
    expect(payments_report.failure_reason).to eql(nil)
    expect(payments_report.expiration_date).to eql(nil)
    expect(payments_report.report_url).to eql('')
    expect(payments_report.account_id).to eql('72970a7c-7921-431c-b95f-3438724ba16f')
    expect(payments_report.contact_id).to eql('a66ca63f-e668-47af-8bb9-74363240d781')
    expect(payments_report.created_at).to eql('2018-11-15T14:08:20+00:00')
    expect(payments_report.updated_at).to eql('2018-11-15T14:08:20+00:00')
  end

  it "can #find_report_requests" do
    report_requests_result = CurrencyCloud::Reports.find_report_requests

    expect(report_requests_result.report_requests[0]['id']).to eql('075ce584-b977-4538-a524-16b759277d66')
    expect(report_requests_result.report_requests[0]['short_reference']).to eql('RP-5279826-KZJHNX')
    expect(report_requests_result.report_requests[0]['description']).to eql(nil)
    expect(report_requests_result.report_requests[0]['search_params']['buy_currency']).to eql('EUR')
    expect(report_requests_result.report_requests[0]['search_params']['sell_currency']).to eql('GBP')
    expect(report_requests_result.report_requests[0]['search_params']['scope']).to eql('own')
    expect(report_requests_result.report_requests[0]['report_type']).to eql('conversion')
    expect(report_requests_result.report_requests[0]['status']).to eql('completed')
    expect(report_requests_result.report_requests[0]['failure_reason']).to eql(nil)
    expect(report_requests_result.report_requests[0]['expiration_date']).to eql('2018-10-18T00:00:00+00:00')
    expect(report_requests_result.report_requests[0]['report_url']).to eql('https://ccycloud-reports-prod-demo1-customer-reporting.s3.eu-west-1.amazonaws.com/customer_reporting/075ce584-b977-4538-a524-16b759277d66/conversion_report_1610201808101539677748.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Acredentialsabc&X-Amz-Date=20181203T081009Z&X-Amz-Expires=172800&X-Amz-SignedHeaders=host&X-Amz-Security-Token=tokenabc&X-Amz-Signature=signatureabc')
    expect(report_requests_result.report_requests[0]['account_id']).to eql('bf5b1007-b364-43cc-b3d6-9f2d1be75297')
    expect(report_requests_result.report_requests[0]['contact_id']).to eql('ba33d76a-4a7f-4cb3-afa8-5678d5bc712a')
    expect(report_requests_result.report_requests[0]['created_at']).to eql('2018-10-16T08:15:46+00:00')
    expect(report_requests_result.report_requests[0]['updated_at']).to eql('2018-10-16T08:15:48+00:00')

    expect(report_requests_result.report_requests[1]['id']).to eql('f196bff2-d757-48b1-8ff9-91d7f4a6722b')
    expect(report_requests_result.report_requests[1]['short_reference']).to eql('RP-6268341-YWPLYH')
    expect(report_requests_result.report_requests[1]['description']).to eql('Test Report for Payment')
    expect(report_requests_result.report_requests[1]['search_params']['currency']).to eql('EUR')
    expect(report_requests_result.report_requests[1]['search_params']['scope']).to eql('own')
    expect(report_requests_result.report_requests[1]['report_type']).to eql('payment')
    expect(report_requests_result.report_requests[1]['status']).to eql('completed')
    expect(report_requests_result.report_requests[1]['failure_reason']).to eql(nil)
    expect(report_requests_result.report_requests[1]['expiration_date']).to eql('2018-10-28T00:00:00+00:00')
    expect(report_requests_result.report_requests[1]['report_url']).to eql('https://ccycloud-reports-prod-demo1-customer-reporting.s3.eu-west-1.amazonaws.com/customer_reporting/f196bff2-d757-48b1-8ff9-91d7f4a6722b/payment_report_2610201807101540538496.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=credentialsabc&X-Amz-Date=20181203T081010Z&X-Amz-Expires=172800&X-Amz-SignedHeaders=host&X-Amz-Security-Token=tokenabc&X-Amz-Signature=signatureabc')
    expect(report_requests_result.report_requests[1]['account_id']).to eql('bf5b1007-b364-43cc-b3d6-9f2d1be75297')
    expect(report_requests_result.report_requests[1]['contact_id']).to eql('ba33d76a-4a7f-4cb3-afa8-5678d5bc712a')
    expect(report_requests_result.report_requests[1]['created_at']).to eql('2018-10-26T07:21:32+00:00')
    expect(report_requests_result.report_requests[1]['updated_at']).to eql('2018-10-26T07:21:36+00:00')
  end

  it "can #retrieve_report_request" do
    report_request = CurrencyCloud::Reports.retrieve_report_request('075ce584-b977-4538-a524-16b759277d66')

    expect(report_request.id).to eql('075ce584-b977-4538-a524-16b759277d66')
    expect(report_request.short_reference).to eql('RP-5279826-KZJHNX')
    expect(report_request.description).to eql(nil)
    expect(report_request.search_params['buy_currency']).to eql('EUR')
    expect(report_request.search_params['sell_currency']).to eql('GBP')
    expect(report_request.search_params['scope']).to eql('own')
    expect(report_request.report_type).to eql('conversion')
    expect(report_request.status).to eql('completed')
    expect(report_request.failure_reason).to eql(nil)
    expect(report_request.expiration_date).to eql('2018-10-18T00:00:00+00:00')
    expect(report_request.report_url).to eql('https://ccycloud-reports-prod-demo1-customer-reporting.s3.eu-west-1.amazonaws.com/customer_reporting/075ce584-b977-4538-a524-16b759277d66/conversion_report_1610201808101539677748.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Acredentialsabc&X-Amz-Date=20181203T081009Z&X-Amz-Expires=172800&X-Amz-SignedHeaders=host&X-Amz-Security-Token=tokenabc&X-Amz-Signature=signatureabc')
    expect(report_request.account_id).to eql('bf5b1007-b364-43cc-b3d6-9f2d1be75297')
    expect(report_request.contact_id).to eql('ba33d76a-4a7f-4cb3-afa8-5678d5bc712a')
    expect(report_request.created_at).to eql('2018-10-16T08:15:46+00:00')
    expect(report_request.updated_at).to eql('2018-10-16T08:15:48+00:00')
  end
end
