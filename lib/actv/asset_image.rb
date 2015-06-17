module ACTV
  class AssetImage < Base
    attr_reader :imageUrlAdr, :imageName, :imageCaptionTxt, :linkUrl, :linkTarget

    alias name    imageName
    alias caption imageCaptionTxt
    alias link    linkUrl
    alias target  linkTarget

    def url
      imageUrlAdr.to_s
    end
  end
end
