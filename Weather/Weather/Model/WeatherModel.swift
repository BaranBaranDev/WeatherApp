
import Foundation


// modelimin amacı çözümlenen verinin bilgilerini bu structan oluşturulan kopya bir nesne modelimiz aracılığıyla barındırıp ekran da gösterimini kolaylaştırmak

struct WeatherModel {
    
    let conditionId : Int
    let cityName : String
    let temperature : Double
    
    
    // computer property
    var conditionName : String {
            switch conditionId {
                    case 200...232:
                        return "cloud.bolt"
                    case 300...321:
                        return "cloud.drizzle"
                    case 500...531:
                        return "cloud.rain"
                    case 600...622:
                        return "cloud.snow"
                    case 701...781:
                        return "cloud.fog"
                    case 800:
                        return "sun.max"
                    case 801...804:
                        return "cloud.bolt"
                    default:
                        return "cloud"
                    }
    }
    
    
    // sıcaklık dönüşümü
    var getTemperature : String {
        return String(format: "%.1f", (temperature - 273))
    }
    
}
