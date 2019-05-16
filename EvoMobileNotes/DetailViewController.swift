//
//  DetailViewController.swift
//  EvoMobileNotes
//
//  Created by mac on 5/15/19.
//  Copyright © 2019 sashabalabon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTextView: UITextView!
    var text = ""
    var masterView: NotesListViewController!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTextView.text = text
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem = shareButton
        
    }
    @objc func share() {
    }
    
    func setText(text: String) {
        self.text = text
        if isViewLoaded {
            detailTextView.text = text
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        masterView.newRowText = detailTextView.text
        detailTextView.resignFirstResponder()
    }
    
}
