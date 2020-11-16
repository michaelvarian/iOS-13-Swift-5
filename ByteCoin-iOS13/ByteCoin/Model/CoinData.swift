//
//  CoinData.swift
//  ByteCoin
//
//  Created by Demon Hunter on 16/11/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

//Make the struct to conform to the decodable protocol to use it to decode our JSON
//Note: You can also use the Codable type alias to conform ro both decodable and encodable protocol in case you want to turn a Swift object back into a JSON

struct CoinData: Decodable {
    //There's only 1 property we're interested in the JSON data, that's the last price of bitcoin
    //Because it's a decimal number, we'll give it a Double data type.
    
    let rate: Double
}
