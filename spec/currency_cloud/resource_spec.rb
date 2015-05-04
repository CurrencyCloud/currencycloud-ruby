require 'spec_helper'

describe 'Resource' do
  before(:all) do
    class People < CurrencyCloud::Resource
      resource :people
      actions :update
    end
  end

  describe "#save" do
    it "only updates changed records" do
      person = People.new(id: 1, name: 'Richard', surname: 'Nienaber')
      allow(person).to receive(:post).with(1, name: 'John')
      person.name = 'John'
      
      expect(person.save).to eq(person)
      expect(person.changed_attributes).to eq(Set.new)
    end

    it "does nothing if nothing has changed" do
      person = People.new(id: 1, name: 'Richard', surname: 'Nienaber')
      
      expect(person.save).to eq(person)
      expect(person.changed_attributes).to eq(Set.new)
    end
  end
end
