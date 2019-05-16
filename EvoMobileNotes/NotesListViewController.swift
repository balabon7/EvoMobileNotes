//
//  NotesListViewController.swift
//  EvoMobileNotes
//
//  Created by mac on 5/15/19.
//  Copyright © 2019 sashabalabon. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating  {
    
    @IBOutlet weak var noteTableView: UITableView!
    
    var textData = [String]()
    var selectedRow = -1
    var newRowText = ""
    var searchController: UISearchController!
    var filteredArray = [String]()
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTableView.dataSource = self
        noteTableView.delegate = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        self.navigationItem.rightBarButtonItem = addButton
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        loadingData()
    }
    
    
    @objc func addNewNote(){
        let name = "Note \(textData.count + 1)"
        textData.insert(name, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        noteTableView.insertRows(at: [indexPath], with: .automatic)
        noteTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "DetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return filteredArray.count
        }
        return textData.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareNotes = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            
            let defaultTextNotes = self.textData[indexPath.row]
            
            let activityController = UIActivityViewController(activityItems: [defaultTextNotes], applicationActivities: nil)
            
            self.present(activityController, animated: true, completion: nil)
        }
        
        let deleteNotes = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            
            self.textData.remove(at: indexPath.row)
            self.noteTableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        shareNotes.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        saveData()
        return [deleteNotes, shareNotes]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = textData[indexPath.row]
        
        
        if searchController.isActive {
            cell?.textLabel!.text = "\(filteredArray[indexPath.row])"
        } else {
            cell?.textLabel!.text = "\(textData[indexPath.row])"
        }
        
        return cell!
    }
    
    
    func updateSearchResults(for searchController: UISearchController){
        self.filteredArray = textData.filter{
            $0.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        self.noteTableView.reloadData()
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
