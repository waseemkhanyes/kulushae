//
//  PersistanceManager.swift
//  Kulushae
//
//  Created by ios on 11/10/2023.
//

import SwiftUI
import FirebaseMessaging

public enum CachePolicy {
    /// Return data from the cache if available, else fetch results from the server.
    case returnCacheDataElseFetch
    ///  Always fetch results from the server.
    case fetchIgnoringCacheData
    /// Return data from the cache if available, else return nil.
    case returnCacheDataDontFetch
}

struct Keys {
    enum Persistance: String {
        case loggedInUser
        case deviceId
        case fcmToken
        case userStates
        case language
        case authKey
        case refreshToken
        case isUserInfoFilled
    }
}

final class PersistenceManager {
    private init() {}
    
    static let shared = PersistenceManager()
    private var _userStates: UserStateManager?
    private let defaults = UserDefaults.standard
    private var _loggedUser: RegisterData?
    
    @ObservedObject static var localUserState: UserStateManager =
    UserStateManager(currentAuthState: shared.userStates?.currentAuthState ?? .loggedOut,
                     currentOnboardingState: shared.userStates?.currentOnboardingState ?? .loggedOut)
    
    
    var languageType: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.Persistance.language.rawValue) ?? "EN"
        }
        
        set(newVal) {
            UserDefaults.standard.set(newVal, forKey: Keys.Persistance.language.rawValue)
        }
    }
    
    
    var loggedUser: RegisterData? {
        get {
            if _loggedUser == nil {
                if let user = getLoggedUser() {
                    _loggedUser = user
                    return _loggedUser
                }
            }
            return _loggedUser
            
        }
        
        set(newLoggedUser) {
            guard let user = newLoggedUser else { return }
            saveLoggedUser(beerUser: user)
            _loggedUser = newLoggedUser
        }
    }
    
    var userStates: UserStateManager? {
        get {
            if _userStates == nil {
                if let userState = getUserStates() {
                    _userStates = userState
                    return _userStates
                    
                }
            }
            
            return _userStates
            
        }
        
        set(newUserState) {
            guard let state = newUserState else { return }
            saveUserState(state: state)
            PersistenceManager.localUserState = newUserState ?? UserStateManager(currentAuthState: PersistenceManager.shared.userStates?.currentAuthState ?? .loggedOut,
                                                                                 currentOnboardingState: PersistenceManager.shared.userStates?.currentOnboardingState ?? .loggedOut)
            _userStates = newUserState
        }
    }
    
    var countryDataForSearch: CountryStateWrapper? = nil
    var countryFilter: [String: String]? {
        var params: [String: String]? = nil
        if let countryDataForSearch {
            params = [
                "country_id"    :   "\(countryDataForSearch.country.id)",
            ]
            if countryDataForSearch.selectedStateID > 0 {
                params?["state_id"]  =   "\(countryDataForSearch.selectedStateID)"
            }
        }
        return params
    }
    
    func loadCountryAndStateFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "selectedLocation") else { return }
        
        do {
            let decodedCache = try JSONDecoder().decode(CountryStateWrapper.self, from: data)
            countryDataForSearch = decodedCache
        } catch {
            print("Error decoding cache: \(error.localizedDescription)")
        }
    }
    
    var countryDataForAddPost:  CountryStateWrapper? = nil
    func loadCountryForAddPostsFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "selectedLocationForAddPost") else { return }
        
        do {
            let decodedCache = try JSONDecoder().decode(CountryStateWrapper.self, from: data)
            countryDataForAddPost = decodedCache
        } catch {
            print("Error decoding cache: \(error.localizedDescription)")
        }
    }
    
    // saved user to local db
    private func saveLoggedUser(beerUser: RegisterData) {
        let encoder = JSONEncoder()
        let localUser = beerUser
        
        if let encodedData = try? encoder.encode(localUser) {
            UserDefaults.standard.set(encodedData, forKey: Keys.Persistance.loggedInUser.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    // get user from local db
    private func getLoggedUser() -> RegisterData? {
        
        if let savedUserData = UserDefaults.standard.data(forKey: Keys.Persistance.loggedInUser.rawValue) {
            let decoder = JSONDecoder()
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let savedPerson = try decoder.decode(RegisterData.self, from: savedUserData)
                return savedPerson
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                return nil
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                return nil
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                return nil
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                return nil
            } catch {
                print("error: ", error)
                return nil
            }
            
        } else {
            return nil
            
        }
    }
    
    // saved user_state to local db
    private func saveUserState(state: UserStateManager) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(state) {
            UserDefaults.standard.set(encodedData, forKey: Keys.Persistance.userStates.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    // get user_state from local db
    private func getUserStates() -> UserStateManager? {
        
        if let savedUserStates = UserDefaults.standard.data(forKey: Keys.Persistance.userStates.rawValue) {
            let decoder = JSONDecoder()
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let savedState = try decoder.decode(UserStateManager.self, from: savedUserStates)
                return savedState
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                return nil
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                return nil
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                return nil
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                return nil
            } catch {
                print("error: ", error)
                return nil
            }
            
        } else {
            return nil
            
        }
    }
    
    // remove user
    func logout() {
        PersistenceManager.shared.userStates?.currentAuthState = .loggedOut
        PersistenceManager.shared.userStates = UserStateManager(currentAuthState: .loggedOut,
                                                                currentOnboardingState: .onBoardedAndLanguageSelected)
        
        PersistenceManager.localUserState.currentAuthState = .loggedOut
        PersistenceManager.localUserState = UserStateManager(currentAuthState: .loggedOut,
                                                             currentOnboardingState: .onBoardedAndLanguageSelected)
        UserDefaults.standard.removeObject(forKey: Keys.Persistance.loggedInUser.rawValue)
        UserDefaults.standard.removeObject(forKey: Keys.Persistance.fcmToken.rawValue)
        UserDefaults.standard.removeObject(forKey:  Keys.Persistance.authKey.rawValue)
        UserDefaults.standard.removeObject(forKey:  Keys.Persistance.refreshToken.rawValue)
        UserDefaults.standard.synchronize()
        Messaging.messaging().deleteToken { error in
                if let error = error {
                    print("Error deleting FCM token: \(error.localizedDescription)")
                } else {
                    print("FCM token deleted successfully.")
                }
            }
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
            } else if let token = token {
                UserDefaults.standard.set(token, forKey: Keys.Persistance.fcmToken.rawValue)
                UserDefaults.standard.synchronize()
            }
        }

    }
    
}

