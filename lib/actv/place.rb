require 'actv/identity'

module ACTV
  class Place < Base

    attr_reader :placeGuid, :placeName, :placeDsc, :placeUrlAdr, :addressLine1Txt, :addressLine2Txt, :cityName,
        :stateProvinceCode, :localityName, :postalCode, :countryName, :countryCode, :latitude, :longitude,
        :directionsTxt

    alias id placeGuid
    alias name placeName
    alias description placeDsc
    alias url placeUrlAdr
    alias address1 addressLine1Txt
    alias address2 addressLine2Txt
    alias city cityName
    alias state stateProvinceCode
    alias locality localityName
    alias postal_code postalCode
    alias country countryName
    alias country_code countryCode

    def has_lat_long?
      latitude && longitude && latitude != "" && longitude != ""
    end

  end
end