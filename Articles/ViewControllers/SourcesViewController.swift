//
//  SourcesViewController.swift
//  Articles
//
//  Created by Safaa Khalaf on 20/8/21.
//

import UIKit
import PKHUD

class SourcesViewController: UIViewController {
    var sourcesManager = SourcesManager()
    var sourcesList: [SourceItem] = []
 
    var selectedSources:[SourceItem] = []
    
    @IBOutlet weak var sourcesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSavedSources()
        
        navigationItem.title = "Sources"
         
        sourcesManager.delegate = self
        sourcesManager.fetchSources()
        sourcesTable.tableFooterView = UIView()
    }
    
    func loadSavedSources(){
        if let data = UserDefaults.standard.value(forKey:"sources") as? Data {
            if let savedSources = try? PropertyListDecoder().decode(Array<SourceItem>.self, from: data){
                selectedSources = savedSources
            } 
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        sourcesTable.reloadData() 
    }
     

}


extension SourcesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let secCount =  sourcesList.count==0  ? 0 :1
        
        if(secCount == 0){
            sourcesTable.setEmptyView(title: "Sources will show up here", message: "", messageImage: UIImage(imageLiteralResourceName: "globe"))
            
        }
        else {
            sourcesTable.restore()
        }
        return secCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return sourcesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let source = sourcesList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCellIdentifier", for: indexPath) as! SourceCell
        cell.titleLabel?.text = source.name
        cell.descriptionLabel.text = source.description
        if selectedSources.contains(source) {
            cell.accessoryType = .checkmark
          
        } else {
            cell.accessoryType =  .none
          
        }
        return cell
    }
}


//MARK: -  UITableViewDelegate
extension SourcesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let source = sourcesList[indexPath.row]
        
        if selectedSources.contains(source) { 
            selectedSources.remove(at: selectedSources.lastIndex(of: source)!)
        } else {
            selectedSources.append(source)
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(selectedSources), forKey:"sources")
        NotificationCenter.default.post(name: .refreshHeadlines, object: nil)
       
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
}


extension SourcesViewController: SourcesManagerDelegate {
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
        print(error)
        let alert = UIAlertController(title: "Failed to Fetch Sources", message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        }
        
    }
    
    
    func didFetchData(_ sourcesManager: SourcesManager, sourceData: SourceData){
        DispatchQueue.main.async {
           //reload table
            self.sourcesList = sourceData.sources
            self.sourcesTable.reloadData()
        }
    }
    
   
}

