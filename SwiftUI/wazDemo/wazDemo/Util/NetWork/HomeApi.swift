//
//  HomeApi.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/15.
//

import Foundation

enum HomeApi {
    
    case banner
    case articList
    case articNormalList(page: Int)
}

extension HomeApi: RequestInfo {
    
    var url: String {
        switch self {
        case .banner:
            return Api.Home.banner.fullUrl
        case .articList:
            return Api.Home.topArticle.fullUrl
        case let .articNormalList(page: p):
            return Api.Home.normalArticle.fullUrl + "/\(p)" + "/json"
        }
        
    }
    
    var method: RequestMethod {
        return .GET
    }
    
    var header: [String : Any]? {
        return nil
    }
    
    var paramter: [String : Any]? {
        return nil
    }
}
