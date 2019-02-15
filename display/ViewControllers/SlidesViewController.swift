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
    
    var slides:[Slide] = []
    
    // MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO load slides from the app delegate user here
        
        slidesTableView.dataSource = self
        slidesTableView.delegate = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addSlideButtonClicked(sender:))
        )
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addSlideButtonClicked(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    // MARK: - TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
//        cell.textLabel?.text = slides[indexPath.row]
        
        return(cell)
    }
    
    // TODO not sure what the point of this is atm
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        slidesTableView.setEditing(editing, animated: animated)
    }
    
    // TODO unsure what the point is here as well
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        slides.remove(at: indexPath.row)
        slidesTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: self.slidesTableView)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editSlideViewController = segue.destination as? EditSlideViewController {
            if let selectedSlideCell = sender as? SlidesTableViewCellController {
                let indexPath = self.slidesTableView.indexPath(for: selectedSlideCell)!
                let selectedSlide = self.slides[indexPath.row]
                
                editSlideViewController.slide = selectedSlide
            } else {
                // TODO if it is a new one, create new and use the right position number as well
                let newSlide = Slide()
                newSlide.position = self.slides.count
                editSlideViewController.slide = newSlide
            }
        }
    }
    
    // This empty action is needed so that we can come back to the
    // home screen once we finish doing a request or anything else.
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
    }
}
