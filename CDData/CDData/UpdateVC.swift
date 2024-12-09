//
//  UpdateVC.swift
//  CDData
//
//  Created by admin on 07/12/24.
//

import UIKit
import CoreData

class UpdateVC: UIViewController {

    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var nametxt: UITextField!
    
    @IBOutlet weak var idtxt: UITextField!
    var getuser:UserModel!
    override func viewDidLoad() {
        super.viewDidLoad()
       setdata()

        // Do any additional setup after loading the view.
    }
    
    func setdata()
    {
        emailtxt.text=getuser.uemail
        nametxt.text=getuser.uname
    }
    
    func UpdateCD(atId: Int32, updateduser: UserModel){
        
        guard let delegate=UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managecontext=delegate.persistentContainer.viewContext
        
        let fetchrequest=NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        fetchrequest.predicate = NSPredicate(format: "id = %d", atId)
        
        do {
            
            let rawdata=try managecontext.fetch(fetchrequest)
            
            let updata=rawdata[0] as! NSManagedObject
            updata.setValue(updateduser.uname, forKey: "name")
            updata.setValue(updateduser.uemail, forKey: "email")
            
            try managecontext.save()
        } catch  let err as NSError {
            print("Somthing went wrong while Updating \(err)")
        }
        
        
        
    }
    
    @IBAction func updatebtn(_ sender: Any) {
        
        
        var upemail=emailtxt.text!
        var upname=emailtxt.text!
      
        UpdateCD(atId: Int32(getuser.uid), updateduser: UserModel(uid: getuser.uid, uname: upname, uemail: upemail))
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
