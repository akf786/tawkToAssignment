//
//  DataStore.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation

enum NetworkError: String, Error {
    case serverError = "Server Error"
    case parsinError = "Unable to parse json from server"
}

protocol DataStore {
    func getUsersList(since: Int, completionHandler: @escaping (Result<Data, NetworkError>) -> Void)
    func getUserProfile(userName: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void)
}

class DataStoreImp: DataStore {
    
    func getUserProfile(userName: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let urlString = String.init(format: "%@%@", AppConstants.EndPoints.getUserProfile,userName)
        
        guard let url = URL(string: urlString)  else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data else {
                completionHandler(.failure(.serverError))
                return
            }
            
            completionHandler(.success(data))
        })
        task.resume()
        
    }
    
    
    /// This function returns users list from server.
    ///
    /// - Returns: A saved tv object array if successfully fetched and error object if failed
    func getUsersList(since: Int, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let urlComponents = NSURLComponents(string: AppConstants.EndPoints.getAllUsers)
        urlComponents?.queryItems = [
            URLQueryItem(name: "since", value: String(since))
        ]
        
        guard let url = urlComponents?.url  else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let data = data else {
                completionHandler(.failure(.serverError))
                return
            }
            
            completionHandler(.success(data))
        })
        task.resume()
    }
    
}
