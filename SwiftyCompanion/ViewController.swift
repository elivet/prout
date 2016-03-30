//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Elise LIVET on 3/18/16.
//  Copyright © 2016 Elise LIVET. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let test = SwiftCompanionModel()

    @IBOutlet weak var loginTextField: UITextField!
    
    var login:String = ""
    var access_token : String?
    var email : String?
    var phone : String?
    var cursus : NSArray?
    var level : Double?
    var skills : NSArray?
    var projects : NSArray?
    var photoURL : String?
    var location : String?
    var correction_point : Int?
    var pool_year : String?
    var wallet : Int?
    var displayname : String?
    var grade : String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateInfo), name: "infoOK", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.popUp), name: "wrongLogin", object: nil)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterTapped(sender : AnyObject) {
        self.login = loginTextField.text!
        print("self.login " + self.login)
        if (self.login.containsString(" ")){
            NSNotificationCenter.defaultCenter().postNotificationName("wrongLogin", object: self)
        }
        else {
            self.connectToApi(self.getToken)   
        }
    }
    
    func updateInfo(){
        dispatch_async(dispatch_get_main_queue(), {
        super.performSegueWithIdentifier("showProfileSegue", sender: self)
       })

    }
    
    func    popUp(){
        dispatch_async(dispatch_get_main_queue(), {
            self.displayAlertDialog("Error", message: "login not found")
        })
    }
    
    func displayAlertDialog(title: String, message: String)
    {
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(
            UIAlertAction(title: "Close", style: .Default, handler:
                {
                    (action: UIAlertAction!) in
                }
            )
        )
        presentViewController(refreshAlert, animated: false, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProfileSegue" {
            let secondViewController = segue.destinationViewController as! SecondViewController
            secondViewController.login = self.login
            secondViewController.email = self.email
            secondViewController.phone = self.phone
            secondViewController.location = self.location
            secondViewController.correction_point = self.correction_point
            secondViewController.pool_year = self.pool_year
            secondViewController.wallet = self.wallet
            secondViewController.displayname = self.displayname
            secondViewController.grade = self.grade
            secondViewController.level = self.level
            secondViewController.skills = self.skills
            secondViewController.projects = self.projects
            secondViewController.photoURL = self.photoURL
        }
    }
    
    
    
    func getToken(access_token: String ) -> Void{
        self.access_token = access_token
        print(self.access_token)
        if (self.access_token != nil) {
            getUserInfo(getInfo)
        }
    }
    
    func getInfo(jsonDictionary: NSDictionary ){
        if (jsonDictionary["email"] != nil){
            self.email = jsonDictionary["email"] as! String
            print(self.email)
        }
        if (jsonDictionary["phone"] != nil){
            self.phone = jsonDictionary["phone"] as? String
            print(self.phone)
        }
        if (jsonDictionary["image_url"] != nil){
            self.photoURL = jsonDictionary["image_url"] as! String
            print(self.photoURL)
        }
        if (jsonDictionary["location"] != nil){
            self.location = jsonDictionary["location"] as! String
            print(self.location)
        }
        if (jsonDictionary["correction_point"] != nil){
            self.correction_point = jsonDictionary["correction_point"] as! Int
            print(self.correction_point)
        }
        if (jsonDictionary["pool_year"] != nil){
            self.pool_year = jsonDictionary["pool_year"] as! String
            print(self.pool_year)
        }
        if (jsonDictionary["wallet"] != nil){
            self.wallet = jsonDictionary["wallet"] as! Int
            print(self.wallet)
        }
        if (jsonDictionary["displayname"] != nil){
            self.displayname = jsonDictionary["displayname"] as! String
            print(self.displayname)
        }
        if (jsonDictionary["cursus"] != nil){
            self.cursus = jsonDictionary["cursus"] as! NSArray
            if (self.cursus![0]["level"] != nil){
                self.level = self.cursus![0]["level"] as! Double
                print(self.level)
            }
            if (self.cursus![0]["grade"] != nil){
                self.grade = self.cursus![0]["grade"] as! String
                print(self.grade)
            }
            if (self.cursus![0]["skills"] != nil){
                self.skills = self.cursus![0]["skills"] as! NSArray
                print(self.skills)

            }
            if (self.cursus![0]["projects"] != nil){
                self.projects = self.cursus![0]["projects"] as! NSArray
                print(self.projects)
                
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("infoOK", object: self)
    }
    
    func getUserInfo(callback:(NSDictionary) -> Void){
        let getEndpoint: String = "https://api.intra.42.fr/v2/users/" + self.login + "?access_token=" + self.access_token!
        print("GETENDPOINT GETUSERINFO: " + getEndpoint)
        let url = NSURL(string: getEndpoint)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    print(response)
                    NSNotificationCenter.defaultCenter().postNotificationName("wrongLogin", object: self)
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
//                print("GET: " + postString)
                do{
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    print("GETSUCCESS")
                    callback(jsonDictionary)
                }
                catch {
                    print("fail")
                }
            }
            
        }).resume()
    }
    
    func connectToApi(callback:(String) -> Void){
        let UID = "9e0b4db1b1a58b246b4bf54367576559b13525b0da544821dd2dfbfb7213e375"
        let secret = "7e04c3327862bf83c0383a57c5e40cfded9c6bb56d8f53fbd2391f292404d984"
        let postEndpoint: String = "https://api.intra.42.fr/oauth/token"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["grant_type":"client_credentials", "client_id":UID, "client_secret":secret]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            //            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    print(response)
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                //                print("POST: " + postString)
                do{
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if (jsonDictionary["access_token"] != nil){
                        let access_token = jsonDictionary["access_token"] as! String
                        print(access_token)
                        callback(access_token)
                    }
                }
                catch {
                    print("fail")
                }
            }
            
        }).resume()
        
    }


}

