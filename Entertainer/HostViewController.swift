//
//  HostViewController.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 04/11/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class HostViewController: UIViewController{

    @IBOutlet weak var viewOffersBtn: UIButton!
    @IBOutlet weak var clientNameLbl: UILabel!
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var pageControl: UIPageControl!
  
    @IBOutlet weak var arrow: UIButton!
    @IBOutlet weak var clientStausLbl: UILabel!
    
    var n = 0
    @IBAction func dismiss(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    @IBOutlet weak var weekDayT: UILabel!
    @IBOutlet weak var weekEndT: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var whatsappB: UIButton!
    @IBOutlet weak var facbookB: UIButton!
    @IBOutlet weak var instaB: UIButton!
    
    var client_id = String()
    var clientName = String()
    var host : Client? = nil
    var time : Timing? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        clientNameLbl.text = self.clientName
        viewOffersBtn.layer.cornerRadius = viewOffersBtn.frame.size.height/2
        viewOffersBtn.layer.shadowOffset = CGSize(width: 0, height: 10)
        viewOffersBtn.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        viewOffersBtn.layer.shadowOpacity = 1
        
        viewOffersBtn.layer.shadowRadius = viewOffersBtn.frame.size.height/2
        
        
        let gradient = CAGradientLayer()
        gradient.frame = viewOffersBtn.bounds
        gradient.colors = [    UIColor(red:1, green:0.45, blue:0.46, alpha:1).cgColor,    UIColor(red:0.31, green:0.38, blue:0.5, alpha:1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradient.cornerRadius = viewOffersBtn.frame.size.height/2
        viewOffersBtn.layer.addSublayer(gradient)
        
         self.scrollView.delegate = self
        self.getHostDetails(client_id)
//         facbookB.isHidden = true
//         instaB.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        var contentRect = CGRect.zero
        
        for view in scrollContainer.subviews {
            contentRect = contentRect.union(view.frame)
        }
        scrollContainer.contentSize = contentRect.size
    }
  
    @IBAction func mapsPressed(_ sender: Any) {
        let branch=host?.branches![n]
        if branch?.location != nil{
            openMapForPlace(name: branch!.address!, lat:String(describing: branch?.location![1]), lng: String(describing:branch?.location![0]))
        }
        else{
          openMapForPlace(name: branch!.address!, lat:nil, lng: nil)
        }
    }
    @IBAction func openFacebook(_ sender: Any) {
        openBrowser(mUrl: (host?.socialMedia?.facebook!)!)
    }
    @IBAction func openWhatsapp(_ sender: Any) {
        if host?.contact != nil
        {if let url = URL(string: "tel://\(host?.contact)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }}
    }
    @IBAction func openInsta(_ sender: Any) {
        openBrowser(mUrl: (host?.socialMedia?.instagram!)!)
    }
    
    @IBAction func onViewOfferPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showViewOfferSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showViewOfferSegue") {
            //get a reference to the destination view controller
            let controller = segue.destination as! OffersViewController
            controller.clientId = self.client_id
            controller.clientName=self.clientName
        }
        if (segue.identifier == "addressSegue") {
            //get a reference to the destination view controller
            let controller = segue.destination as! AddressViewController
            controller.addr = self.host?.branches ?? []
            controller.clientName = self.clientName
        }
    }
    @IBAction func openMultipleAddr(_ sender: Any) {
        performSegue(withIdentifier: "addressSegue", sender: self)
    }
}
extension HostViewController: UIScrollViewDelegate{
    
    func reloadCollectionView(_ cData: Client){
        DispatchQueue.main.async{
            print("Refreshing data")
            self.host = cData
            self.setupView()
            self.desc.sizeToFit()
       
        }
    }
    func openMapForPlace(name:String,lat:String?,lng:String?) {
        var  url = "http://maps.apple.com/"
        url += name.replacingOccurrences(of: " ", with: "+")
        if lat != nil && lng != nil {
            url += "&sll\(String(describing: lat!)),\(String(describing: lng!))&t=s"
        }
        
        
        let mUrl=URL(string:url)
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(mUrl!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(mUrl!)
        }
        
    }
    func setupView(){
       
      let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        if let img = host?.imgUrl{
            if img.count == 0 {
                let imageView = UIImageView()
                let x:CGFloat = 0
                imageView.frame = CGRect(x: x, y: 0, width: scrollViewWidth, height: scrollViewHeight)
                imageView.contentMode = .scaleAspectFill
                imageView.addPlaceHolder()
                scrollView.contentSize.width = scrollView.frame.size.width * CGFloat( 1)
                scrollView.addSubview(imageView)
            }
        for  n in 0..<img.count{
            let imageView = UIImageView()
            let x = scrollViewWidth * CGFloat(n)
            imageView.frame = CGRect(x: x, y: 0, width: scrollViewWidth, height: scrollViewHeight)
            imageView.contentMode = .scaleAspectFill
             let url = URL(string: img[n])
            imageView.kf.setImage(with: url)
                       scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(n + 1)
            scrollView.addSubview(imageView)
    
        }
//            self.pageControl.currentPage = 0
            
            if host?.socialMedia?.facebook != ""{
                facbookB.isHidden = false
            }else{
                facbookB.isHidden = true
            }
            if host?.socialMedia?.instagram != ""{
                instaB.isHidden = false
            }else{
                instaB.isHidden = true
            }
            desc.text=host?.descriptionField
            if let br = host?.branches{
            if br.count > 1 {
            self.arrow.isHidden = false
            self.address.text = "Multiple Locations"
            }else{
                   self.arrow.isHidden = true
               self.address.text = br[0].address
                }
            
                let dateWeekday = "\(date12hrFormat(br[n].timing?.weekdays?.opening ?? "")) - \(date12hrFormat(br[n].timing?.weekdays?.closing ?? ""))"
                let dateWeekend = "\(date12hrFormat(br[n].timing?.weekends?.opening ?? "")) - \(date12hrFormat(br[n].timing?.weekends?.closing ?? ""))"
                // self.colorL.text = host.
                self.weekDayT.text = dateWeekday
                self.weekEndT.text = dateWeekend
                
            }
            
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
     
    }
    }
    func date12hrFormat(_ dateStr :String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        let date = dateFormatter.date(from: dateStr)
        
        dateFormatter.dateFormat = "h:mm a"
        let date12 = dateFormatter.string(from: date!)
        
        return date12
    }
    func openBrowser( mUrl: String){
        var url = mUrl
        
        if !url.contains("https://"){
            url = "https://"+url
        }
        let mUrl=URL(string:url)
    
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(mUrl!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(mUrl!)
        }
    }
    
    func getHostDetails(_ cid: String) {
        let preferences = UserDefaults.standard
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        let params = ["access_token": authToken ?? ""] as [String:Any]
        
        Alamofire.request(Constant().baseURL+"clients/\(cid)",method: .get, parameters: params, encoding: URLEncoding.queryString).responseJSON{ response in
            print("URL ", response.request ?? "")
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let client = hostDetails(JSONString: utf8Text)
                    let code = client?.code
               
                    if code == 200{
                        print("Got host data successfully")
                        self.reloadCollectionView((client?.client)!)
                    }else{
                        print("Unable to get host data")
                    }
                }
            case .failure:
                print("Error Ocurred in getting host data!")
            }
        }
    }
}
