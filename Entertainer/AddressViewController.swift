//
//  AddressViewController.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 06/03/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var clientNameL: UILabel!
    var addr = [Branche]()
    var clientName = String()
    var n = Int()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    override func viewDidLoad() {
        self.clientNameL.text = self.clientName
    }
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addrCell") as! hostCollectionViewCell
        cell.address.text = addr[indexPath.row].address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.n = indexPath.row
        performSegue(withIdentifier: "backToHost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToHost"{
            let controller = segue.destination as! HostViewController
            controller.n = self.n
        }
    }
}
