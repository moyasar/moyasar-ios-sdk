import Foundation

final class ArabicNumberMapper {
    static var numbersMap = [
        "٠": "0",
        "١": "1",
        "٢": "2",
        "٣": "3",
        "٤": "4",
        "٥": "5",
        "٦": "6",
        "٧": "7",
        "٨": "8",
        "٩": "9"
    ]

    static func mapArabicNumbers(_ number: String) -> String {
        number.map {
            if let res = numbersMap[String($0)] {
                return res
            } else {
                return String($0)
            }
        }.joined()
    }
}
