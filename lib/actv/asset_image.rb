module ACTV
  class AssetImage < Base
    attr_reader :imageUrlAdr, :imageName, :imageType, :imageCaptionTxt, :linkUrl, :linkTarget

    alias url     imageUrlAdr
    alias name    imageName
    alias type    imageType
    alias caption imageCaptionTxt
    alias link    linkUrl
    alias target  linkTarget

    def video?
      target == "VIDEO" || type == "VIDEO"
    end

    def to_str
      imageUrlAdr
    end

    def to_s
      imageUrlAdr
    end
  end
end
