//
//  SavedArticlesViewController.swift
//  Articles
//
//  Created by Safaa Khalaf on 20/8/21.
//

import UIKit

class SavedArticlesViewController: UIViewController {

    var articlesList: [Article] = []
    var sourcesManager = SourcesManager()
    
    @IBOutlet weak var savedArticlesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Saved"
        
        savedArticlesTable.tableFooterView = UIView()
        loadSavedArticles() 
    }
    
    func loadSavedArticles(){
        articlesList = sourcesManager.getSavedArticles()
      
        savedArticlesTable.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadSavedArticles()
    }
}



//MARK: -  UITableViewDelegate
extension SavedArticlesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showArticleDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as!  ArticleDetailsViewController
        if let indexpath = savedArticlesTable.indexPathForSelectedRow{
            let selectedArticle = articlesList[indexpath.row]
            destinationVC.article = selectedArticle
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Attention", message: "Do you want to remove this article from your bookmarks?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{ action in
               
                let article = self.articlesList[indexPath.row]
                if self.articlesList.contains(article) {
                    self.articlesList.remove(at: self.articlesList.lastIndex(of: article)!)
                }
                 
                UserDefaults.standard.set(try? PropertyListEncoder().encode(self.articlesList), forKey:"savedArticles")
                 
                DispatchQueue.main.async {
                    
                    tableView.reloadData()
                }
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
    }
    
    
    
    
}

//MARK: - UITableViewDataSource

extension SavedArticlesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let secCount =  articlesList.count==0  ? 0 :1
        
        if(secCount == 0){
            tableView.setEmptyView(title: "Saved Articles will show up here", message: "", messageImage: UIImage(imageLiteralResourceName: "bookmark"))
        }
        else {
            tableView.restore()
        }
        return secCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("num of articles: \(articlesList.count)")
        return articlesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let article = articlesList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
       
        cell.titleLabel?.text = article.title
        cell.descLabel?.text = article.description
        cell.authorLabel.text = article.author
        if let imgURL = article.urlToImage{
            cell.thumbnailImg.downloaded(from:imgURL)
        }
      

        return cell
    }
}

