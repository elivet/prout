//
//  SecondViewController.swift
//  SwiftyCompanion
//
//  Created by Elise LIVET on 3/18/16.
//  Copyright © 2016 Elise LIVET. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var loginLabel: UILabel!

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var correctionPointLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var poolYearLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var levelProgressView: UIProgressView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var skillsTableView: UITableView!
    @IBOutlet weak var projectsTableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet var viewUIView: UIView!
    
    var login:String = ""
    var access_token : String?
    var email : String?
    var phone : String?
    var location : String?
    var grade : String?
    var correction_point : Int?
    var pool_year : String?
    var wallet : Int?
    var displayname : String?
    var cursus : NSArray?
    var level : Double? = 0
    var skills : NSArray?
    var projects : NSArray?
    var photoURL : String?
    
    let backgroundURL : String = "https://profile.intra.42.fr/assets/background_login-a4e0666f73c02f025f590b474b394fd86e1cae20e95261a6e4862c2d0faa1b04.jpg"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        load_image(backgroundURL, imageView: backgroundImageView)
        loginLabel.text = self.displayname! + " - " + self.login
        emailLabel.text = self.email
        phoneLabel.text = self.phone
        locationLabel.text = self.location
        correctionPointLabel.text = "Correction points: " + String(self.correction_point!)
        poolYearLabel.text = self.pool_year
        walletLabel.text = "Wallet: " + String(self.wallet!)
        if (self.level != nil){
           let lvlperc = String(self.level!).componentsSeparatedByString(".")
           levelLabel.text = "level " + lvlperc[0] + " - " + lvlperc[1] + "%"
            levelProgressView.setProgress(Float(lvlperc[1])!/100, animated: true)
         }
        self.skillsTableView.delegate = self;
        self.skillsTableView.dataSource = self;
        self.projectsTableView.delegate = self;
        self.projectsTableView.dataSource = self;
        load_image(photoURL!, imageView: photoImageView)
        viewUIView.bringSubviewToFront(loginLabel)
        viewUIView.bringSubviewToFront(emailLabel)
        viewUIView.bringSubviewToFront(phoneLabel)
        viewUIView.bringSubviewToFront(locationLabel)
        viewUIView.bringSubviewToFront(correctionPointLabel)
        viewUIView.bringSubviewToFront(poolYearLabel)
        viewUIView.bringSubviewToFront(walletLabel)
        viewUIView.bringSubviewToFront(levelLabel)
        viewUIView.bringSubviewToFront(photoImageView)
        viewUIView.bringSubviewToFront(levelProgressView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func load_image(urlString:String, imageView: UIImageView)
    {
        
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    if imageView == self.photoImageView {
                        self.photoImageView.image = UIImage(data: data!)
                    }
                    else if imageView == self.backgroundImageView {
                        self.backgroundImageView.image = UIImage(data: data!)
                    }
                }
        })
        
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("numberOfSectionsInTableView")
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView1: " + "\(skills?.count)")
        if (tableView == skillsTableView){
            return (skills?.count)!
        }
        else {
            return (projects?.count)!
        }
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("tableView2")
        if (tableView == skillsTableView){
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cellIdentifier = "SkillsTableViewCell"
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SkillsTableViewCell
            
            // Fetches the appropriate skill for the data source layout.
            let skill: NSDictionary = skills![indexPath.row] as! NSDictionary
            
            cell.nameLabel.text = String(skill["name"]!)
            if (String(skill["level"]!).containsString(".")){
                let lvlperc = String(skill["level"]!).componentsSeparatedByString(".")
                cell.levelLabel.text = "level " + lvlperc[0] + " - " + lvlperc[1] + "%"
                cell.percentageProgressView.setProgress(Float(lvlperc[1])!/100, animated: true)

            }
            else {
                cell.levelLabel.text = "level " + String(skill["level"]!) + " - 0%"
                cell.percentageProgressView.setProgress(0/100, animated: true)
            }
            return cell
        }
        else {
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cellIdentifier = "ProjectsTableViewCell"
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ProjectsTableViewCell
            
            // Fetches the appropriate skill for the data source layout.
            let project: NSDictionary = projects![indexPath.row] as! NSDictionary
            
            cell.nameLabel.text = String(project["name"]!)
            return cell
        }
        
    }
    
    
}