//
//  ProfileViewController.swift
//  Alamofire
//
//  Created by Anurita Srivastava on 12/01/18.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
class ProfileViewController: UIViewController,NVActivityIndicatorViewable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    @IBOutlet weak var historyCollection: UICollectionView!
    @IBOutlet weak var reviewsCollection: UICollectionView!
    @IBOutlet weak var incomProfileLbl: UILabel!
    
    @IBOutlet weak var historyArrow: UIButton!
    @IBOutlet weak var pendingReviewArrow: UIButton!
    @IBOutlet weak var historyLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var redeemInviteCard: UIView!
    @IBOutlet weak var getInviteCard: UIView!
    @IBOutlet weak var pendingReviewLbl: UILabel!
    @IBOutlet weak var historyLbl: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profile_view: UIView!
    var pendingReviews=[NewPendingReview]()
    var transactionHistory=[NewTransaction]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = UserDefaults.standard
        let uid = preferences.string(forKey: "ID")
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        userName.text = preferences.string(forKey: "name") ?? "Unknown"
        if !(preferences.string(forKey: "name") != nil || preferences.string(forKey: "contact") != nil || preferences.string(forKey: "gender") != nil || preferences.string(forKey: "dob") != nil) {
            incomProfileLbl.isHidden=true
        }
        if preferences.bool(forKey: "isBrowseOnly") {
            historyCollection.isHidden=true
            reviewsCollection.isHidden=true
            pendingReviewLbl.isHidden=true
            historyLbl.isHidden=true
            redeemInviteCard.isHidden=false
            getInviteCard.isHidden=false
            historyArrow.isHidden=true
            pendingReviewArrow.isHidden=true
        }
        if Connectivity.isNotConnectedToInternet{
            noInternetDialog {
                self.getProfile(uid!,authToken!)
            }
        } else
        {self.getProfile(uid!,authToken!)}
        
        //change statusBar color
        if let sb = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView {
            sb.backgroundColor = UIColor.black
        }
        setupView()
    }
    func openBrowser(url:String?){
        let mUrl=URL(string:url!)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(mUrl!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(mUrl!)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = "•"
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = " "
    }
    
    @IBAction func getInviteCodePressed(_ sender: Any) {
        openBrowser(url: "https://entertainerindia.com/buy")
    }
    @IBAction func redeemInviteCodePressed(_ sender: Any) {
        clearPrefs()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RedeemInviteVC") as! InviteViewController
        self.present(vc, animated: true, completion: nil)
    }
    func getProfile(_ uid: String,_ authToken:String){
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        let param = ["access_token": authToken]
        Alamofire.request(Constant().baseURL+"users/\(uid)/profile",method: .get, parameters: param, encoding: URLEncoding.queryString).responseJSON { response in
            print(response.request ?? "")
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let profile = NewUserProfile(JSONString: utf8Text)
                    let code = profile?.code
                    
                    if code == 200{
                        print("Got profile data successfully")
                        self.reloadView((profile?.pendingReviews)!, (profile?.transactions)!)
                        
                    }else{self.apiErrorHandler(code: code, msg: profile?.msg, function: {
                        self.self.getProfile(uid, authToken)
                    })
                        print("Unable to search")
                    }
                }
            case .failure:self.errorDialog(function: {
                self.getProfile(uid, authToken)
                
            })
            print("Error Ocurred in getting profile data!")
            }
        }
    }
    func reloadView(_ pendingReviews: [NewPendingReview],_ transactionHistory: [NewTransaction]){
        DispatchQueue.main.async{
            print("Refreshing data")
            self.transactionHistory.removeAll()
            self.pendingReviews.removeAll()
            self.pendingReviews = pendingReviews
            if pendingReviews.count == 0 {
                
                self.reviewsCollection.isHidden=true
                self.pendingReviewLbl.isHidden=true
                self.pendingReviewArrow.isHidden=true
                self.historyLabelTopConstraint.constant=16
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }else{
               
                self.reviewsCollection.reloadData()
            }
            self.transactionHistory=transactionHistory
            if transactionHistory.count == 0 {
                self.historyArrow.isHidden=true
                self.historyCollection.isHidden=true
                self.historyLbl.isHidden=true
            }else{
                
                self.historyCollection.reloadData()
            }
        }
    }
    @IBAction func openSettings(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "profileSettingsVC") as! ProfileSettingsViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == reviewsCollection{return pendingReviews.count}else
        {return transactionHistory.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == reviewsCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewsCell", for: indexPath) as! reviewsCollectionCell
            let review=pendingReviews[indexPath.row]
            cell.nameL.text=review.client?.establishmentName
            var ratingValue=5.0
            cell.starR.didFinishTouchingCosmos = { rating in
                ratingValue=rating
                cell.reviewButtonView.isHidden=false
            }
            cell.onCrossTapped={
                cell.reviewButtonView.isHidden=true
            }
            cell.onTickTapped={
                self.submitReview(clientId: (review.client?.id)!,transactionId: review.transactionId!, rating: ratingValue,index: indexPath)
            }
            
            addShadowToCell(cell: cell)
            return  cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryCollectionCell
            addShadowToCell(cell: cell)
            let transaction=transactionHistory[indexPath.row]
            cell.nameL.text=transaction.client?.establishmentName
            if transaction.client?.logo==nil{
                cell.imageV.image = #imageLiteral(resourceName: "logo_without_bkg")
            }else{
                let url = URL(string: (transaction.client?.logo)!)
                cell.imageV.kf.setImage(with: url)
            }
            
            //color logic
            if(self.transactionHistory[indexPath.row].transactionType=="Premium"){
                cell.card.backgroundColor = UIColor(rgb: 0x1A2029)
                cell.nameL.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.timeL.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.couponL.text="Offer redeemed."
            }else{
                cell.card.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.couponL.textColor = UIColor(rgb: 0x0E1116)
                cell.nameL.textColor = UIColor(rgb: 0x0E1116)
                cell.timeL.textColor = UIColor(rgb: 0x0E1116)
                cell.couponL.text="Loyalty reward redeemed."
            }
            return cell
        }
    }
    func addShadowToCell(cell:UICollectionViewCell){
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 3.0
        cell.layer.masksToBounds = false
    }
    func setupView(){
        profile_view.layer.cornerRadius = 5
        profile_view.layer.masksToBounds = true
    }
    
    func submitReview(clientId: String,transactionId:String, rating: Double, index:IndexPath) {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        let preferences = UserDefaults.standard
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        let uid=preferences.string(forKey: "ID")
        let parameters = [
            "rating": Int(rating)
        ]
        
        var url = Constant().baseURL + "users/" + uid!
        url += "/clients/" + clientId + "/reviews?transaction_id="+transactionId+"&access_token=" + authToken!
        
        Alamofire.request(url,method: .put, parameters: parameters)
            .responseJSON { response in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                print(url)
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let reviewRes = UploadReviewResponse(JSONString: utf8Text)
                        let code = reviewRes?.code
                        
                        if code == 200{
                            print("review successfully")
                            self.sucessReview(index: index)
                            let alertView = UIAlertController(title: "Success", message: "Successfully reviewed!", preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{
                                action in
                            }
                            ))
                            self.present(alertView, animated: true, completion: nil)
                            
                        }else{self.apiErrorHandlerCancellable(code: code, msg: reviewRes?.msg, function: {
                            self.self.submitReview(clientId: clientId,transactionId:transactionId ,rating: rating, index: index)
                        })
                            print("Unable to review")
                        }
                    }
                case .failure:self.errorDialog(function: {
                    self.submitReview(clientId: clientId, transactionId:transactionId,rating: rating, index: index)
                    
                })
                print("Error Ocurred in getting profile data!")
                }
        }
        
    }
    func sucessReview(index:IndexPath){
        pendingReviews.remove(at: index.row)
        reviewsCollection.deleteItems(at: [index])
        reviewsCollection.reloadData()
    }
}

