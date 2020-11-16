//
//  WeatherManager.swift
//  Clima
//
//  Created by Michael Varian Sutanto on 15/06/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate { // Kita membuat protocol / sertifikasi tentang apa yang bisa dilakukan jika class memiliki WeatherManagerDelegate.
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    //weatherURL adalah URL tempat kita mengakses API dari OpenWeatherMap yang terdiri atas access key dan setting celcius
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=72e0b7f3d52274566423b8b59bc6a3d7&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    //Disini kita membuat method untuk memastikan nama kota yang kita input di TextField dapat dipassing ke OpenWeather.
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        //print(urlString) // Mencetak url ke console untuk memastikan bahwa urlString yang kita buat sesuai dengan permintaan OpenWether.
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitute: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    //Kita membuat method bernama performRequest yang dipanggil pada method fetchWether. Tujuan performRequest adalah melakukan networking antar apps buatan kita dengan API OpenWeather.
    func performRequest(with urlString: String) {
        
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default) // URLSession berfungsi seperti browser yang menjalankan networking.
            
            //3. Give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data { //data adalah hasil tarikan dari API yang dalam hal ini berbentuk JSON.
                    if let weather = self.parseJSON(safeData) { //Kita memanggil method parseJSON dengan self karena ini berada dalam closure.
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? { //parseJSON perlu memberitahukan bentuk struktur model datanya yang kita buat dalam bentuk struct pada file terpisah bernama WeatherModel.
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp) //Kita membuat wadah bernama weather yang berasal dari model data weather yang dibuat pada file WeatherModel sebelumnya.
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
