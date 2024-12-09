//
//  DetailVC.swift
//  CDData
//
//  Created by admin on 27/11/24.
//

import UIKit
import CoreData

class DetailVC: UIViewController{
    
    
    
    var saveUsers:[UserModel]=[]
    
    var selecteduser:UserModel!
    
    
    @IBOutlet weak var tablevc: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        readfromcoredata()
        tablevc.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptable()
        readfromcoredata()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToUpdate"{
            if let update = segue.destination as? UpdateVC{
                update.getuser=selecteduser
            }
        }
    }
    
    func deletecd(Users:UserModel){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        
        let managecontext=delegate.persistentContainer.viewContext
        let fetchrequest=NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        fetchrequest.predicate=NSPredicate(format: "name=%@", Users.uname)
        
        
        do {
            let fetchres=try managecontext.fetch(fetchrequest)
            let objToDelete=fetchres[0] as! NSManagedObject
            managecontext.delete(objToDelete)
            
         try managecontext.save()
        print("user deleted successfully")
        
    } catch let err as NSError {
        print("Somthing went wrong while deleting \(err)")
    }
}
    
    func readfromcoredata(){
        guard let delegate=UIApplication.shared.delegate as? AppDelegate else
        {return }
        
        let managecontext=delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        do{
            let res = try managecontext.fetch(fetchRequest)
            debugPrint("fetch from CD sucessfully")
            saveUsers = []

            for data in res as! [NSManagedObject]{
                
                let uid=data.value(forKey: "id") as! Int32
                let uname=data.value(forKey: "name") as! String
                let uemail=data.value(forKey: "email") as! String
                saveUsers.append(UserModel(uid: Int(uid), uname: uname, uemail: uemail))
            }
            
        }
        catch let err as NSError {
            debugPrint("could not save to CoreData. Error: \(err)")
        }
        
    }
    
}
    extension DetailVC: UITableViewDataSource, UITableViewDelegate{
        
        func setuptable(){
            tablevc.dataSource=self
            tablevc.delegate=self
            tablevc.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            
            
            
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return saveUsers.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell=tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
            cell.idlable.text=String(saveUsers[indexPath.row].uid)
            cell.namelable.text=saveUsers[indexPath.row].uname
            cell.emaillable.text=saveUsers[indexPath.row].uemail
            return cell
            
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
        }
        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let delete=UIContextualAction(style: .destructive, title: "delete"){action,source,completion in
                self.saveUsers.remove(at: indexPath.row)
                
                let userToDelete = self.saveUsers[indexPath.row]
                self.deletecd(Users: userToDelete)
             
                
                self.tablevc.reloadData()
            }
            let configure=UISwipeActionsConfiguration(actions: [delete])
            configure.performsFirstActionWithFullSwipe=false
            return configure
            
            
            
        }
        
    
        
        func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let update=UIContextualAction(style: .normal, title: "Update") { (action, view, completionHandler )in
                self.selecteduser=self.saveUsers[indexPath.row]
                self.performSegue(withIdentifier: "GoToUpdate", sender: self)
                
                completionHandler(true)
                
            }
            
            update.backgroundColor = .systemBlue
    
           let updateAction=UISwipeActionsConfiguration(actions: [update])
            return updateAction
                
            }
        }
    


    

