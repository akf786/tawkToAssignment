//
//  DataStore.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
import UIKit

enum NetworkError: String, Error {
    case serverError = "Server Error"
    case parsinError = "Unable to parse json from server"
}

protocol DataStore {
    func getUsersList(since: Int, completionHandler: @escaping (Result<Data, NetworkError>) -> Void)
    func getUserProfile(userName: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void)
}

class DataStoreImp: DataStore {
    
    private var requests = [URLRequest]()
    private let queue = DispatchQueue.global(qos: .background)
    private let semaphore = DispatchSemaphore(value: 1)
    
    func getUserProfile(userName: String, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let urlString = String.init(format: "%@%@", AppConstants.EndPoints.getUserProfile,userName)
        
        guard let url = URL(string: urlString)  else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        self.requests.append(request)
        self.getResponseFromServerFor(request: request) { result in
            switch result {
            case .failure(_):
                completionHandler(.failure(.serverError))
                
            case .success(let data):
                completionHandler(.success(data))
                break
            }
        }
        
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
        print("My url string\(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        self.requests.append(request)
        self.getResponseFromServerFor(request: request) { result in
            switch result {
            case .failure(_):
                completionHandler(.failure(.serverError))
                
            case .success(let data):
                completionHandler(.success(data))
                break
            }
        }
        
    }
    
    
    
    func getResponseFromServerFor(request: URLRequest, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        queue.async {
            self.semaphore.wait()
            
            if !Reachability.isConnectedToNetwork() {
                DispatchQueue.main.async {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.startObservingInternetConnectivity()
                    }
                }
            }
            
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard let data = data else {
                    self.semaphore.signal()
                    completionHandler(.failure(.serverError))
                    return
                }
                
                self.semaphore.signal()
                completionHandler(.success(data))
            })
            task.resume()
            
        }
    }
    
    
}
