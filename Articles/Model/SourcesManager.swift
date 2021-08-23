//
//  SourcesManagerDelegate.swift
//  Articles
//
//  Created by Safaa Khalaf on 20/8/21.
//

import Foundation
  
protocol SourcesManagerDelegate {
     func didFetchData(_ sourceManager: SourcesManager, sourceData: SourceData)
     func didFailWithError(error: Error)
}

struct SourcesManager {
     let sourcesURL = "https://newsapi.org/v2/top-headlines/sources?language=en";
 
     var delegate: SourcesManagerDelegate?
   
    
    func getSavedArticles()->[Article] {
        var savedArticles: [Article] = []
      
        if let data = UserDefaults.standard.value(forKey:"savedArticles") as? Data {
            if let savedArticlesInDefaults = try? PropertyListDecoder().decode(Array<Article>.self, from: data){
                savedArticles = savedArticlesInDefaults
            }
        }
        return savedArticles
    }
    
    
    func fetchSources() {
        let urlString = "\(sourcesURL)&apikey=\(K.apiKey)"
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
                    if let sources = self.parseSourcesJSON(safeData) {
                        self.delegate?.didFetchData(self, sourceData: sources)
                    }
                }
            }
            task.resume()
        }
    }
     
    
    func parseSourcesJSON(_ sourceData: Data) -> SourceData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SourceData.self, from: sourceData)
            return decodedData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
