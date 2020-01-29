//
//  ViewControllerCamera.swift
//  Sofuber
//
//  Created by Beatriz Lopez Del Moral Garcia Jimenez on 15/1/20.
//  Copyright © 2020 BEATRIZ LOPEZ DEL MORAL GARCIA JIMENEZ. All rights reserved.
//

import UIKit
import TesseractOCR
import AVFoundation

class ViewControllerCamera: UIViewController, G8TesseractDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
 
    let imagePicker: UIImagePickerController = UIImagePickerController()
    @IBOutlet weak var textImage: UITextView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var segmentlenguage: UISegmentedControl!
   
    
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
    
    @IBAction func takePhoto(_ sender: UIButton){
        print("paso1")
        //Si la camara está activa
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                //que no pueda editar la imagen
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                present(imagePicker,animated: true,completion: nil)
                print("paso")
        }
    }
    }
    
    @IBAction func textToSpeech(_ sender: UIButton){
        var lang: String = "en-US"
        switch segmentlenguage.selectedSegmentIndex {
        case 0:
            lang = "en-US"
        case 1:
            lang = "es-ES"
        default:
            lang = "es-ES"
        }
        self.readMe(myText: textImage.text! , myLang: lang)
    }
    
    func readMe(myText: String, myLang: String){
        let utterance = AVSpeechUtterance(string: myText)
        //seleccionamos la entonación del idioma
        utterance.voice = AVSpeechSynthesisVoice(language: myLang)
        //Indico la velocidad de lectura
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        //Le pasamos al sistetizador nuestro texto con la configuración y
        //se escuchará
        synthesizer.speak(utterance)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageselected: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            image.image = imageselected
        }
        //Quitamos la animación de la camara
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

