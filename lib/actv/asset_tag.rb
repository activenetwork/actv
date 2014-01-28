require 'actv/tag'

module ACTV
  class AssetTag < Base
    def tag
      @tag ||= ACTV::Tag.new(@attrs[:tag]) unless @attrs[:tag].nil?
    end
  end
end