class UserStateManager: ObservableObject, Codable, Equatable {
    static func == (lhs: UserStateManager, rhs: UserStateManager) -> Bool {
        return lhs.currentAuthState == rhs.currentAuthState && lhs.currentOnboardingState == rhs.currentOnboardingState
    }
    
    enum States: Int, Codable {
        case notOnBoardedAndLanguageNotSelected = 1
        case notOnBoardedAndLanguageSelected = 2
        case onBoardedAndLanguageSelected = 3
        case loggedOut = 4
        case loggedIn = 5
        
    }
    
    @Published var currentAuthState: UserStateManager.States? = .loggedOut
    @Published var currentOnboardingState: UserStateManager.States? = .notOnBoardedAndLanguageNotSelected
    
    enum CodingKeys: CodingKey {
        case currentAuthState
        case currentOnboardingState
        
    }
    
    init() {}
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        currentAuthState = try container.decodeIfPresent(UserStateManager.States.self,
                                                         forKey: .currentAuthState) ?? .loggedOut
        currentOnboardingState = try container.decodeIfPresent(UserStateManager.States.self,
                                                               forKey: .currentOnboardingState) ?? .notOnBoardedAndLanguageNotSelected
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(currentAuthState, forKey: .currentAuthState)
        try container.encode(currentOnboardingState, forKey: .currentOnboardingState)
        
    }
    
    init(currentAuthState: UserStateManager.States,
         currentOnboardingState: UserStateManager.States) {
        self.currentAuthState = currentAuthState
        self.currentOnboardingState = currentOnboardingState
    }
}
