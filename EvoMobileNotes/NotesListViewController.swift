//
//  NotesListViewController.swift
//  EvoMobileNotes
//
//  Created by mac on 5/15/19.
//  Copyright © 2019 sashabalabon. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var noteTableView: UITableView!
    
    var textData = [String]()
    var fileURL: URL!
    var selectedRow = -1
    
    var newRowText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTableView.dataSource = self
        noteTableView.delegate = self
        self.title = "List of notes"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        self.navigationItem.rightBarButtonItem = addButton
        
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        fileURL = url.appendingPathExtension("note.txt")
        loadingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if selectedRow == -1 {
            return
        }
        textData[selectedRow] = newRowText
        
        if newRowText == "" {
            textData.remove(at: selectedRow)
        }
        noteTableView.reloadData()
        saveData()
    }
    
    @objc func addNewNote(){
        let name = "Item \(textData.count + 1)"
        textData.insert(name, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        noteTableView.insertRows(at: [indexPath], with: .automatic)
        noteTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "DetailSegue", sender: nil)
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
//        UserDefaults.standard.set(textData, forKey: "text")
        let array = NSArray(array: textData)
        do {
            try array.write(to: fileURL)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func loadingData() {
//        if let loadedData = UserDefaults.standard.value(forKey: "text") {
        if let loadedData = NSArray(contentsOf: fileURL) {
            textData = loadedData as! [String]
            noteTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailView = segue.destination as! DetailViewController
        selectedRow = noteTableView.indexPathForSelectedRow!.row
        detailView.masterView = self
        detailView.setText(text: textData[selectedRow])
    }
    
    
}
