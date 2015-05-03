module CurrencyCloud
  
  class Settlement < Resource
    
    resource :settlements
    
    actions :create, :retrieve, :find, :delete

    def add_conversion(conversion_id)
      update_attributes(Settlement.add_conversion(id, conversion_id))
    end
    
    def remove_conversion(conversion_id)
      update_attributes(Settlement.remove_conversion(id, conversion_id))
    end
    
    def release
      update_attributes(Settlement.release(id))
    end
    
    def unrelease
      update_attributes(Settlement.unrelease(id))
    end

    def self.add_conversion(settlement_id, conversion_id)
      post("#{settlement_id}/add_conversion", conversion_id: conversion_id)
    end
    
    def self.remove_conversion(settlement_id, conversion_id)
      post("#{settlement_id}/remove_conversion", conversion_id: conversion_id)
    end
    
    def self.release(settlement_id)
      post("#{settlement_id}/release")
    end
    
    def self.unrelease(settlement_id)
      post("#{settlement_id}/unrelease")
    end    

    private
    def update_attributes(settlement)
      self.conversion_ids = settlement.conversion_ids
      self.status = settlement.status
      self.entries = settlement.entries
      self.updated_at = settlement.updated_at
      self.released_at = settlement.released_at
      self
    end
  end
end