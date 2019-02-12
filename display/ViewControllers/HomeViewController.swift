//
//  HomeViewController.swift
//  display
//
//  Created by Ning Ma on 5/21/18.
//  Copyright © 2018 Ning Ma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentTable: UITableView!
    
    var content:[String] = []
    var selectedRow: Int = -1
    var newRowText: String = ""
    
    var fileURL:URL!

    
    @IBAction func Profile(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTable.dataSource = self
        contentTable.delegate = self
//        self.navigationItem.largeTitleDisplayMode = .always
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContent))
//        self.navigationItem.rightBarButtonItem = addButton
//        self.navigationItem.leftBarButtonItem = editButtonItem
        
        
        
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) // confirm networkdomainmask
        fileURL = baseURL.appendingPathComponent("content.txt") //change the string later
        load() //this may change once get to firestore
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 {
            return
        }
        content[selectedRow] = newRowText
        if newRowText == "" {
            content.remove(at: selectedRow)
        }
        contentTable.reloadData()
        save()
    }
    
    @objc func addContent() {  // this function to be changed to using ImageName as the content item names
        if contentTable.isEditing {
            return
        }
        let contentName: String = "" //how do I change this string name to imageName?
        content.insert(contentName, at: 0)
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        contentTable.insertRows(at: [indexPath], with: .automatic)
        contentTable.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        self.performSegue(withIdentifier: "detail", sender: nil) //this may change later once get to the firestore
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = content[indexPath.row]
        
        return(cell)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        contentTable.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        content.remove(at: indexPath.row)
        contentTable.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //maybe this is not useful? or at least it should be sending the content item names as the imageName.
        if let contentView = segue.destination as? ContentViewController {
            selectedRow = contentTable.indexPathForSelectedRow!.row
            contentView.masterView = self //change this, it's not self
            contentView.setText(t: content[selectedRow])
        }
//        else if let profileView = segue.destination as? ProfileViewController {
//
//        }
    }
    
    func save() {
        //UserDefaults.standard.set(content, forKey: "contents") // change this later
        let a = NSArray(array: content)
        do {
            try a.write(to: fileURL)
        } catch {
            print("error writing file")
        }
        
    }
    
    func load() {
        if let loadedData:[String] = NSArray(contentsOf: fileURL) as? [String] {
            content = loadedData
            contentTable.reloadData()
        }
    }
    //func addNote() {
        //let name: String = ""
        //data.insert(name, at: 0)
        //let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        //table.insertRows(at: [indexPath], with: .automatic)
    //}
    
    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = tableArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)
    }
 */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
// to round buttons
// btn.layer.cornerRadius = 10
// btn.clipsToBounds = true

