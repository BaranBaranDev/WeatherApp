
import Foundation

// çözümlenecek api datası
struct WeatherData: Codable {
    let cityName : String
    let main : Main
    let weather : [Weather]
    
    // CodingKeys enum'u ile JSON anahtarları ile eşleştirmeyi özelleştir
        enum CodingKeys: String, CodingKey {
            case cityName = "name"
            case main
            case weather
        }
}


struct Main: Codable {
    let temp : Double
}


struct Weather: Codable {
    let description : String
    let  id : Int
}
