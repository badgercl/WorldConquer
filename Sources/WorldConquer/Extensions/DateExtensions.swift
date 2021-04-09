import Foundation

extension Date {
    var formatedDateForFile: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd_HH_mm_ss"
        return formatter.string(from: self)
    }
}
