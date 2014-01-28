require 'actv/topic'

module ACTV
  class AssetTopic < Base
    attr_reader :sequence

    def topic
      @topic ||= ACTV::Topic.new(@attrs[:topic]) unless @attrs[:topic].nil?
    end
  end
end