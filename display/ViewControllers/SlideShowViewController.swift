//
//  SlideShowViewController.swift
//  display
//
//  Created by Ben Hanrahan on Tuesday 2/19/19.
//  Copyright © 2019 Ning Ma. All rights reserved.
//

import UIKit
import Foundation
import ImageSlideshow

class SlideShowViewController: UIViewController {
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var currentSlideTitle: UILabel!
    @IBOutlet weak var currentSlideDescription: UITextView!
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // setup appearance and stuff
        slideshow.slideshowInterval = 15.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
//        let pageControl = UIPageControl()
//        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
//        pageControl.pageIndicatorTintColor = UIColor.black
//        slideshow.pageIndicator = pageControl
        
        // set images for slideshow
        var imageSources = [ImageSource]()
        for slide in appDelegate.user.slides {
            imageSources.append(ImageSource(image: slide.slideImage!))
        }
        
        slideshow.setImageInputs(imageSources)
        
        // set the title and desc to first slide
        self.setSlideInfo(slide: appDelegate.user.slides[0])
        
        // setup transition closure
        slideshow.currentPageChanged = { [weak self] slideIndex in
            self!.setSlideInfo(slide: appDelegate.user.slides[slideIndex])
        }
    }
    
    func setSlideInfo(slide: Slide) {
        self.currentSlideDescription.text = slide.description
        self.currentSlideTitle.text = slide.title
    }
}
