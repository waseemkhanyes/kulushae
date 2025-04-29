//
//  AppConfig.swift
//  Kulushae
//
//  Created by ios on 10/10/2023.
//

import Foundation

enum Envirement:Int {
    case production = 1
    case dev
}

struct Config {
    
    // MARK: App Type
    /// `AppType defines the current sellected type of the build`
    /// `depending upon selected AppType, different things like baseURL, socket URL`
    /// `and even UI of the App is being configured.`
   
    
//    public static let apollo_url = "https://dev.kulshae.com/api"
//    static var envirement:Envirement = .dev
    static var envirement:Envirement = .production
    
    static var apollo_url: String {
        switch envirement {
        case .production:
            return "https://kulshae.com/api"
        case .dev:
            return "https://dev.kulshae.com/api"
        }
    }
    
//    public static let apollo_url = "https://kulushae.cashgatetech.com/api"
    
    public static let emptyData = "$2y$10$12BIRRCiJ5urh.3E32lF0e6XS3c.xrESk1iADTEyYv7MMXgeWjeNi"
    public static let mapboxAPIkey = "pk.eyJ1IjoiY2FzaGdhdGUiLCJhIjoiY2x4dXF1MXhxMDA3NjJyc2FseGF6NGF1MSJ9.9xTPqqB1v725uBUnu9DaQg"
    public static let amazonAccessKey = "AKIATEJSEPBM6C7IXFSZ"
    public static let amazonSecretKey = "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"
    public static let region = "me-central-1"
    public static let bucket = "kulushae"
    
    // MARK: Paytab Details
    
    public static let payTabServerKey = "S9J9NNRHHH-JJB62LGRMN-KZ9KDN9LDT"
    public static let payTabClientKey = "CBK2MD-K6PP66-2GMBTR-TDT6G2"
    public static let payTabProfileID = "142173"
    
    // MARK: PUSHER Details
    
    static var pusherKey: String {
        switch envirement {
        case .production:
            return "61a029a7594104fc454a"
        case .dev:
            return "3a88a0b32be63103b648"
        }
    }
    
//    public static let pusherKey = "61a029a7594104fc454a"
//    public static let pusherCluster = "ap2"
    static var pusherCluster: String {
        switch envirement {
        case .production:
            return "ap2"
        case .dev:
            return "ap1"
        }
    }
    
    //    public static let imageBaseUrl = "https://kulushae-prod.fra1.digitaloceanspaces.com" // Live URL
    static var imageBaseUrl: String {
        switch envirement {
        case .production:
            return "https://kulshae.s3.me-central-1.amazonaws.com"
        case .dev:
            return "https://kulushae.nyc3.cdn.digitaloceanspaces.com"
        }
    }
    
    static var baseURL: String {
        switch envirement {
        case .production:
            return "https://kulshae.com/restapis/"
        case .dev:
            return "https://dev.kulshae.com/restapis/"
        }
    }
    
//        public static let imageBaseUrl = "https://kulushae.nyc3.cdn.digitaloceanspaces.com" //  Dev URL
    
    
    
    public static let pusherAuthURL = "pusher/auth"
    public static let pusherSentMessage = "pusher/send-message"

//    public static let baseURL = "https://kulushae.cashgatetech.com/restapis/"
    public static let imageUploadUrl = "upload"
    public static let imageDelateUrl = "remove"
    public static let verifyToken = "verify-token"
    public static let refreshToken = "refresh-token"
    public static let refreshFCMToken = "update_fcm_token"
    public static let countryList = "countries"
    public static let quickLinks = "quicklinks"
    public static let filters = "filters"
    public static let statesList = "states-by-country?country_id="
    public static let paymentAfterURL = "handle-postpayment"
    public static let bannersList = "getBanners"
    public static let removeItemImage = "remove-item-image"
    // MARK: Zendesk
    
    public static let zenDeskAppID = "db4b7481f82e133c15d83fa43bb66206995e70ef28396c60"
    public static let zenDeskClientId = "mobile_sdk_client_0f55a68544dedfd008fe"
    public static let zendeskUrl = "https://cashgateinformationtechnologyllchelp.zendesk.com"
    public static let zendeskChatKey = "eyJzZXR0aW5nc191cmwiOiJodHRwczovL2Nhc2hnYXRlaW5mb3JtYXRpb250ZWNobm9sb2d5bGxjaGVscC56ZW5kZXNrLmNvbS9tb2JpbGVfc2RrX2FwaS9zZXR0aW5ncy8wMUpBREFYTkJIWEhYTjZZOFNHU0o2RFdaNS5qc29uIn0="
    
    
    // MARK: Kulushae Links
    public static let termsAndConditionUrl = "https://kulshae.com/terms.html"
    public static let privacyURL = "https://kulshae.com/privacy.html"
    public static let appStoreLink = "https://apps.apple.com/ae/app/kulshae/id6478753424"
}



