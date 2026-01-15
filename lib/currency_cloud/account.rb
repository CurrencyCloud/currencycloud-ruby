module CurrencyCloud
  class Account
    include CurrencyCloud::Resource

    resource :accounts
    actions :create, :retrieve, :update, :current
    actions_post :find

    def self.get_payment_charges_settings(account_id, params={})
      settings = client.get("#{account_id}/payment_charges_settings", params)
      settings["payment_charges_settings"].map { |s| AccountPaymentChargesSetting.new(s) }
    end

    def self.update_payment_charges_settings(account_id, charge_settings_id, params)
      settings = client.post("#{account_id}/payment_charges_settings/#{charge_settings_id}", params)
      AccountPaymentChargesSetting.new(settings)
    end

    def self.get_compliance_settings(account_id, params={})
      settings = client.get("#{account_id}/compliance_settings", params)
      AccountComplianceSetting.new(settings)
    end

    def self.update_compliance_settings(account_id, params)
      settings = client.post("#{account_id}/compliance_settings", params)
      AccountComplianceSetting.new(settings)
    end
  end
end
