module ACTV
  class AssetFactory
    attr_reader :response

    def initialize response_body
      @response = response_body
    end

    def asset
      types = ACTV::Asset.types
      klass = types.find { |type| type.valid? response }
      klass.new response
    end
  end
end
