require 'actv/identity'

module ACTV
  class AssetStatus < ACTV::Identity

    attr_reader :assetStatusId, :assetStatusName, :isSearchable, :isDeleted,
      :createdDate, :modifiedDate

    alias id assetStatusId
    alias name assetStatusName
    alias is_searchable? isSearchable
    alias is_deleted? isDeleted
    alias created_at createdDate
    alias updated_at modifiedDate

    def visible?
      id == '2'
    end
  end
end