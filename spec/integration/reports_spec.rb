require 'spec_helper'

describe 'Reports', vcr: true do


  it "can #create_conversions_report" do
    conversions_report = CurrencyCloud::Reports.create_conversions_report

    expect(conversions_report.id).to eql('2f06edb7-7ff7-4370-9c32-0512ed1825ae')
    expect(conversions_report.short_reference).to eql('RP-8675452-YNXMLJ')
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
end
