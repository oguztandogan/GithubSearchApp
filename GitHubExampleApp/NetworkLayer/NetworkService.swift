//
//  APIDENEME.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 2.08.2022.
//

import Foundation


// MARK: - Generic Network Service

protocol NetworkService {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
    func downloadImage(imageURL: String?, completion: @escaping (Result<Data, Error>) -> (Void))
}

final class DefaultNetworkService: NetworkService {
    
    private var imagesCache = NSCache<NSString, NSData>()

    
    /// Creates request
    /// - Parameters:
    ///   - request: Desired request
    ///   - completion: Callback when request is completed
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        var urlComponent = URLComponents(string: request.url)
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent?.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        urlComponent?.queryItems = queryItems
        
        guard let url = urlComponent?.url else {  return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(NSError()))
            }
            
            guard let data = data else {
                return completion(.failure(NSError()))
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    
    /// Image downloader and cacher
    /// - Parameters:
    ///   - imageURL: Desired imageURL to download or cache
    ///   - completion: Callback when image downloaded or cached
    func downloadImage(imageURL: String?, completion: @escaping (Result<Data, Error>) -> (Void)) {
        guard let url = URL(string: imageURL ?? "") else {
            return
        }
      if let imageData = imagesCache.object(forKey: url.absoluteString as NSString) {
          completion(.success(imageData as Data))
        return
      }
      
        let task = URLSession.shared.downloadTask(with: url) { localUrl, response, error in
        if let error = error {
            completion(.failure(error))
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
          return
        }
        
        guard let localUrl = localUrl else {
          return
        }
        
        do {
          let data = try Data(contentsOf: localUrl)
          self.imagesCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
            completion(.success(data))
        } catch let error {
            completion(.failure(error))
        }
      }
      
      task.resume()
    }
}
