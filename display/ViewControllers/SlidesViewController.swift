//
//  HomeViewController.swift
//  display
//
//  Created by Ning Ma on 5/21/18.
//  Copyright © 2018 Ning Ma. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ImageSlideshow

class SlidesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    @IBOutlet weak var slidesTableView: UITableView!
    
    // MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load slides from the app delegate user here
        self.startAnimating()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user.loadSlidesfromFirebase( {(user) in
            self.stopAnimating()
            self.slidesTableView.reloadData()
        }, onError: {(error) in
            self.stopAnimating()
            // TODO handle this better with a message or something
        })
        
        slidesTableView.dataSource = self
        slidesTableView.delegate = self
        slidesTableView.rowHeight = 90
        
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        return appDelegate.user.slides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCell", for: indexPath) as! SlidesTableViewCellController
        
        let slide = appDelegate.user.slides[indexPath.row]
        cell.slideTitle.text = slide.title
        cell.slideDescription.text = slide.description
        cell.slideImage.image = slide.slideImage
        
        return cell
    }
    
    // TODO not sure what the point of this is atm
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        slidesTableView.setEditing(editing, animated: animated)
    }
    
    // TODO unsure what the point is here as well
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        appDelegate.user.slides.remove(at: indexPath.row)
        slidesTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self.slidesTableView)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let editSlideViewController = segue.destination as? EditSlideViewController {
            if let tableView = sender as? UITableView {
                let indexPath = tableView.indexPathForSelectedRow
                let selectedSlide = appDelegate.user.slides[indexPath!.row]
                editSlideViewController.slide = selectedSlide
            } else {
                // TODO if it is a new one, create new and use the right position number as well
                let newSlide = Slide()
                newSlide.position = appDelegate.user.slides.count
                editSlideViewController.slide = newSlide
            }
        }
    }
    
    // This action is needed so that we can come back to the
    // home screen once we finish doing a request or anything else and
    // reload the slides
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        self.startAnimating()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user.loadSlidesfromFirebase( {(user) in
            self.stopAnimating()
            self.slidesTableView.reloadData()
        }, onError: {(error) in
            self.stopAnimating()
            // TODO handle this better with a message or something
        })
    }
}
