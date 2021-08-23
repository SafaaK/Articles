//
//  HeadlinesViewController.swift
//  Articles
//
//  Created by Safaa Khalaf on 20/8/21.
//

import UIKit
import PKHUD
class HeadlinesViewController: UIViewController {

    @IBOutlet weak var headlinesTable: UITableView!
    var articlesManager = ArticlesManager()
    var articlesList: [Article] = []
    var refreshHeadlines = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Headlines"
        
        headlinesTable.tableFooterView = UIView()
        articlesManager.delegate = self
        articlesManager.fetchHeadlines()
        //Notification observer to refresh headlines when sources change
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshHeadlines(_:)), name: .refreshHeadlines, object: nil)
        
    }
    
    @objc func RefreshHeadlines(_ notification: Notification) {
        refreshHeadlines = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(refreshHeadlines){
            HUD.show(.labeledProgress(title: "Refreshing Headlines", subtitle: " "))
            articlesManager.fetchHeadlines()
        }
        headlinesTable.reloadData() 
    }
      
}




//MARK: -  UITableViewDelegate
extension HeadlinesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showArticleDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as!  ArticleDetailsViewController
        if let indexpath = headlinesTable.indexPathForSelectedRow{
            let selectedArticle = articlesList[indexpath.row]
            destinationVC.article = selectedArticle
        }
    }
    
    
}

//MARK: - UITableViewDataSource

extension HeadlinesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let secCount =  articlesList.count==0  ? 0 :1
        if(secCount == 0){
            headlinesTable.setEmptyView(title: "Headlines will show up here", message: "", messageImage: UIImage(imageLiteralResourceName: "headline"))
        }
        else {
            headlinesTable.restore()
        }
        return secCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

//MARK: - ArticlesManagerDelegate
extension HeadlinesViewController: ArticlesManagerDelegate {
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            HUD.hide()
            print(error)
            let alert = UIAlertController(title: "Failed to Fetch Headlines", message: error.localizedDescription, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
       
    }
    
    func didFetchData(_ articleManger: ArticlesManager, articleData: ArticleData){
        DispatchQueue.main.async {
            HUD.hide()
            self.articlesList = articleData.articles
            self.headlinesTable.reloadData()
            self.refreshHeadlines = false
        }
    }
    
   
}

