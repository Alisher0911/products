//
//  NetworkService.swift
//  TestProject
//
//  Created by Alisher Orazbay on 10.11.2022.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    
    private init () {}
    
    func request<T: Codable>(_ absoluteUrl: String,
                            httpMethod: HttpMethod = .get,
                            completion: @escaping (Result<T, Error >) -> Void) {
         
        guard let url = URL(string: absoluteUrl) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
    
            if error != nil {
                completion(.failure( NetworkError.custom(error: error!)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...300) ~= response.statusCode else {
                let statusCode = (response as! HTTPURLResponse).statusCode
                completion(.failure(NetworkError.invalidStatusCode(statusCode: statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let res = try decoder.decode(T.self, from: data)
                completion(.success(res))
            } catch {
                completion(.failure(NetworkError.failedToDecode(error: error)))
            }
        }
        
        dataTask.resume()
    }
}


extension NetworkService {
    enum NetworkError: Error {
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
    
    enum HttpMethod: String {
        case get
        case post
        
        var method: String { rawValue.uppercased() }
    }
}
