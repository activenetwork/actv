require "actv/base"
require 'actv/client'
require 'actv/configurable'
require 'actv/default'

module ACTV
  class << self
    include ACTV::Configurable

    # Delegate to a ACTV::Client
    #
    # @return [ACTV::Client]
    def client
      ACTV::Client.new(options)
    end

    def options
      @options = {}
      ACTV::Configurable.keys.each do |key|
        @options[key] = instance_variable_get("@#{key}")
      end

      @options
    end

    def respond_to?(method, include_private=false)
      self.client.respond_to?(method, include_private) || super
    end

    def reset!
      ACTV::Configurable.keys.each do |key|
        instance_variable_set("@#{key}", ACTV::Default.options[key])
      end
      self
    end
    alias setup reset!

  private

    def method_missing(method, *args, &block)
      return super unless self.client.respond_to?(method)
      self.client.send(method, *args, &block)
    end

  end
end

ACTV.setup
