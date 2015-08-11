module TestData
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
end
