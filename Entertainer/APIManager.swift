//
//  APIManager.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 20/12/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView


protocol APIManagerDelegate: class {
    func reloadCollectionView(_ cData: [CategoriesToSend],_ sData: [SubCategory],_ rData: [[Result]],_ partner: Int)
    func errorHandler(code:Int?, msg:String?,function: @escaping () -> ())
    func errorHandler(function: @escaping () -> ())
}
class APIManager : NSObject,NVActivityIndicatorViewable{
     weak var delegate : APIManagerDelegate?
   
    func getClient(_ uid: String,_ authToken:String){
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
    
        let param = ["access_token": authToken]
 
     print(Constant().baseURL+"search/\(uid)/home")
        Alamofire.request(Constant().baseURL+"search/\(uid)/home",method: .get, parameters: param, encoding: URLEncoding.queryString).responseJSON { response in
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            switch response.result {
                    case .success:
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let user = User(JSONString: utf8Text)
                            let code = user?.code
                            
                            if code == 200{
                                print("Got client data successfully")
                                print("Categories Count", user!.categoriesToSend!.count)
                                self.delegate?.reloadCollectionView((user?.categoriesToSend)!,(user?.subCategories)!,(user?.results)!,(user?.partners)!)
                            }else{
                                self.delegate?.errorHandler(code: code, msg: user?.msg, function: {
                                    self.self.getClient(uid, authToken)
                                })
                            }
                }
            case .failure:
                self.delegate?.errorHandler( function: {
                self.self.getClient(uid, authToken)
            })
                print("Error Ocurred in getting client data!")
            }
        }
    }
}


