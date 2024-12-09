//
//  ViewController.swift
//  CDData
//
//  Created by admin on 27/11/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var textid: UITextField!
    
    @IBOutlet weak var txtname: UITextField!
    
    @IBOutlet weak var emiltxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addbtn(_ sender: Any) {
        
        let uid=Int(textid.text!)!
        let uname=txtname.text!
        let uemail=emiltxt.text!
        
        let newuser=UserModel(uid:Int(uid), uname: uname, uemail: uemail)
        addcoredata(userobject: newuser)
    }
    
    
    @IBAction func nextscreenbtn(_ sender: Any) {
        performSegue(withIdentifier: "GoToNext", sender: self)
    }
    
    func addcoredata(userobject:UserModel){
        guard let delegate=UIApplication.shared.delegate as? AppDelegate else
        {return }
        
        let managecontext=delegate.persistentContainer.viewContext
        
        guard let userEntity=NSEntityDescription.entity(forEntityName: "Users", in: managecontext) else{
            return
        }
        
        let user=NSManagedObject(entity: userEntity, insertInto: managecontext)
        
        user.setValue(userobject.uid, forKey:"id")
        user.setValue(userobject.uname, forKey: "name")
        user.setValue(userobject.uemail, forKey: "email")
        
        
        do{
            try
            managecontext.save()
            debugPrint("Core data saved")
        }
        catch let err as NSError {
                    debugPrint("could not save to CoreData. Error: \(err)")
        }
    }
    

}

