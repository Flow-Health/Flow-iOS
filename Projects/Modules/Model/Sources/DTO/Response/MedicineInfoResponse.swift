public struct MedicineInfoResponse: Decodable {
    public let imageURL: String
    public let medicineName: String
    public let companyName: String
    public let itemCode: String
    public let efficacy: String
    public let howToUse: String
    public let cautionWarning: String
    public let caution: String
    public let interaction: String
    public let sideEffect: String
    public let storageMethod: String
    public let updateDate: String
}
