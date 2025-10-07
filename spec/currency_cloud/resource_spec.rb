require 'spec_helper'

describe 'Resource' do
  before(:all) do
    class Person
      include CurrencyCloud::Resource
      resource :people
      actions :update, :delete
    end
  end

  describe '#save' do
    it 'only updates changed records' do
      person = Person.new(id: 1, name: 'Richard', surname: 'Nienaber')
      allow(Person.client).to receive(:post).with(1, name: 'John').and_return({id: 1, name: 'John', surname: 'Nienaber'})
      person.name = 'John'

      expect(person.save).to eq(person)
      expect(person.changed_attributes).to eq(Set.new)
    end

    it 'does nothing if nothing has changed' do
      person = Person.new(id: 1, name: 'Richard', surname: 'Nienaber')

      expect(person.save).to eq(person)
      expect(person.changed_attributes).to eq(Set.new)
    end
  end

  describe '#delete' do
    it 'removes resource' do
      person = Person.new(id: 1, name: 'Richard', surname: 'Nienaber')
      # Uses the class method to perform the deletion
      allow(Person).to receive(:delete).with(1)

      expect(person.delete).to eq(person)
    end
  end
end
