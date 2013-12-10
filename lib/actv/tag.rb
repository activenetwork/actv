module ACTV
  class Tag < ACTV::Identity
    attr_reader :tagId, :tagName, :tagDescription

    alias id tagId
    alias name tagName
    alias description tagDescription
  end
end