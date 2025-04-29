//
//  Network.swift
//  Kulushae
//
//  Created by ios on 10/10/2023.
//

import Foundation
import Apollo


class Network {
    static let shared = Network()
    
    private(set) lazy var apollo: ApolloClient = {
        
        let cache = InMemoryNormalizedCache()
        let store1 = ApolloStore(cache: cache)
        let authPayloads = ["Authorization": "Bearer " + (UserDefaults.standard.string(forKey: Keys.Persistance.authKey.rawValue) ?? "") ]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = authPayloads
        
        let client1 = URLSessionClient(sessionConfiguration: configuration, callbackQueue: nil)
        let provider = NetworkInterceptorProvider(client: client1, shouldInvalidateClientOnDeinit: true, store: store1)
        
        let url = URL(string: Config.apollo_url)!
        
        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        
        return ApolloClient(networkTransport: requestChainTransport, store: store1)
    }()
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(CustomInterceptor(), at: 0)
        return interceptors
    }
}

class CustomInterceptor: ApolloInterceptor {
    var id: String = ""
    
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Swift.Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            request.addHeader(name: "Authorization", value: "Bearer " + (UserDefaults.standard.string(forKey: Keys.Persistance.authKey
                .rawValue) ?? "") )
            request.addHeader(name: "X-App-Language", value: (UserDefaults.standard.string(forKey: "AppLanguage") ?? "en") )
            request.addHeader(name: "X-Digital-Signature", value: (UserDefaults.standard.string(forKey: "signatureString") ?? "") )
//            request.addHeader(name: "Content-Type", value: "application/json")
            print("request :\(request)")
//            print("request param :\(request.operation.variables)")
            print("response :\(String(describing: response))")
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
}
//class Network {
//  static let shared = Network()
//    private(set) lazy var apollo = ApolloClient(url: URL(string: Config.apollo_url)!)
//}

extension Int {
    var graphQLNullable: GraphQLNullable<Int> {
        GraphQLNullable(integerLiteral: self)
    }
}

//extension Optional where Wrapped == Int {
//    var graphQLNullable: GraphQLNullable<Int>? {
//        GraphQLNullable(integerLiteral: self ?? 0)
//    }
//}

extension String {
    var graphQLNullable: GraphQLNullable<String> {
        GraphQLNullable(stringLiteral: self)
    }
}

//extension Optional where Wrapped == String {
//    var graphQLNullable: GraphQLNullable<String> {
//        GraphQLNullable(stringLiteral: self ?? "")
//    }
//}

extension Bool {
    var graphQLNullable: GraphQLNullable<Bool> {
        GraphQLNullable(booleanLiteral: self)
    }
}

//extension Optional where Wrapped == Bool {
//    var graphQLNullable: GraphQLNullable<Bool> {
//        GraphQLNullable(booleanLiteral: self ?? false)
//    }
//}
