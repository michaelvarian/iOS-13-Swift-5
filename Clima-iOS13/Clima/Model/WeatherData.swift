//
//  WeatherData.swift
//  Clima
//
//  Created by Michael Varian Sutanto on 16/06/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable { //Struct WeatherData haruslah sesuai dengan bentuk JSON pada API.
    let name: String
    let main: Main //DataType Main kita buat karena main memiliki turunan seperti temp pada API.
    let weather: [Weather] //Karena weather pada API berbentuk array, maka kita pun perlu membuatnya dalam array ketika kita menyusul bentuk model data kita.
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}
