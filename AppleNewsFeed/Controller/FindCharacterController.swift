//
//  WebViewController.swift
//  AppleNewsFeed
//
//  Created by kristine.lazdovska on 11/08/2021.
//

import UIKit
import WebKit

protocol ChangeCharacterDelegate {
    func userEnterCharacterName(character: String)
}

class FindCharacterController: UIViewController {
    
    var delegate: ChangeCharacterDelegate?
    
    @IBOutlet weak var characterTextField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func getCharacterTapped(_ sender: Any) {
        guard let characterName = characterTextField.text else {return}
        
        if !characterName.isEmpty {
            delegate?.userEnterCharacterName(character: characterName)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
