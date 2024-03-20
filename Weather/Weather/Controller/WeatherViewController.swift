
import UIKit
import CoreLocation



class WeatherViewController: UIViewController {
    
    // MARK: - View (IBOutlet)
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    // MARK: - Weather Manager - locationManager
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // delege belirleme
        locationManager.delegate = self
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        // localization
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    // MARK: - View (IBAction)
    
    // Localization
    @IBAction func locationPress(_ sender: UIButton) {
        locationManager.requestLocation() //  konumu alır
        
    }
    
    // Search text
    @IBAction func searchButton(_ sender: UIButton) {
        // klavyenin kapamasına ek delegate methodlarını buton içinde aktif edelim
        searchTextField.endEditing(true)
    }
    
}


// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    // konum
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // locations.last, bu dizideki en son (sonuncu) konumu temsil eden bir CLLocation nesnesini döndürür.
            print("Latitude: \(location.coordinate.latitude)")
            print("Longitude: \(location.coordinate.longitude)")
            weatherManager.fetchDataLocalization(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    
    // hata yakalama
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Konum alma sırasında hata oluştu : \(error.localizedDescription)")
    }
    
    
}


// MARK: - textFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // klavyede ki return tuşumuz
        searchTextField.endEditing(true) // klavyeyi kapatır
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // klavye kapanmadan önce gerekli kontrolleri düzenleyelim
        if searchTextField.text != "" { // textfieldimiz boş değilse
            return true
        }else { // boşsa
            searchTextField.placeholder = "Bir şehir ismi giriniz !"
            return false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // klavye kapandıktan sonra
        if let enteredCity = searchTextField.text {
            print(weatherManager.fetchData(forCity: enteredCity))
            // verini aranacağı kısı
        }
    }
    
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Metin alanındaki metni temizleme izni
        return true
    }
    
}


// MARK: - WeatherManagerDelegate : çekilen verimizin saklandığı modeli aktarımında görevli oluşturduğum protokol
extension WeatherViewController: WeatherManagerDelegate {
    func didUptadeWeather(model: WeatherModel) {
        
        DispatchQueue.main.async { [self] in
            cityLabel.text = model.cityName
            temperatureLabel.text = model.getTemperature
            iconLabel.image = UIImage(systemName: model.conditionName)
        }
        
    }
    
    func didFailError(_ error: Error) {
        print("Hata : \(error.localizedDescription)")
    }
    
    
}
