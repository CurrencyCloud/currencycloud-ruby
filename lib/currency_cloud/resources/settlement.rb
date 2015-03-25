module CurrencyCloud
  
  class Settlement < ResourcefulObject
    
    resource :settlements
    
    actions :create, :retrieve, :find
    
    def add_conversion(conversion_id)
      response = CurrencyCloud.request(:post, "#{self.class.resource}/#{self.id}/add_conversion", conversion_id: conversion_id)
      self.class.new(response) # TODO: Should just update state of current object using a refresh method?
    end
    
    def remove_conversion(conversion_id)
      response = CurrencyCloud.request(:post, "#{self.class.resource}/#{self.id}/remove_conversion", conversion_id: conversion_id)
      self.class.new(response) # TODO: Should just update state of current object using a refresh method?
    end
    
    def release
      response = CurrencyCloud.request(:post, "#{self.class.resource}/#{self.id}/release")
      self.class.new(response) # TODO: Should just update state of current object using a refresh method?
    end
    
    def unrelease
      response = CurrencyCloud.request(:post, "#{self.class.resource}/#{self.id}/unrelease")
      self.class.new(response) # TODO: Should just update state of current object using a refresh method?
    end
    
  end
end