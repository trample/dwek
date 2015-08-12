require 'bundler'
Bundler.require

require 'faker'

module TestData
  Config = Struct.new(:klass, :attributes) do
    def generate
      attributes.map { |attribute| Faker.const_get(klass).send(attribute) }
    end
  end
end
