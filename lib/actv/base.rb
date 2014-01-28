require 'forwardable'
require 'actv/null_object'
require 'uri'

module ACTV
  class Base
    extend Forwardable
    attr_reader :attrs
    alias body attrs
    def_delegators :attrs, :delete, :update

    # Define methods that retrieve the value from an initialized instance variable Hash, using the attribute as a key
    #
    # @overload self.    attr_reader(attr)
    #   @param attr [Symbol]
    # @overload self.    attr_reader(attrs)
    #   @param attrs [Array<Symbol>]
    def self.attr_reader(*attrs)
      attrs.each do |attribute|
        define_attribute_method(attribute)
        define_predicate_method(attribute)
      end
    end

    def self.object_attr_reader(klass, key1, key2=nil)
      define_attribute_method(key1, kass, key2)
      define_predicate_method(key1)
    end

    def self.uri_attr_reader(*attrs)
      attrs.each do |uri_key|
        array = uri_key.to_s.split("_")
        index = array.index("uri")
        array[index] = "url"
        url_key = array.join("_").to_sym
        define_uri_method(uri_key, url_key)
        define_predicate_method(uri_key, url_key)

        alias_method(url_key, uri_key)
        alias_method("#{url_key}?", "#{uri_key}?")
      end
    end

    def self.define_uri_method(key1, key2)
      define_method(key1) do
        memoize(key1) do
          ::URI.parse(@attrs[key2]) if @attrs[key2]
        end
      end
    end

    def self.define_attribute_method(key1, klass=nil, key2=nil)
      define_method(key1) do
        memoize(key1) do
          if klass.nil?
            @attrs[key1]
          else
            if @attrs[key1]
              if key2.nil?
                ACTV.const_get(klass).new(@attrs[key1])
              else
                attrs = @attrs.dup
                value = attrs.delete(key1)
                ACTV.const_get(klass).new(value.update(key2 => attrs))
              end
            else
              ACTV::NullObject.instance
            end
          end
        end
      end
    end

    def self.define_predicate_method(key1, key2=key1)
      define_method(:"#{key1}?") do
        !!@attrs[key2]
      end
    end

    def self.from_response(response={})
      new(response[:body])
    end

    def initialize(attrs={})
      @attrs = attrs || {}
    end

    def [](method)
      send(method)
    rescue NoMethodError
      nil
    end

    def memoize(key, &block)
      ivar = :"@#{key}"
      return instance_variable_get(ivar) if instance_variable_defined?(ivar)
      result = block.call
      instance_variable_set(ivar, result)
    end

    def method_missing(meth, *args, &block)
      if @attrs && @attrs.has_key?(meth)
        @attrs[meth]
      elsif meth.to_s.include?('=') and !args.empty?
        @attrs[meth[0..-2].to_sym] = args.first
      else
        super
      end
    end

    def respond_to?(meth, *args)
      if @attrs && @attrs.has_key?(meth)
        true
      else
        super
      end
    end

    # Creation of object hash when sending request to soap
    def to_hash
      hash = {}
      hash["attrs"] = @attrs

      self.instance_variables.keep_if { |key| key != :@attrs }.each do |var|
        val = self.instance_variable_get(var)
        hash["attrs"][var.to_s.delete("@").to_sym] = val.to_hash if val.is_a? ACTV::Base
      end

      hash["attrs"]
    end

  protected

    # @param attr [Symbol]
    # @param other [ACTV::Base]
    # @return [Boolean]
    def attr_equal(attr, other)
      self.class == other.class && !other.send(attr).nil? && send(attr) == other.send(attr)
    end

    # @param other [ACTV::Base]
    # @return [Boolean]
    def attrs_equal(other)
      self.class == other.class && !other.attrs.empty? && attrs == other.attrs
    end

  end
end