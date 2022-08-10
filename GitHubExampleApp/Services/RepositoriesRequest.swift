//
//  RepositoriesService.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 1.08.2022.
//

import Foundation

struct RepositoriesRequest: DataRequest {
    
    private var searchedText: String
    private var desiredTimeRange: String
    private var currentTime: String
    private var pageNumber: String
    
    init(searchedText: String,
         desiredTimeRange: String,
         currentTime: String,
         pageNumber: String) {
        self.searchedText = searchedText
        self.desiredTimeRange = desiredTimeRange
        self.currentTime = currentTime
        self.pageNumber = pageNumber
    }
    
    
    var url: String {
        let baseURL: String = "https://api.github.com"
        let path: String = "/search/repositories"
        return baseURL + path
    }
    
    var queryItems: [String : String] {
        [
            "q": searchedText + "+created:" + desiredTimeRange + "+created:" + currentTime,
            "sort" : "stars",
            "per_page" : "20",
            "order": "desc",
            "page": pageNumber
        ]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> RepositoriesResponseModel {
        let decoder = JSONDecoder()
        let response = try decoder.decode(RepositoriesResponseModel.self, from: data)
        return response
    }
    
}
