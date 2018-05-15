module ACTV
  module AssetSourceSystem
    SOURCE_SYSTEM_HASH = {
        regcenter: "EA4E860A-9DCD-4DAA-A7CA-4A77AD194F65",
        regcenter2: "3BF82BBE-CF88-4E8C-A56F-78F5CE87E4C6",
        awendurance: "DFAA997A-D591-44CA-9FB7-BF4A4C8984F1",
        awsports: "F036B0FF-2B21-43A9-8C20-7F447D3AB105",
        awcamps: "2B22B4E6-5AA4-44D7-BF06-F7A71F9FA8A6",
        awcamps30: "89208DBA-F535-4950-880A-34A6888A184C",
        thriva: "2BA50ABA-080E-4E3D-A01C-1B4F56648A2E",
        activenet: "FB27C928-54DB-4ECD-B42F-482FC3C8681F",
        researched: "B47B0828-23ED-4D85-BDF0-B22819F53332",
        acm: "CA4EA0B1-7377-470D-B20D-BF6BEA23F040",
        leagueone: "74742258-90FE-40ED-8A60-89F21DE93BFD",
        tennislinkteam: "0206DC72-C167-4B39-B299-0F2A27D8CBEF",
        tennislinktournament: "71D917DE-FA90-448A-90DA-C8852F7E03E2",
        tennislinkusta: "3858B6E3-B52E-4E20-9A00-2AD8500B1BC3",
        p4p: "909A9320-7907-4A87-9727-1816BAE3D84F"
    }

    SOURCE_SYSTEM_HASH.each_pair do |name, source_system_id|
      define_method "#{name}?" do
        sourceSystem[:legacyGuid].upcase == source_system_id rescue false
      end
    end

    def kids_friendly_source_system?
      p4p? || activenet? || awcamps30? || acm? || researched? || leagueone? || tennislinkteam? || tennislinktournament? || tennislinkusta? || awendurance?
    end
  end
end