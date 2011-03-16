module HappyMimi
  module CoreExt
    module Hash
      def symbolize_keys
        inject({}) do |options, (key, value)|
          options[(key.to_sym rescue key) || key] = value
          options
        end
      end
      
      def symbolize_keys!
        self.replace(self.symbolize_keys)
      end
    end
  end
end

class Hash
  include HappyMimi::CoreExt::Hash
end