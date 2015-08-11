require 'bundler'
Bundler.require

require 'csv'
require 'faker'

module TestData
  SUBJECT_COUNT = 1000

  Config = Struct.new(:klass, :attributes) do
    def generate
      attributes.map { |attribute| Faker.const_get(klass).send(attribute) }
    end
  end

  class ConfigList
    attr_accessor :configs, :labels

    def initialize(labels, *config)
      self.labels = ['Subject'] + labels
      self.configs = []
      config.each_slice(2) do |(klass, attributes)|
        self.configs << Config.new(klass, attributes)
      end
    end

    def generate_for(subject)
      generated = [subject]
      configs.each do |config|
        generated += config.generate
      end
      generated
    end
  end

  class Generator
    attr_accessor :directory

    def initialize(directory)
      self.directory = directory
    end

    def run
      generate('company')
      generate('location')
      generate('person')
    end

    private

      def company_config
        ConfigList.new(
          %w[Name Suffix EIN DunsNumber],
          :Company, [:name, :suffix, :ein, :duns_number]
        )
      end

      def generate(name)
        config_list = send("#{name}_config")
        CSV.open(directory.join("#{name}.csv"), 'wb', force_quotes: true) do |csv|
          csv << config_list.labels
          (1..SUBJECT_COUNT).each do |subject|
            csv << config_list.generate_for(subject)
          end
        end
      end

      def location_config
        ConfigList.new(
          %w[City Street Address Address2 Building ZipCode TimeZone Country Lat Lng],
          :Address, [:city, :street_name, :street_address, :secondary_address,
            :building_number, :zip_code, :time_zone, :country, :latitude, :longitude]
        )
      end

      def person_config
        ConfigList.new(
          %w[Email Prefix FirstName LastName Cell Fax],
          :Internet, [:email],
          :Name, [:prefix, :first_name, :last_name],
          :PhoneNumber, [:cell_phone, :cell_phone]
        )
      end
  end
end
