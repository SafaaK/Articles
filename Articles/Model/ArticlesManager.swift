//
//  ArticlesManager.swift
//  Articles
//
//  Created by Safaa Khalaf on 20/8/21.
//

import Foundation
 

protocol ArticlesManagerDelegate {
     func didFetchData(_ articleManger: ArticlesManager, articleData: ArticleData)
     func didFailWithError(error: Error)
}

struct ArticlesManager {
    let headlinesURL = "https://newsapi.org/v2/top-headlines?"
    
    var delegate: ArticlesManagerDelegate?
    
    
    func fetchHeadlines() {
        var urlString = "\(headlinesURL)"
        
        if let data = UserDefaults.standard.value(forKey:"sources") as? Data {
            if let savedSources = try? PropertyListDecoder().decode(Array<SourceItem>.self, from: data){
                let idsArray = savedSources.map { $0.id }
                let strIds =  idsArray.joined(separator: ",")
                urlString = urlString.appending("sources=\(strIds)")
            }
        
        }
        urlString = urlString.appending("&apikey=\(K.apiKey)")
        print("urlstring: \(urlString)")
        performRequest(with: urlString)
    }
     
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let articles = self.parseArticlesJSON(safeData) {
                        self.delegate?.didFetchData(self, articleData: articles)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseArticlesJSON(_ articlesData: Data) -> ArticleData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ArticleData.self, from: articlesData) 
            return decodedData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    } 
    
}
