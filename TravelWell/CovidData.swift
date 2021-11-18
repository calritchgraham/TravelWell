// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
//reference: https://app.quicktype.io

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let area: Area
    let diseaseRiskLevel: String?
    let hotspots: String?
    let dataSources: DataSources
    let areaAccessRestriction: AreaAccessRestriction
    let areaVaccinated: [AreaVaccinated]
}

// MARK: - Area
struct Area: Codable {
    let name : String?
}

// MARK: - AreaAccessRestriction
struct AreaAccessRestriction: Codable {
    let declarationDocuments: DeclarationDocuments
    let diseaseTesting: DiseaseTesting
    let tracingApplication: Mask
    let quarantineModality: QuarantineModality
    let mask: Mask
    let diseaseVaccination: DiseaseVaccination
}

// MARK: - DeclarationDocuments
struct DeclarationDocuments: Codable {
    let text : String?
}

// MARK: - DiseaseTesting
struct DiseaseTesting: Codable {
    let text : String?
}


// MARK: - DiseaseVaccination
struct DiseaseVaccination: Codable {
    let isRequired: String?
}

// MARK: - Mask
struct Mask: Codable {
    let isRequired : String?
}

// MARK: - QuarantineModality
struct QuarantineModality: Codable {
    let text : String?
}

// MARK: - AreaVaccinated
struct AreaVaccinated: Codable {
    let percentage: Double?
}

// MARK: - DataSources
struct DataSources: Codable {
    let governmentSiteLink: String?
}
