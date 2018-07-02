import UIKit
import Alamofire
import NVActivityIndicatorView

extension UIViewController {
    
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
    func showAlert(title:String,msg:String){
        let alert = UIAlertController(style: .alert)
        alert.set(title:title, font: .systemFont(ofSize: 20), color: #colorLiteral(red: 0.1019607843, green: 0.1254901961, blue: 0.1607843137, alpha: 1))
             alert.set(message: msg, font: .systemFont(ofSize: 16), color: #colorLiteral(red: 0.1019607843, green: 0.1254901961, blue: 0.1607843137, alpha: 0.8329676798))
            alert.addAction(image: nil, title: "Cancel", color: #colorLiteral(red: 1, green: 0.4549019608, blue: 0.4588235294, alpha: 1), style: .default, isEnabled: true, handler: {(alert: UIAlertAction!) in
            });
        
        self.present(alert, animated: true, completion: nil)
    }
    func noInternetDialog(function: @escaping () -> (), cancellable:Bool){
        errorDialog(function: function, title: "No Internet", msg: "Your device isn't connected to internet please retry.", cancellable: cancellable) }
    func noInternetDialog(function: @escaping () -> ()){
        self.noInternetDialog(function: function, cancellable: false)
    }
    func noInternetDialogCancellable(function: @escaping () -> ()){
        self.noInternetDialog(function: function, cancellable: true)
    }
    func errorDialog(function: @escaping () -> (),title:String,msg:String?, cancellable:Bool){
        let alert = UIAlertController(style: .alert)
        alert.set(title:title, font: .systemFont(ofSize: 20), color: #colorLiteral(red: 0.1019607843, green: 0.1254901961, blue: 0.1607843137, alpha: 1))
        if msg != nil
        {        alert.set(message: msg, font: .systemFont(ofSize: 16), color: #colorLiteral(red: 0.1019607843, green: 0.1254901961, blue: 0.1607843137, alpha: 0.8329676798))}
        else{
            alert.set(message: "Error occured", font: .systemFont(ofSize: 16), color: #colorLiteral(red: 0.1019607843, green: 0.1254901961, blue: 0.1607843137, alpha: 0.8329676798))
        }
        alert.addAction(image: nil, title: "Retry", color: #colorLiteral(red: 0.3923987448, green: 0.4124389887, blue: 0.4334673882, alpha: 1), style: .default, isEnabled: true, handler: {(alert: UIAlertAction!) in
            function()
        });
        if cancellable{
            alert.addAction(image: nil, title: "Cancel", color: #colorLiteral(red: 1, green: 0.4549019608, blue: 0.4588235294, alpha: 1), style: .default, isEnabled: true, handler: {(alert: UIAlertAction!) in
            });
        }
        self.present(alert, animated: true, completion: nil)
    }
    func errorDialog(function: @escaping () -> (),msg:String?, cancellable:Bool){
        errorDialog(function: function, title: "Something went wrong!", msg: msg, cancellable: cancellable)
    }
    func errorDialog(function: @escaping () -> (),msg:String?){
        errorDialog(function: function, title: "Something went wrong!", msg: msg, cancellable: false)
    }
    func errorDialogCancellabel(function: @escaping () -> (),msg:String?){
        errorDialog(function: function, title: "Something went wrong!", msg: msg, cancellable: true)
    }
    func errorDialog(function: @escaping () -> ()){
        errorDialog(function: function, title: "Something went wrong!", msg: "Error Occured", cancellable: true)
    }
    
    func refreshToken(function: @escaping () -> ()){
        //Add api
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        if Connectivity.isNotConnectedToInternet{
            noInternetDialog {
                self.refreshToken {
                    function()
                }
                
            }
            
        }
        else{
            let preferences = UserDefaults.standard
            let refToken = preferences.string(forKey: "refToken")
            let uid=preferences.string(forKey: "ID")
            if refToken == nil{
                self.signOut()
            }
            let param = ["ref_token": refToken!]
            Alamofire.request(Constant().baseURL+"users/\(String(describing: uid))/refresh",method: .get, parameters: param, encoding: URLEncoding.queryString).responseJSON { response in
                print(response.request ?? "")
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let refTokenRes = RefTokenRes(JSONString: utf8Text)
                        let code = refTokenRes?.code
                        
                        if code == 200{
                            print("Token Refreshed")
                            preferences.set(refTokenRes?.authToken, forKey: "AUTHTOKEN")
                            preferences.set(refTokenRes?.refToken, forKey: "refToken")
                            function()
                            
                            
                        }else{self.apiErrorHandler(code: code, msg: "Please sign in again.", function: {
                            self.signOut()
                            
                            
                        })
                            print("Unable to search")
                        }
                    }
                case .failure:self.errorDialog(function: {
                    self.signOut()
                    
                })
                print("Error Ocurred in getting profile data!")
                }
            }
            
        }
    }
    func signOut(){
        clearPrefs()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainLoginVC") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }
    func apiErrorHandler(code:Int?, msg:String?,function: @escaping () -> ()){
        if code==405{
            self.refreshToken {
                function()
            }
        }
        else{
            self.errorDialog(function: {
                //recall function
                function()
                
            }, msg: msg)
        }
    }
    func clearPrefs(){
        let preferences = UserDefaults.standard
        preferences.removeObject(forKey: "IS_LOGIN")
        preferences.removeObject(forKey: "contact")
        preferences.removeObject(forKey: "AUTHTOKEN")
        preferences.removeObject(forKey: "name")
        preferences.removeObject(forKey: "refToken")
        preferences.removeObject(forKey: "gender")
        preferences.removeObject(forKey: "dob")
        preferences.removeObject(forKey: "email")
        preferences.removeObject(forKey: "isBrowseOnly")
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to delete data!")
        }else{
            print("Data deleted!")
        }
    }
    func apiErrorHandlerCancellable(code:Int?, msg:String?,function: @escaping () -> ()){
        if code==405{
            self.refreshToken {
                function()
            }
        }
        else{
            self.errorDialogCancellabel(function: {
                //recall function
                function()
                
            }, msg: msg)
        }
    }
    
}
