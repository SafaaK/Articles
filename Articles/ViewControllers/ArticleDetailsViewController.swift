//
//  ArticleDetailsViewController.swift
//  Articles
//
//  Created by Safaa Khalaf on 22/8/21.
//

import UIKit
import WebKit

class ArticleDetailsViewController: UIViewController {

    var sourcesManager = SourcesManager()
 
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    var savedArticles: [Article] = []
  
    var article: Article? {
        didSet {
           loadContent()
        }
    }
    
    func loadContent(){
        savedArticles = sourcesManager.getSavedArticles()
        
      if let articleValue = article{
          if savedArticles.contains(articleValue) {
            saveButton.image = UIImage(systemName: "bookmark.fill")
          } else { 
               saveButton.image = UIImage(systemName: "bookmark")
          }
        
         
      }
        
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let str = article?.url{
            
            let url = URL(string: str)!
            webView.load(URLRequest(url: url))
             
        }
         
    }


    @IBAction func SaveArticle(_ sender: Any) {
          
        if let articleValue = article{
            if savedArticles.contains(articleValue) {
                savedArticles.remove(at: savedArticles.lastIndex(of: articleValue)!)
                saveButton.image = UIImage(systemName: "bookmark")
            } else {
                savedArticles.append(articleValue)
                saveButton.image = UIImage(systemName: "bookmark.fill")
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(savedArticles), forKey:"savedArticles")
           
        }
       
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
