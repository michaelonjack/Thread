//
//  WeatherType.swift
//  Thread
//
//  Created by Michael Onjack on 4/14/19.
//  Copyright © 2019 Michael Onjack. All rights reserved.
//

import Foundation

enum WeatherType {
    case clear(description: String)
    case clouds(description: String)
    case drizzle(description: String)
    case rain(description: String)
    case snow(description: String)
    case thunder(description: String)
    case wind(description: String)
    
    init(name: String, description: String) {
        switch name {
        case WeatherType.clear(description: "").name:
            self = .clear(description: description)
        case WeatherType.clouds(description: "").name:
            self = .clouds(description: description)
        case WeatherType.drizzle(description: "").name:
            self = .drizzle(description: description)
        case WeatherType.rain(description: "").name:
            self = .rain(description: description)
        case WeatherType.snow(description: "").name:
            self = .snow(description: description)
        case WeatherType.thunder(description: "").name:
            self = .thunder(description: description)
        case WeatherType.wind(description: "").name:
            self = .wind(description: description)
        default:
            self = .clear(description: "")
        }
    }
    
    // Initializer using OpenWeatherMap's ID codes
    init(openWeatherMapId: Int, description: String) {
        switch openWeatherMapId {
        case 200...299:
            self = .thunder(description: description)
        case 300...399:
            self = .drizzle(description: description)
        case 500...599:
            self = .rain(description: description)
        case 600...699:
            self = .snow(description: description)
        case 802...899:
            self = .clouds(description: description)
        default:
            self = .clear(description: description)
        }
    }
    
    var name: String {
        switch self {
        case .clear:
            return "Sunny"
        case .clouds:
            return "Cloudy"
        case .drizzle:
            return "Drizzling"
        case .rain:
            return "Rainy"
        case .snow:
            return "Snowing"
        case .thunder:
            return "Thunderstorms"
        case .wind:
            return "Windy"
        }
    }
    
    var description: String {
        switch self {
        case .clear(let description):
            return description
        case .clouds(let description):
            return description
        case .drizzle(let description):
            return description
        case .rain(let description):
            return description
        case .snow(let description):
            return description
        case .thunder(let description):
            return description
        case .wind(let description):
            return description
        }
    }
    
    var image: UIImage? {
        switch self {
        case .clear:
            return UIImage(named: "Sun")
        case .clouds:
            return UIImage(named: "Clouds")
        case .drizzle:
            return UIImage(named: "Drizzle")
        case .rain:
            return UIImage(named: "Rain")
        case .snow:
            return UIImage(named: "Snow")
        case .thunder:
            return UIImage(named: "Thunder")
        case .wind:
            return UIImage(named: "Wind")
        }
    }
}
