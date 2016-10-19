//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate
{

    var filteredImage: UIImage?
    var originalImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    
    var myRGBA:RGBAImage? = nil
    var totals:Totals? = nil
    
    private var loadedFilteredImage:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        originalImage = imageView.image!
        
        myRGBA = RGBAImage(image:imageView.image!)
        
        if let myRGBA = myRGBA
            {totals = Totals(rgbaIMG: myRGBA)}
        
        // Add "long" press gesture recognizer
        //instead of "tap" as this 1st one 
        // report touch began and touch end
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPress(sender:)))
        tap.minimumPressDuration = 0
        self.imageView.addGestureRecognizer(tap)
    }

    // MARK: Share
    @IBAction func onShare(_ sender: AnyObject)
    {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func onNewPhoto(_ sender: AnyObject)
    {
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
    
    // MARK: IBAction
    @IBAction func onFilter(_ sender: UIButton)
    {
        if (sender.isSelected)
        {
            hideSecondaryMenu()
            sender.isSelected = false
        }
        else
        {
            showSecondaryMenu()
            sender.isSelected = true
        }
    }
    
    @IBAction func onCompare(_ sender: UIButton)
    {
        if (sender.isSelected)
        {
            imageView.image = filteredImage
            loadedFilteredImage = true
            sender.isSelected = false
        }
        else
        {
            imageView.image = originalImage
            loadedFilteredImage = false
            sender.isSelected = true
        }
    }
    
    @IBAction func onBrightness(_ sender: AnyObject)
    {
        compareButton.isEnabled = true
        print("onBrightness clicked")
    }
    
    @IBAction func onRGB2Grey(_ sender: UIButton)
    {
        compareButton.isEnabled = true
        
        if (sender.isSelected)
        {
            imageView.image = originalImage
            loadedFilteredImage = false
            sender.isSelected = false
        }
        else
        {
            tran2Grey()
            sender.isSelected = true
        }
    }
    
    func showCamera()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            {imageView.image = image}
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func showSecondaryMenu()
    {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4,
                       animations:
                        {self.secondaryMenu.alpha = 1.0})
    }

    func hideSecondaryMenu()
    {
        UIView.animate(withDuration: 0.4,
                       animations:
                            {self.secondaryMenu.alpha = 0},
                       completion:
                            {completed in
                            if completed == true
                                {self.secondaryMenu.removeFromSuperview()}
                            })
    }
    
    // called by gesture recognizer
    func handleLongPress(sender: UILongPressGestureRecognizer)
    {
        if sender.state == .began
        {toggleImge()}
            // For touch up event catching
        else if sender.state == .ended
        {toggleImge()}
    }
    
    private func toggleImge()
    {
        if(loadedFilteredImage)
        {
            loadedFilteredImage = false
            imageView.image = originalImage
        }
        else
        {
            loadedFilteredImage = true
            imageView.image = filteredImage
        }
    }
    
    private func tran2Grey()
    {
        guard let lRGB = myRGBA
        else
        {
            print("myRGB is nil")
            return
        }
        
        guard let lTotals = totals
        else
        {
            print("totals is nil")
            return
        }

        print("onRGB2Grey clicked")
        
        var trans1 = Transformations(rgbaIMG: lRGB,totals: lTotals)
        
        filteredImage = trans1.rgb2grey(greyIntensity: 1)
        loadedFilteredImage = true
        imageView.image = filteredImage
    }
}

