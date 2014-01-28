require 'actv/channel'

module ACTV
  class AssetChannel < Base

    attr_reader :sequence

    def channel
      @channel ||= ACTV::Channel.new(@attrs[:channel]) unless @attrs[:channel].nil?
    end

  end
end