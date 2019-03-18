//
//  CarTypeProvider.swift
//  MS Cars
//
//  Created by Mohammad Shaker on 3/18/19.
//  Copyright © 2019 Mohammad Shaker. All rights reserved.
//

import Alamofire

enum CarTypeProvider: URLRequestConvertible {
    case manufacturers(page: Int, pageSize: Int)
    case manufacturerTypes(manufacturerCode: String, page: Int, pageSize: Int)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        return .get
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .manufacturers(let page, let pageSize):
            return "manufacturer?page=\(page)&pageSize=\(pageSize)&wa_key=\(K.ProductionServer.waValue)"
        case .manufacturerTypes(let manufacturerCode, let page, let pageSize):
            return "main-types?manufacturer=\(manufacturerCode)&page=\(page)&pageSize=\(pageSize)&wa_key=\(K.ProductionServer.waValue)"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        return nil
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var url = K.ProductionServer.baseURL + path
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
