//
//  ViewControllerCamera.swift
//  Sofuber
//
//  Created by Beatriz Lopez Del Moral Garcia Jimenez on 15/1/20.
//  Copyright © 2020 BEATRIZ LOPEZ DEL MORAL GARCIA JIMENEZ. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewControllerCamera: UIViewController, G8TesseractDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
 
    let imagePicker: UIImagePickerController = UIImagePickerController()
    @IBOutlet weak var textImage: UITextView!
    @IBOutlet weak var image: UIImageView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        // aquí vemos los idiomas que le podemos incluir
        //https://github.com/tesseract-ocr/tessdata 
        if let tesseract = G8Tesseract(language: "eng+spa_old+spa"){
            tesseract.delegate = self
            
        //cogemos la imagen formato blanco y negro
            tesseract.image = UIImage(named: "demoText")?.g8_blackAndWhite()
            //Inspeccionamos
            tesseract.recognize()
            //De lo recogido en text lo ponemos en la variable
            textImage.text = tesseract.recognizedText
        }
      
    
    }
    //Funcion para saber el progreso de reconocimiento
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition Progress\(tesseract.progress)&")
    }
    @IBAction func takePhoto(_ sender: AnyObject){
        //Si la camara está activa
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                //que no pueda editar la imagen
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                present(imagePicker,animated: true,completion: nil)
        }
    }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageselected: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            image.image = imageselected
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

