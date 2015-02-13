require 'spec_helper'

describe ACTV::AssetPrice do

  describe 'attribute accessors and aliases' do
    context 'when set the validate value for the asset_price' do
      before do
        @price = ACTV::AssetPrice.new(effectiveUntilDate: '2012-08-03T06:59:00', priceAmt: '10', maxPriceAmt: '15', minPriceAmt: '5')
      end
      subject { @price }

      its(:effective_date){ should eq '2012-08-03T06:59:00' }
      its(:amount){ should eq '10' }
      its(:max_amount){ should eq '15' }
      its(:min_amount){ should eq '5' }

      its(:effectiveUntilDate){ should eq '2012-08-03T06:59:00' }
      its(:priceAmt){ should eq '10' }
      its(:maxPriceAmt){ should eq '15' }
      its(:minPriceAmt){ should eq '5' }
    end
  end

  context "when haven't effectiveUntilDate set " do
    price = ACTV::AssetPrice.new(priceAmt: '10', maxPriceAmt: '15', minPriceAmt: '5')
    it 'should return the default "2200-01-01T00:00:00" value for the "effectiveUntilDate"' do
      expect(price.effectiveUntilDate).should eq '2200-01-01T00:00:00'
    end
  end

end
