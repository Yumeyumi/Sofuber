//
//  ViewController.swift
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
import GoogleSignIn
import CoreData

class ViewController: UIViewController, GIDSignInUIDelegate {
    var userCore: String?
    var passCore: String?
    
    @IBOutlet weak var txtUser: UITextField?
    @IBOutlet weak var txtPass: UITextField?
    @IBOutlet weak var signInButton: UIButton?
    @IBOutlet weak var signUpButton: UIButton?
    var user:User?
    @IBOutlet weak var signInButtonGoogle: GIDSignInButton?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        //Ver si el usuario de coreData es usuario y entrar directamente
        compareUserCoreToSignIn()
        
    }
    //Acción botón para iniciar sesión google
    @IBAction func onClickSignInGoogle(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
        showToast(message: "Has iniciado sesión con google")
        print("hola")
    }
    
    //Acción botón para iniciar sesión cuenta normal
    @IBAction func onClickSignIn(_ sender: UIButton){
        
        if(txtUser?.text == "" || txtPass?.text == "" ){
            showToast(message: "Debes rellenar todos los apartados")
        }else {
            signIn(mail: (txtUser?.text)!,password: (txtPass?.text)!)
            //Añadir el usuario al coreData
            addCoreData(user: (txtUser?.text)!, pass: (txtPass?.text)!)
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Agrego al coreData
    func addCoreData(user:String, pass:String)  -> Bool{
        PersistenceService.deleteAllCodesRecords()
        let users = UserCoreData(context: PersistenceService.context)
        print(user)
        print(pass)
        users.setValue(user, forKey: "user")
        users.setValue(pass, forKey: "pass")
        return PersistenceService.saveContext()
    }
    //Compruebo si el usuario está ya
    func compareUserCoreToSignIn(){
        
        let managetContext = PersistenceService.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCoreData")
        do {
            let result = try managetContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                userCore =  data.value(forKey: "user") as? String
                passCore = data.value(forKey: "pass") as? String
                print(userCore)
                print(passCore)
            }
        } catch{
            print("Fail")
        }
        guard let user = userCore , let pass = passCore else {return}
        signIn(mail: user, password: pass)
    }
    
    // Iniciar sesion firebase
    func signIn(mail: String , password: String){
        Auth.auth().signIn(withEmail: mail, password: password) { [weak self] authResult, error in
            if error == nil {
                self?.user = Auth.auth().currentUser
                
                //Voy a la ventana de Mapa
                DispatchQueue.main.async{ self?.performSegue(withIdentifier: "Camera", sender: self) }
            } else {
                print(error)
            }
        }
    }
    
    //Crear una colleción para Firebase
    func createCollection(name: String, last :String, born : Int){
        user = Auth.auth().currentUser
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
}

//Extensión del toask, ventana emergente de avisos
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }


