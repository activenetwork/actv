require 'actv/base'

module ACTV
  class Identity < ACTV::Base

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing an :id key.
    # @return [ACTV::Base]
    def initialize(attrs={})
      super
      raise ArgumentError, 'argument must have an :id key' unless id
    end

    # @param other [ACTV::Identity]
    # @return [Boolean]
    def ==(other)
      super || attr_equal(:id, other) || attrs_equal(other)
    end

    # @return [Integer]
    def id
      @attrs[:id]
    end

  end
end