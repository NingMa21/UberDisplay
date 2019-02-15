//
//  HomeViewController.swift
//  display
//
//  Created by Ning Ma on 5/21/18.
//  Copyright © 2018 Ning Ma. All rights reserved.
//

import UIKit

class SlidesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var slidesTableView: UITableView!
    
    var slides:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slidesTableView.dataSource = self
        slidesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func addContent() {  // this function to be changed to using ImageName as the content item names
        if slidesTableView.isEditing {
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = slides[indexPath.row]
        
        return(cell)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        slidesTableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        slides.remove(at: indexPath.row)
        slidesTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //maybe this is not useful? or at least it should be sending the content item names as the imageName.
//        if let contentView = segue.destination as? ContentViewController {
//            selectedRow = slidesTableView.indexPathForSelectedRow!.row
//            contentView.masterView = self //change this, it's not self
//            contentView.setText(t: content[selectedRow])
//        }
//        else if let profileView = segue.destination as? ProfileViewController {
//
//        }
    }
    
    // This empty action is needed so that we can come back to the
    // home screen once we finish doing a request or anything else.
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        // TODO put the saving to the plist here if we come from the registration of sign in
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
