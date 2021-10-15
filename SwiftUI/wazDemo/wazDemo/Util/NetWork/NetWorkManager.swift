//
//  NetWorkManager.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/14.
//

import Foundation
import Combine

enum NetWorkError: Error, LocalizedError {
    case unknow
    case failed
    case constructParamterFailed
    
    case decodeFailed
    case valideKeyPath
    
    case networkError(from: Error)
    case networkError(msg: String)
}

let Net = NetWorkManager.share

class NetWorkManager: NSObject {
    
    static let share = NetWorkManager()
    
    private let session = URLSession.shared
    
    func request(request: RequestInfo) -> AnyPublisher<Any, NetWorkError> {
        
        do {
            let request_t = try RequestUtil.request(requestInfo: request)
            let task = session.dataTaskPublisher(for: request_t)
//                .print()
                .receive(on: DispatchQueue.main)
                .tryMap { data -> Any  in
                    if (data.response as? HTTPURLResponse)?.statusCode == 200 {
                        let jsonObject = try JSONSerialization.jsonObject(with: data.data, options: .allowFragments)
                        return jsonObject
                    }else{
                        throw NetWorkError.failed
                    }
                }
                .mapError { error -> NetWorkError in
                    if let error = error as? NetWorkError {
                        return error
                    }else {
                        return NetWorkError.networkError(from: error)
                    }
                }

            return task.eraseToAnyPublisher()
        } catch  {
            return Fail<Any, NetWorkError>(error: .networkError(from: error)).eraseToAnyPublisher()
        }
    }
}

// Cannot convert return expression of type
// 'Publishers.FlatMap<AnyPublisher<[M], NetWorkError>, AnyPublisher<Any, NetWorkError>>'
// to return type
// 'AnyPublisher<[M], NetWorkError>'

extension AnyPublisher where Output == Any, Failure == NetWorkError  {
    
    func convertObject<M: Decodable>(type: M.Type) -> AnyPublisher<M, NetWorkError> {
        return flatMap { data -> AnyPublisher<M, NetWorkError> in
            do {
                let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let object = try JSONDecoder().decode(type, from: data)
                let ps = CurrentValueSubject<M, NetWorkError>(object)
                return ps.eraseToAnyPublisher()
            } catch {
                return Fail(error: NetWorkError.decodeFailed).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }

    func convertArrayObject<M: Decodable>(type: [M].Type, keyPath: String?) -> AnyPublisher<[M], NetWorkError> {
        
        return flatMap { data -> AnyPublisher<[M], NetWorkError> in
            
            if data is Array<Any> {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    let object = try JSONDecoder().decode(type, from: jsonData)
                    let ps = CurrentValueSubject<[M], NetWorkError>(object)
                    return ps.eraseToAnyPublisher()
                } catch {
                    return Fail(error: NetWorkError.networkError(from: error)).eraseToAnyPublisher()
                }
            }else if data is [String: Any] {
                guard let key = keyPath else {
                    return Fail(error: NetWorkError.valideKeyPath).eraseToAnyPublisher()
                }
                if let temp_arr = (data as! [String: Any])[key] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: temp_arr, options: .prettyPrinted)
                        let object = try JSONDecoder().decode(type, from: jsonData)
                        let ps = CurrentValueSubject<[M], NetWorkError>(object)
                        return ps.eraseToAnyPublisher()
                    } catch {
                        return Fail(error: NetWorkError.networkError(from: error)).eraseToAnyPublisher()
                    }
                }else {
                    return Fail(error: NetWorkError.decodeFailed).eraseToAnyPublisher()
                }
            }
            return Fail(error: NetWorkError.decodeFailed).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

struct RequestUtil {
    
    static func request(requestInfo: RequestInfo, timeoutInterval: TimeInterval = 30) throws -> URLRequest {
        var request = URLRequest(url: URL(string: requestInfo.url)!, timeoutInterval: timeoutInterval)
        request.httpMethod = requestInfo.method.rawValue
        if let paramter = requestInfo.paramter {
            request.httpBody = try JSONSerialization.data(withJSONObject: paramter, options: .fragmentsAllowed)
        }
        return request
    }
}


enum RequestMethod: String {
    case GET = "GET"
    case POST = "POST"
}

protocol RequestInfo {
   
    var url: String { get }
    var method: RequestMethod { get }
    var header: [String: Any]? { get }
    var paramter: [String: Any]? { get }
}
