//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var filteredImage: UIImage?
    
    @IBOutlet var originalImageView: UIImageView!
    @IBOutlet var filteredImageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var intensityMenu: UIView!
    @IBOutlet var intensityText: UILabel!
    
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    
    @IBOutlet var brightnessButton: UIButton!
    @IBOutlet var averageButton: UIButton!
    @IBOutlet var grayScaleButton: UIButton!
    
    @IBOutlet var overlay:UIView!
    @IBOutlet var gestureArea:UIView!
    
    @IBOutlet var intensitySlider: UISlider!
    
    var currentFilter:String!
    
    var originalImage:UIImage?
    
    var isShowingOriginal:Bool = true
    
    var imageTapEvent:UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        intensityMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        intensityMenu.translatesAutoresizingMaskIntoConstraints = false
        
        self.originalImage = self.originalImageView.image
        
        self.compareButton.isEnabled = false
        
        self.imageTapEvent = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.onImageTap))
        self.imageTapEvent.minimumPressDuration = 0.1
        self.imageTapEvent.delegate = self
        self.gestureArea.addGestureRecognizer(self.imageTapEvent)
        
        self.editButton.isEnabled = false
    }
    
    func onImageTap(_ gesture: UILongPressGestureRecognizer){
        if(self.filteredImage != nil){
            if(gesture.state == UIGestureRecognizerState.began){
                self.showImage(original: !self.isShowingOriginal)
            }else if(gesture.state == UIGestureRecognizerState.ended){
                self.showImage(original: self.isShowingOriginal)
            }
        }
    }

    // MARK: Share
    @IBAction func onShare(_ sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", filteredImage!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImageView.image = image
            self.originalImage = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(_ sender: UIButton) {
        if (sender.isSelected) {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu()
            sender.isSelected = true
        }
    }
    
    @IBAction func onBrightnessFilter(_ sender: UIButton) {
        let brightnessFilter = Brightness(brightness: 0.5)
        brightnessFilter.setBaseImage(image: self.originalImage)
        brightnessFilter.apply()
        
        self.filteredImage = brightnessFilter.toUIImage()
        
        self.currentFilter = "brightness"
        
        self.afterFilterApplied()
    }
    
    @IBAction func onAverageFilter(_ sender: UIButton) {
        let averageFilter = Average(intensity: 2)
        averageFilter.setBaseImage(image: self.originalImage)
        averageFilter.apply()
        
        self.filteredImage = averageFilter.toUIImage()
        
        self.currentFilter = "average"
        
        self.afterFilterApplied()
    }
    
    @IBAction func onGrayScaleFilter(_ sender: UIButton) {
        let grayScaleFilter = Grayscale()
        grayScaleFilter.setBaseImage(image: self.originalImage)
        grayScaleFilter.apply()
        
        self.filteredImage = grayScaleFilter.toUIImage()
        
        self.currentFilter = "grayscale"
        
        self.afterFilterApplied()
    }
    
    func afterFilterApplied(){
        self.compareButton.isEnabled = true
        self.editButton.isEnabled = true
        self.isShowingOriginal = false
        self.filteredImageView.image = self.filteredImage
        self.showImage(original: false)
        
        self.intensitySlider.isEnabled = true
        self.intensityText.text = "Intensity"
        
        switch self.currentFilter {
        case "brightness":
            self.intensitySlider.minimumValue = -1
            self.intensitySlider.maximumValue = 1
            self.intensitySlider.value = (self.intensitySlider.minimumValue + self.intensitySlider.maximumValue)/2
        case "average":
            self.intensitySlider.minimumValue = 0
            self.intensitySlider.maximumValue = 255
            self.intensitySlider.value = (self.intensitySlider.minimumValue + self.intensitySlider.maximumValue)/2
        default:
            self.intensitySlider.isEnabled = false
            self.intensityText.text = "Not configurable"
        }
    }
    
    @IBAction func onCompare(_ sender: UIButton) {
        self.isShowingOriginal = !self.isShowingOriginal
        self.showImage(original: self.isShowingOriginal)
    }
    
    func showSecondaryMenu() {
        self.editButton.isSelected = false
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 1.0
        })
        
        let brightnessFilter = Brightness(brightness: 0.5)
        brightnessFilter.setBaseImage(image: self.brightnessButton.backgroundImage(for: UIControlState.normal))
        brightnessFilter.apply()
        self.brightnessButton.setBackgroundImage(brightnessFilter.toUIImage(), for: UIControlState.normal)
        
        let averageFilter = Average(intensity: 2)
        averageFilter.setBaseImage(image: self.averageButton.backgroundImage(for: UIControlState.normal))
        averageFilter.apply()
        self.averageButton.setBackgroundImage(averageFilter.toUIImage(), for: UIControlState.normal)
        
        let grayScaleFilter = Grayscale()
        grayScaleFilter.setBaseImage(image: self.grayScaleButton.backgroundImage(for: UIControlState.normal))
        grayScaleFilter.apply()
        self.grayScaleButton.setBackgroundImage(grayScaleFilter.toUIImage(), for: UIControlState.normal)
    }
    
    func showImage(original: Bool){
        UIView.animate(withDuration: 0.5) { 
            if(original){
                self.originalImageView.alpha = 1
                self.overlay.alpha = 0.5
            }else{
                self.originalImageView.alpha = 0
                self.overlay.alpha = 0
            }
        }
        
    }

    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
            }, completion: { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }) 
    }
    
    func showIntensityMenu() {
        if(self.secondaryMenu.alpha>0){
            UIView.animate(withDuration: 0.4, animations: {
                self.secondaryMenu.alpha = 0
                }, completion: { completed in
                    if completed == true {
                        self.secondaryMenu.removeFromSuperview()
                        self.showIntensityMenuHelper()
                    }
            })
        }else{
            self.showIntensityMenuHelper()
        }
        
    }
    
    func showIntensityMenuHelper(){
        self.filterButton.isSelected = false
        view.addSubview(intensityMenu)
        
        let bottomConstraint = intensityMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = intensityMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = intensityMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = intensityMenu.heightAnchor.constraint(equalToConstant: 90)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.intensityMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.intensityMenu.alpha = 1.0
        })
    }
    
    func hideIntensityMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.intensityMenu.alpha = 0
            }, completion: { completed in
                if completed == true {
                    self.intensityMenu.removeFromSuperview()
                }
        })
    }
    
    @IBAction func onIntensityChanged(_ sender: UISlider) {
        switch self.currentFilter {
        case "brightness":
            let brightnessFilter = Brightness(brightness: sender.value)
            brightnessFilter.setBaseImage(image: self.originalImage)
            brightnessFilter.apply()
            
            self.filteredImage = brightnessFilter.toUIImage()
        case "average":
            let averageFilter = Average(intensity: Int(sender.value))
            averageFilter.setBaseImage(image: self.originalImage)
            averageFilter.apply()
            
            self.filteredImage = averageFilter.toUIImage()
        default:
            break
        }
        
        self.filteredImageView.image = self.filteredImage
    }
    
    @IBAction func onEdit(_ sender: UIButton) {
        if (sender.isSelected) {
            hideIntensityMenu()
            sender.isSelected = false
        } else {
            showIntensityMenu()
            sender.isSelected = true
        }
    }

}

