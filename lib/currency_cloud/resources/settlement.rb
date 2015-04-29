module CurrencyCloud
  
  class Settlement < Resource
    
    resource :settlements
    
    actions :create, :retrieve, :find, :delete
    
    def add_conversion(conversion_id)
      # TODO: Should just update state of current object using a refresh method?
      new(request.post("#{self.resource}/#{self.id}/add_conversion", conversion_id: conversion_id))
    end
    
    def remove_conversion(conversion_id)
      # TODO: Should just update state of current object using a refresh method?
      new(request.post("#{self.resource}/#{self.id}/remove_conversion", conversion_id: conversion_id)) 
    end
    
    def release
      # TODO: Should just update state of current object using a refresh method?
      new(request.post("#{self.resource}/#{self.id}/release")) 
    end
    
    def unrelease
      # TODO: Should just update state of current object using a refresh method?
      new(request.post("#{self.resource}/#{self.id}/unrelease")) 
    end
    
  end
end