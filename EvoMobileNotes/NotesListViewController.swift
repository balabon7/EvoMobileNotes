//
//  NotesListViewController.swift
//  EvoMobileNotes
//
//  Created by mac on 5/15/19.
//  Copyright © 2019 sashabalabon. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController, UITableViewDataSource  {


    @IBOutlet weak var noteTableView: UITableView!
    
    var textData = ["Item 1", "Item 2", "Item 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteTableView.dataSource = self
        self.title = "List of notes"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        self.navigationItem.rightBarButtonItem = addButton
        loadingData()
    }
    
    @objc func addNewNote(){
        let name = "Item \(textData.count + 1)"
        textData.insert(name, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        noteTableView.insertRows(at: [indexPath], with: .automatic)
        
        saveData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textData.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        textData.remove(at: indexPath.row)
        noteTableView.deleteRows(at: [indexPath], with: .fade)
        
        saveData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = textData[indexPath.row]
        
        return cell!
    }
    
    func saveData() {
        UserDefaults.standard.set(textData, forKey: "text")
    }

    func loadingData() {
        if let loadedData = UserDefaults.standard.value(forKey: "text") {
            textData = loadedData as! [String]
            noteTableView.reloadData()
        }
        
    }

    
}
