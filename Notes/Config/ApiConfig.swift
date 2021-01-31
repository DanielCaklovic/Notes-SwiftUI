//
//  ApiConfig.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Foundation

final class ApiConfig {
    static var selectedEnvironment = Environment.development
    
    static var domainUrl: String {
        switch selectedEnvironment {
        case .development:
            return ""
        case .testing:
            return ""
        case .staging:
            return ""
        case .production:
            return ""
        }
    }
    
    static var baseUrl: String {
        return "https://community-open-weather-map.p.rapidapi.com/weather"
    }
    
    static var isProduction: Bool {
        return selectedEnvironment == .production
    }
    
    static func configure() {
        if let stringEnv = Bundle.main.object(forInfoDictionaryKey: "Environment") as? String,
            let environment = Environment(rawValue: stringEnv) {
            ApiConfig.selectedEnvironment = environment
        }
    }
    
    static func configureFirebase(enviroment: Environment) {
        var firebasePlistFileName = ""
        switch enviroment {
        case .testing, .development, .staging:
            firebasePlistFileName = "GoogleService-Info-nonproduction"
        case .production:
            firebasePlistFileName = "GoogleService-Info"
        }
        guard let path = Bundle.main.path(forResource: firebasePlistFileName, ofType: "plist")
            else { return }
    }
    
    static func disableAnalytics() {
//        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
    }
    
    static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
}
