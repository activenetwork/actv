require 'spec_helper'

describe ACTV::Video do
	let(:asset_images) { [ { :imageUrlAdr => "http://RODALE.images.worldnow.com/images/12508455_vtf.jpg", :imageName => "videoImage" } ] }
	let(:urlAdr) { "http://rodale.videodownload.worldnow.com/RODALE_0906201614333627818AA.mp4" }
	let(:asset_tags) { [ { :tag => { :tagId => "1794337", :tagName => "video/mp4", :tagDescription => "type" } },
											 { :tag => { :tagId => "1794525", :tagName => "640", :tagDescription => "width" } },
											 { :tag => { :tagId => "1794598", :tagName => "997", :tagDescription => "bitrate" } },
											 { :tag => { :tagId => "1794597", :tagName => "training,fitness,health & injuries", :tagDescription => "keywords" } },
											 { :tag => { :tagId => "1794599", :tagName => "140", :tagDescription => "duration" } },
											 { :tag => { :tagId => "1794526", :tagName => "360", :tagDescription => "height" } },
											 { :tag => { :tagId => "1794600", :tagName => "18370674", :tagDescription => "filesize" } },
											 { :tag => { :tagId => "1795103", :tagName => "http://rodale.worldnow.com/clip/12508455/these-foam-rolling-moves-can-help-you-recover-faster", :tagDescription => "canonicalUrl" } } ] }
	let(:asset_categories) { [ { :sequence => "1", :category => { :categoryId => "8", :categoryTaxonomy => "Creative Work/Videos", :categoryName => "Videos" } } ] }

	let(:response) { { assetGuid: 1,
										 urlAdr: urlAdr,
										 assetTags: asset_tags,
										 assetImages: asset_images,
										 assetCategories: asset_categories } }
	subject(:video) { ACTV::Video.new response }

	describe '#self.valid?' do
		subject(:valid?) { ACTV::Video.valid? response }
		context 'when the category name is videos' do
			let(:asset_categories) { [ { category: { categoryName: "Videos", categoryTaxonomy: "" } } ] }
			it { should be_true }
		end

		context 'when the category taxonomy is videos' do
			let(:asset_categories) { [ { category: { categoryName: "", categoryTaxonomy: "Creative Work/Videos" } } ] }
			it { should be_true }
		end

		context 'when there is no category name or category taxonomy' do
		let(:asset_categories) { [ { category: { categoryName: "", categoryTaxonomy: "" } } ] }
			it { should be_false }
		end
	end

	describe '#source' do
		context 'when a video source is exists' do
			its(:source) { should eq urlAdr }
		end
	end

	describe '#keywords' do
		context 'when a video tag with tagDescription equal keywords exists' do
			its(:keywords) { should eq "training,fitness,health & injuries" }
		end
	end

	describe '#type' do
		context 'when a video tag with tagDescription equal type exists' do
			its(:type) { should eq "video/mp4" }
		end
	end

	describe '#width' do
		context 'when a video tag with tagDescription equal width exists' do
			its(:width) { should eq "640" }
		end
	end

	describe '#height' do
		context 'when a video tag with tagDescription equal height exists' do
			its(:height) { should eq "360" }
		end
	end

	describe '#bitrate' do
		context 'when a video tag with tagDescription equal bitrate exists' do
			its(:bitrate) { should eq "997" }
		end
	end

	describe '#duration' do
		context 'when a video tag with tagDescription equal duration exists' do
			its(:duration) { should eq "140" }
		end
	end

	describe '#filesize' do
		context 'when a video tag with tagDescription equal filesize exists' do
			its(:filesize) { should eq "18370674" }
		end
	end

	describe '#canonical_url' do
		context 'when a video tag with tagDescription equal canonical_url exists' do
			its(:canonical_url) { should eq "http://rodale.worldnow.com/clip/12508455/these-foam-rolling-moves-can-help-you-recover-faster" }
		end
	end

	describe '#cover' do
		context 'when a video image exists' do
			its(:cover) { should eq "http://RODALE.images.worldnow.com/images/12508455_vtf.jpg" }
		end
	end
end