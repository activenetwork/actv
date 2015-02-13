require 'spec_helper'

describe ACTV::AssetPrice do

  before(:each) do
    @price = ACTV::AssetPrice.new(effectiveDate: '2012-08-03T06:59:00', priceAmt: '10', maxPriceAmt: '15', minPriceAmt: '5')
  end

  describe 'attribute accessors and aliases' do
    subject { @price }

    its(:effectiveUntilDate){ should eq '2012-08-03T06:59:00' }
    its(:effective_date){ should eq '2012-08-03T06:59:00' }
    its(:amount){ should eq '10' }
    its(:max_amount){ should eq '15' }
    its(:min_amount){ should eq '5' }

    its(:effectiveDate){ should eq '2012-08-03T06:59:00' }
    its(:priceAmt){ should eq '10' }
    its(:maxPriceAmt){ should eq '15' }
    its(:minPriceAmt){ should eq '5' }
  end

end
