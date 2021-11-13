// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
//reference: https://app.quicktype.io

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let meta: Meta
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let area: Area
    let summary, diseaseRiskLevel: String
    let diseaseInfection: DiseaseInfection
    let diseaseCases: DiseaseCases
    let hotspots: String?
    let dataSources: DataSources
    let areaRestrictions: [AreaRestriction]
    let areaAccessRestriction: AreaAccessRestriction
    let areaPolicy: AreaPolicy
    let relatedArea: [RelatedArea]
    let areaVaccinated: [AreaVaccinated]
    let type: String
}

// MARK: - Area
struct Area: Codable {
    let name, iataCode, areaType: String
}

// MARK: - AreaAccessRestriction
struct AreaAccessRestriction: Codable {
    let transportation: Transportation
    let declarationDocuments: DeclarationDocuments
    let entry: Entry
    let diseaseTesting: DiseaseTesting
    let tracingApplication: Mask
    let quarantineModality: QuarantineModality
    let mask: Mask
    let exit: Exit
    let otherRestriction: OtherRestriction
    let diseaseVaccination: DiseaseVaccination
}

// MARK: - DeclarationDocuments
struct DeclarationDocuments: Codable {
    let date, text, documentRequired: String
}

// MARK: - DiseaseTesting
struct DiseaseTesting: Codable {
    let date, text, isRequired, when: String
    let requirement: String
    let rules: String
    let testType: String
    let minimumAge: Int
    let validityPeriod: ValidityPeriod
}

// MARK: - ValidityPeriod
struct ValidityPeriod: Codable {
    let delay, referenceDateType: String
}

// MARK: - DiseaseVaccination
struct DiseaseVaccination: Codable {
    let date, isRequired: String
    let referenceLink: String
    let acceptedCertificates, qualifiedVaccines: [String]
    let policy: String
}

// MARK: - Entry
struct Entry: Codable {
    let date, text, ban, throughDate: String
    let rules, exemptions: String
    let bannedArea: [BannedArea]
    let borderBan: [BorderBan]
}

// MARK: - BannedArea
struct BannedArea: Codable {
    let iataCode: String
    let areaType: AreaType
}

enum AreaType: String, Codable {
    case country = "country"
}

// MARK: - BorderBan
struct BorderBan: Codable {
    let borderType, status: String
}

// MARK: - Exit
struct Exit: Codable {
    let date, text, specialRequirements: String
    let rulesLink: String
    let isBanned: String
}

// MARK: - Mask
struct Mask: Codable {
    let date, text, isRequired: String
}

// MARK: - OtherRestriction
struct OtherRestriction: Codable {
}

// MARK: - QuarantineModality
struct QuarantineModality: Codable {
    let date, text, eligiblePerson: String
    let rules: String
}

// MARK: - Transportation
struct Transportation: Codable {
    let date, text, transportationType, isBanned: String
    let throughDate: String
}

// MARK: - AreaPolicy
struct AreaPolicy: Codable {
    let date, text, status, startDate: String
    let endDate: String
    let referenceLink: String
}

// MARK: - AreaRestriction
struct AreaRestriction: Codable {
    let date, text, restrictionType: String
}

// MARK: - AreaVaccinated
struct AreaVaccinated: Codable {
    let date, vaccinationDoseStatus: String
    let percentage: Double
}

// MARK: - DataSources
struct DataSources: Codable {
    let governmentSiteLink: String
}

// MARK: - DiseaseCases
struct DiseaseCases: Codable {
    let date: String
    let deaths, confirmed: Int
}

// MARK: - DiseaseInfection
struct DiseaseInfection: Codable {
    let date, level: String
    let rate: Double
    let infectionMapLink: String
}

// MARK: - RelatedArea
struct RelatedArea: Codable {
    let methods: [String]
    let rel: String
}

// MARK: - Meta
struct Meta: Codable {
    let links: Links
}

// MARK: - Links
struct Links: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}
