//
//  ViewControlerRegister.swift
//  Sofuber
//
//  Created by Beatriz Lopez Del Moral Garcia Jimenez on 9/1/20.
//  Copyright © 2020 BEATRIZ LOPEZ DEL MORAL GARCIA JIMENEZ. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FirebaseCore

class ViewControlerRegister: UIViewController {
    
    @IBOutlet weak var txtUser: UITextField?
    @IBOutlet weak var txtPass: UITextField?
    @IBOutlet weak var txtname: UITextField?
    @IBOutlet weak var txtlast: UITextField?
    @IBOutlet weak var txtborn: UITextField?
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //Acción  de registrar
    @IBAction func onClickSignUp(_ sender: UIButton){
        if(txtUser?.text == "" || txtPass?.text == "" || txtname?.text == "" || txtlast?.text == "" || txtborn?.text == "" ){
            showToast(message: "Debes rellenar todos los apartados")
        }else if (Int((txtborn?.text)!) == nil) {
            showToast(message: "El año debe ser númerico")
        }else {
            createUser(mail: (txtUser?.text)!, password: (txtPass?.text)!, name: (txtname?.text)!, last: (txtlast?.text)!, born: Int((txtborn?.text)!)!)
        }
    }
    
    //Crear un user en Firebase
    func createUser(mail: String , password: String, name: String, last :String, born : Int) {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            if error == nil {
                self.user = Auth.auth().currentUser
                self.createCollection(name: name, last: last, born: Int((born)))
                //Agrego al coreData
                self.addCoreData(user: (self.txtUser?.text)!, pass: (self.txtPass?.text)!)
                DispatchQueue.main.async{ self.showToast(message: "¡Te has registrado!") }
                //Voy a la ventana de Mapa
                DispatchQueue.main.async{ self.performSegue(withIdentifier: "NavTabMap", sender: self) }
            } else {
                
                self.showToast(message: (error?.localizedDescription)!)
                
            }
        }
    }
    
    //Crear una colleción para Firebase
    func createCollection(name: String, last :String, born : Int){
        
        Firestore.firestore().collection("users").document((user?.uid)!).setData([
            "name": name,
            "last": last,
            "born": born
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
    
    //Agrego al coreData
    func addCoreData(user:String, pass:String)  -> Bool{
        PersistenceService.deleteAllCodesRecords()
        let users = UserCoreData(context: PersistenceService.context)
        users.setValue(user, forKey: "user")
        users.setValue(pass, forKey: "pass")
        return PersistenceService.saveContext()
    }
    
    
}
