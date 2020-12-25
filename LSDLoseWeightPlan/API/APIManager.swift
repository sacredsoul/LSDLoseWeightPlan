//
//  APIManager.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/24.
//

import Foundation
import Moya

class APIManager {
    private static let networkActivityPlugin = NetworkActivityPlugin { (changeType, targetType) in
        switch changeType {
        case .began:
            /// Indicator show
            return
        case .ended:
            /// Indicator hide
            print(targetType.sampleData)
            return
        }
    }
    private static let networkLoggerPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration())
    
    static let shared = MoyaProvider<GitHubAPI>(plugins: [networkActivityPlugin, networkLoggerPlugin])
    
}

extension Reactive where Base: MoyaProviderType {
    func request<T: HandyJSON>(_ token: Base.Target, callbackQueue: DispatchQueue? = nil, responseType type: T.Type) -> Single<T> {
        return request(token, callbackQueue: callbackQueue).map(to: type)
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func map<T: HandyJSON>(to type: T.Type) -> Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(response.map(to: type))
        }
    }
}

extension Response {
    func map<T: HandyJSON>(to type: T.Type) -> T {
        return T.deserialize(from: String(data: data, encoding: .utf8))!
    }
}

class UseSampleDataPlugin: PluginType {
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let response):
            return .success(Response(statusCode: response.statusCode, data: target.sampleData, request: response.request, response: response.response))
        default:
            return result
        }
    }
}
