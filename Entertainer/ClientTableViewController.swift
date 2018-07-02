//
//  ClientTableViewController.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 27/12/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//
import UIKit

class ClientTableViewController: UIViewController, APIManagerDelegate {
    
     var categories = [CategoriesToSend]()
    var results = [[Result]]()
    let sharedInstance = APIManager()
    @IBOutlet weak var tableView: UITableView!
    var m = ["mew","mm","meee"]
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedInstance.delegate = self
      
        // Do any additional setup after loading the view.
    }
    
    func reloadCollectionView(_ cData: [CategoriesToSend],_ rData: [[Result]]) {
        DispatchQueue.main.async{
            print("Refreshing data")
            self.tableView.reloadData()
            self.results = rData
            self.categories = cData
           
        }
    }
    
}
extension ClientTableViewController: UITableViewDelegate, UITableViewDataSource{
   func numberOfSections(in tableView: UITableView) -> Int {
        return categories[ca]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientTableCell", for: indexPath) as! ClientTableCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return m[section]
      
    }
}

