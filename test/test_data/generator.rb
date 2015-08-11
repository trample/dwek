require 'csv'

module TestData
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
