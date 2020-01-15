//
//  ViewControllerCamera.swift
//  Sofuber
//
//  Created by Beatriz Lopez Del Moral Garcia Jimenez on 15/1/20.
//  Copyright © 2020 BEATRIZ LOPEZ DEL MORAL GARCIA JIMENEZ. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewControllerCamera: UIViewController, G8TesseractDelegate {
    
    @IBOutlet weak var textImage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // aquí vemos los idiomas que le podemos incluir
        //https://github.com/tesseract-ocr/tessdata 
        if let tesseract = G8Tesseract(language: "eng+spa_old+spa"){
            tesseract.delegate = self
            tesseract.image = UIImage(named: "demoText")?.g8_blackAndWhite()
            tesseract.recognize()
            textImage.text = tesseract.recognizedText
        }
    }
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition Progress\(tesseract.progress)&")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
