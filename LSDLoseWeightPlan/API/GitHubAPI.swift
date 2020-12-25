//
//  ExampleAPI.swift
//  BaseProject
//
//  Created by Sidi Liu on 2020/11/23.
//

import Foundation
import Moya
import SwiftyJSON

enum GitHubAPI {
    case getTargetData
}

extension GitHubAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com/repos/sacredsoul/Secrets")!
    }
    
    var path: String {
        switch self {
        case .getTargetData:
            return "/contents/减脂.md"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .getTargetData:
            return .requestParameters(parameters: ["ref": "main"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

