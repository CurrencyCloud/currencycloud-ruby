require 'spec_helper'

describe 'Resource' do
  before(:all) do
    class Person < CurrencyCloud::Resource
      resource :people
      actions :update, :delete
    end
  end

  describe "#save" do
    it "only updates changed records" do
      person = Person.new(id: 1, name: 'Richard', surname: 'Nienaber')
      allow(person).to receive(:post).with(1, name: 'John')
      person.name = 'John'
      
      expect(person.save).to eq(person)
      expect(person.changed_attributes).to eq(Set.new)
    end

    it "does nothing if nothing has changed" do
      person = Person.new(id: 1, name: 'Richard', surname: 'Nienaber')
      
      expect(person.save).to eq(person)
      expect(person.changed_attributes).to eq(Set.new)
    end
  end

  describe "#delete" do
    it 'removes resource' do
      person = Person.new(id: 1, name: 'Richard', surname: 'Nienaber')
      allow(Person).to receive(:post).with('1/delete')

      expect(person.delete).to eq(person)
    end
  end
end
