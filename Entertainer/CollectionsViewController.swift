//
//  CollectionsViewController.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 09/02/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit

class CollectionsViewController:UIViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = "•"
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = " "
    }
    //Dummy cell added here, to accomodate social buttons
    var collectionName = ["dummy","Great Gorge-ing","Delectable Spreads","Fine Dining","Corporate Favourites","Rooftops",
                          "Tipsy Stories","Scrumptions Greens","Quick Bites","Live Music","Sweet Tooth",
                          "Cafes &amp;  Bistro","Sweet Concoction","Frozen Delights","Gaming &amp; Adventure","Glam Sham"]
    var collectionDesc = ["dummy","Gorge on your favorites like never before.","Feast on these sumptuous buffets.","The perfect synthesis of elegance and quality food.","Works meetings have never been this delicious.","Sundowners, drinks and spectacular views- what more?","Relish the city's best and discover what's brewing with every celebration.","Who said healthy couldn't be tasty?","Grab a  yummy snack amidst the hustle bustle.","Soul food,soul music, A perfect night.","Indulge your inner candy monster once in a while!","Quick caffeine breaks, lazy cuppas, warm ambiences.","Sugary delights to satiate your cravings.","The perfect kinda brain freeze  you have been looking for.","Delight  your inner spirit with your preferred activities and games.","Reinvent your wardrobe and style with the best in Hyderabad."]
    var collectionBgImg = [#imageLiteral(resourceName: "logo_without_bkg"),#imageLiteral(resourceName: "great gorge-ing"),#imageLiteral(resourceName: "delectable spreads"),#imageLiteral(resourceName: "fine dining"),#imageLiteral(resourceName: "corporate favs"),#imageLiteral(resourceName: "rooftops"),#imageLiteral(resourceName: "tipsy stories"),#imageLiteral(resourceName: "scrumptious greens"),#imageLiteral(resourceName: "quick bites"),#imageLiteral(resourceName: "live music"),#imageLiteral(resourceName: "sweet tooth"),#imageLiteral(resourceName: "cafe & bistro"),#imageLiteral(resourceName: "concotion"),#imageLiteral(resourceName: "frozen"),#imageLiteral(resourceName: "gaming adventure"),#imageLiteral(resourceName: "glam sham")]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueForCollections") {
            //get a reference to the destination view controller
            let controller = segue.destination as! SelectCollectionViewController
        }
    }
    
}
extension CollectionsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectionName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "socialCell") as! socialCell
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! CollectionCell
            cell.collectionL.text = self.collectionName[indexPath.row]
            cell.collectionDesc.text = self.collectionDesc[indexPath.row]
            cell.selectionStyle = .none
            cell.bgImage.image = self.collectionBgImg[indexPath.row]
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "segueForCollections", sender: self)
        let storyboard = UIStoryboard(name: "Collections", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "selectCollectionVC") as! SelectCollectionViewController
        controller.cImg = self.collectionBgImg[indexPath.row]
        controller.cName = self.collectionName[indexPath.row]
        controller.collectionIndex = indexPath.row
        self.present(controller, animated: true, completion: nil)
    }
}
