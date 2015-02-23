module ACTV
  class AssetPrice < Base

    attr_reader :priceAmt, :maxPriceAmt, :minPriceAmt

    def effectiveUntilDate
      @attrs[:effectiveUntilDate] || '2200-01-01T00:00:00'
    end

    alias effective_date effectiveUntilDate
    alias amount priceAmt
    alias max_amount maxPriceAmt
    alias min_amount minPriceAmt
  end
end
