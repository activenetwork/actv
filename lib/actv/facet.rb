require 'actv/base'
require 'actv/facet_term'

module ACTV
  class Facet < ACTV::Base
    attr_reader :name

    def terms
      @terms ||= Array(@attrs[:terms]).map do |term|
        ACTV::FacetTerm.new(term)
      end
    end

  end

end