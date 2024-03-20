import Foundation
import CoreLocation



// MARK: - WeatherManagerDelegate
protocol WeatherManagerDelegate: AnyObject {
    // kod kullanılabirliği için VC de fonks olarak belirteceğim yapımı onun yerone protocol içinde kullandım. Böylece daha temiz ve kullanışlı kodun önünü açıyoruz
    func didUptadeWeather(model : WeatherModel)
    
    // hata olursa
    func didFailError (_ error : Error)
}


// MARK: - WeatherManager
struct WeatherManager {
    
    // delegem
    weak var delegate : WeatherManagerDelegate?
    
    
    // veriyi almak için
    func fetchData(forCity city : String){
        // Veriyi çekeceğimiz URL
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=27e031923e3ba890b5d39823a88599cd"
        performReguest(with : urlString) //url alıp istek atacak datayı çözümleyecek
    }
    
    
    // konumla veri çekmek için
    func fetchDataLocalization(latitude : CLLocationDegrees,longitude : CLLocationDegrees){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=27e031923e3ba890b5d39823a88599cd"
            
        performReguest(with: urlString)
    }
    
    
    // verileri çekmek için istek atacağız, kullanılabilir olması için isteği farklı fonks içinde kullanmayı tercih ettim
    func performReguest(with urlString : String){
        
        // - url oluştur (verinin adresi)
        if let url = URL(string: urlString){
            
            // sessions nesnesi oluştur (istek  yönetimi)
            let sessions = URLSession(configuration: .default)
            
            // Veri çekme işlemi için bir data task oluştur
            let dataTask = sessions.dataTask(with: url) { data, _, error in
                
                // hata olursa (hata mesajı ver ve  döngüden çık)
                if let error = error {
                    print("Veri çekme hatası : \(error.localizedDescription)")
                    return
                }
                
                // veri varsa
                if let data = data {
                    // veriyi çözmek için fonksiyon kuruyorum bu sayede daha kullanılabilinir kodlar yazmış oluruz
                    if let weather = parseJson(weatherData: data){ // parseJson ? opsiyon olduğundan eğer olumlu dönerse weather değişkenine verinin tutulduğu modeli aktar
                        
                        // kullanılabilir olması için protocolleri kullanıp burada ki veriyi VC de delegate edip veriyi ekranda yazdırmak için kullanacağım
                        self.delegate?.didUptadeWeather(model: weather)
                    }
                }
            }
            // Data task'ı başlat
            dataTask.resume()
        }
    }
    
    // Data türünden gelen json verisini çözümleyeceğiz
    func parseJson(weatherData : Data) -> WeatherModel?{
        do{
            let parseData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            let id = parseData.weather[0].id
            let name = parseData.cityName
            let temp = parseData.main.temp
            
    // oluşturulan modelimiz (WeatherModel) atama yapıp dönüş değerimizi model olarak belirleriz bu sayede ekranda görmemizi kolaylaştırırız
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
        }catch{
            print("Json çözümlenirken hata oluştu : \(error.localizedDescription)")
            return nil
        }
        
    }
}
