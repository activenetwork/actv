require 'actv/identity'

module ACTV
  class Organizer < ACTV::Identity

    attr_reader :organizationDsc, :organizationGuid, :addressCityName, :fax, :sourceSystemGuid, :addressPostalCd,
       :organizationName, :addressStateProvinceCode, :addressCountryCd, :primaryContactPhone, :addressLine1Txt,
       :primaryContactEmailAdr, :hideOrganizationContact, :addressLocalityName, :showOrganizationName, :primaryContactName, :addressLine2Txt

    alias id organizationGuid
    alias name organizationName
    alias description organizationDsc
    alias address_line1 addressLine1Txt
    alias address_line2 addressLine2Txt
    alias city addressCityName
    alias locality addressLocalityName
    alias state addressStateProvinceCode
    alias country addressCountryCd
    alias postal_code addressPostalCd
    alias primary_contact primaryContactName
    alias email primaryContactEmailAdr
    alias phone primaryContactPhone

  end
end
