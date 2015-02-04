//
//  ViewController.swift
//  ios-swift-demo
//
//  Created by Dominik Pich on 04/02/15.
//
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let qrCode = QREncoder.imageForString("DEMODEMODEMO")
        let imageView = self.view as UIImageView
                
        imageView.image = qrCode
    }
}

