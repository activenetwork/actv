module ACTV
  class AssetImage < Base
    attr_reader :imageUrlAdr, :imageName, :imageCaptionTxt, :linkUrl, :linkTarget

    alias url     imageUrlAdr
    alias name    imageName
    alias caption imageCaptionTxt
    alias link    linkUrl
    alias target  linkTarget
  end
end
