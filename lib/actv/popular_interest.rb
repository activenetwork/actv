require 'actv/identity'
require 'actv/interest'

module ACTV
  class PopularInterest < ACTV::Identity

    attr_reader :_index, :_type, :_id, :_version, :exists, :_source

    alias index _index
    alias type _type
    alias id _id
    alias version _version

    def interest
      @interest ||= ACTV::Interest.new(@attrs[:_source][:interest]) unless @attrs[:_source].nil? || @attrs[:_source][:interest].nil?
    end
  end
end