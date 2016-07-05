require 'spec_helper'

describe ACTV::Video do
	let(:descriptions) { [ { description: "article source", descriptionType: { descriptionTypeId: "1", descriptionTypeName: "articleSource" } },
	                 { description: "article subtitle", descriptionType: { descriptionTypeId: "2", descriptionTypeName: "subtitle" } },
	                 { description: "by Yason", descriptionType: { descriptionTypeId: "3", descriptionTypeName: "articleByLine" } },
	                 { description: "article footer", descriptionType: { descriptionTypeId: "4", descriptionTypeName: "footer" } } ] }
	let(:asset_images) { [] }
	let(:asset_categories) { [] }
	let(:asset_tags) { [] }
	let(:asset_references) { [] }
	let(:response) { { assetGuid: 1,
	                 assetDescriptions: descriptions,
	                 assetTags: asset_tags,
	                 assetImages: asset_images,
	                 assetCategories: asset_categories,
	                 assetReferences: asset_references } }
	subject(:article) { ACTV::Article.new response }


end