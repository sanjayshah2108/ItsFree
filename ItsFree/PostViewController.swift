 //
//  PostViewController.swift
//  ItsFree
//
//  Created by Sanjay Shah on 2017-11-17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import MapKit
import FirebaseStorage
import CoreLocation

class PostViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var qualitySegmentedControl: UISegmentedControl!
    @IBOutlet var customTagTextField: UITextField!
    @IBOutlet var valueTextField: UITextField!
    @IBOutlet var addCustomTagButton: UIButton!
    @IBOutlet var tagButtonView: UIView!
    @IBOutlet weak var defaultTagStackView: UIStackView!
    @IBOutlet weak var customTagStackView: UIStackView!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var addCategoryButton: UIButton!
    @IBOutlet var photoCollectionView: UICollectionView!
    
    //step by step outlets
    @IBOutlet weak var stepByStepView: UIView!
    var questionLabel: UILabel!
    var responseView: UIView!
    var nextPreviousButtonStackView: UIStackView!
    var previewWarningLabel: UILabel!
    var offerStepsArray: [String]!
    var requestStepsArray: [String]!
    var stepIndex: Int!
    
    @IBOutlet var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var titleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet var descriptionLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var descriptionTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var customTagTextFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet var customTagTextFielLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var customTagTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var valueTextFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet var valueTextFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var addTagButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet var addTagButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet var addTagButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var tagButtonTopConstraintToCustomTagTextFieldBottom: NSLayoutConstraint!
    @IBOutlet var tagButtonTopConstraintToValueBottom: NSLayoutConstraint!
    @IBOutlet var tagButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var tagButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var tagButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet var photoCollectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var photoCollectionViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var photoCollectionViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var qualitySegmentTopConstraint: NSLayoutConstraint!
    @IBOutlet var qualitySegmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet var qualitySegmentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var qualitySegmentTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var categoryButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet var categoryButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var categoryButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var locationButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet var locationButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var locationButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var locationButtonBottomConstraint: NSLayoutConstraint!
    
    var topConstraintInResponseView: NSLayoutConstraint!
    var bottomConstraintInResponseView: NSLayoutConstraint!
    var leadingConstraintInResponseView: NSLayoutConstraint!
    var trailingConstraintInResponseView: NSLayoutConstraint!
    
    var previousButton: UIButton!
    var nextButton: UIButton!
    
    var chosenQuality: ItemQuality!
    var chosenTagsArray: [String] = []
    var chosenCategory: ItemCategory!
    
    var categoryCount: Int!
    var categoryTableView: UITableView!
    let cellID: String = "categoryCellID"
    
    public var selectedLocationString: String = ""
    public var selectedLocationCoordinates: CLLocationCoordinate2D!
    
    let imagePicker = UIImagePickerController()
    var myImage:UIImage?
    var photosArray: Array<UIImage>!
    
    var tapGesture: UITapGestureRecognizer!
    
    var offerRequestSegmentedControl: UISegmentedControl!
    var offerRequestIndex: Int!
    
    var editingBool: Bool = false
    var itemToEdit: Item!
    
    let storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        photosArray = []
        setupUI()

        
        
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        descriptionTextField.textColor = .lightGray
        descriptionTextField.text = "Optional Description"
        customTagTextField.delegate = self
        valueTextField.delegate = self
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        imagePicker.delegate = self
        
        checkIfEditing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.locationButton.setTitle("Location: \(self.selectedLocationString)", for: UIControlState.normal)
    }
    
    func setupUI(){
        
        self.navigationItem.backBarButtonItem?.title = "Browse"
        
        titleTextField.layer.borderColor = UIProperties.sharedUIProperties.purpleColour.cgColor
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.cornerRadius = 4.0
        
        descriptionTextField.layer.borderColor = UIProperties.sharedUIProperties.purpleColour.cgColor
        descriptionTextField.layer.borderWidth = 1.0
        descriptionTextField.layer.cornerRadius = 4.0
        
        customTagTextField.layer.borderColor = UIProperties.sharedUIProperties.purpleColour.cgColor
        customTagTextField.layer.borderWidth = 1.0
        customTagTextField.layer.cornerRadius = 4.0
        
        valueTextField.layer.borderColor = UIProperties.sharedUIProperties.purpleColour.cgColor
        valueTextField.layer.borderWidth = 1.0
        valueTextField.layer.cornerRadius = 4.0
        
        
        categoryTableView = UITableView(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: (self.view.frame.height-((self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.size.height))), style: UITableViewStyle.plain)
        
        addCustomTagButton.tintColor = UIProperties.sharedUIProperties.lightGreenColour
        
        qualitySegmentedControl.tintColor = UIProperties.sharedUIProperties.purpleColour
        qualitySegmentedControl.backgroundColor = UIProperties.sharedUIProperties.whiteColour
        qualitySegmentedControl.layer.borderColor = UIProperties.sharedUIProperties.purpleColour.cgColor
        qualitySegmentedControl.layer.borderWidth = 1.0
        
        qualitySegmentedControl.layer.cornerRadius = 4.0
        
        addCategoryButton.backgroundColor = UIProperties.sharedUIProperties.whiteColour
        addCategoryButton.setTitleColor(UIProperties.sharedUIProperties.purpleColour, for: .normal)
        
        addCategoryButton.layer.borderColor = UIProperties.sharedUIProperties.purpleColour.cgColor
        addCategoryButton.layer.borderWidth = 1
        addCategoryButton.layer.cornerRadius = 5
        addCategoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        locationButton.backgroundColor = UIProperties.sharedUIProperties.whiteColour
        locationButton.setTitleColor(UIProperties.sharedUIProperties.purpleColour, for: .normal)
        locationButton.layer.borderColor = UIProperties.sharedUIProperties.purpleColour.cgColor
        locationButton.layer.borderWidth = 1
        locationButton.layer.cornerRadius = 5
        locationButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        setupPhotoCollectionView()
        setupOfferRequestSegmentedControl()
        setupTagButtonsView()
    }
    
    func setupPhotoCollectionView(){
        let photoCollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        photoCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        photoCollectionViewFlowLayout.minimumInteritemSpacing = 5.0
        
        photoCollectionView.collectionViewLayout = photoCollectionViewFlowLayout
    }
    
    func centralizePhotoCollectionView(){
        
        var totalPhotosCount: Int!
        
        if (editingBool == true){
            totalPhotosCount = photosArray.count + itemToEdit.photos.count + 1
        }
        else {
            totalPhotosCount = photosArray.count + 1
        }
        
        let viewWidth = CGFloat(photoCollectionView.frame.width * 1)
        let totalCellWidth = (photoCollectionView.frame.size.width/3) * CGFloat(totalPhotosCount);
        let totalSpacingWidth = 10 * CGFloat(totalPhotosCount - 1);
        
        let leftInset = (viewWidth - (totalCellWidth + totalSpacingWidth)) / 2;
        let rightInset = leftInset;
        
        photoCollectionViewLeadingConstraint = NSLayoutConstraint(item: photoCollectionView, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .leading, multiplier: 1, constant: 7)
        photoCollectionViewTrailingConstraint = NSLayoutConstraint(item: photoCollectionView, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .trailing, multiplier: 1, constant: 7)
        photoCollectionViewLeadingConstraint.constant = leftInset
        photoCollectionViewTrailingConstraint.constant = rightInset
        
        view.layoutIfNeeded()
    }
    
    //setup default UI if editing, otherwise step by step questions
    func checkIfEditing(){
        if (editingBool){
            offerRequestSegmentedControl.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
            offerRequestSegmentedControl.tintColor = UIProperties.sharedUIProperties.lightGreenColour
            offerRequestSegmentedControl.backgroundColor = UIProperties.sharedUIProperties.blackColour
            self.navigationItem.titleView = offerRequestSegmentedControl
            offerRequestSegmentedControl.center.x = (self.navigationItem.titleView?.center.x)!
            offerRequestSegmentedControl.selectedSegmentIndex = offerRequestIndex
            
            titleTextField.text = itemToEdit.name
            descriptionTextField.text = itemToEdit.itemDescription
            descriptionTextField.textColor = UIColor.black
            chosenTagsArray = itemToEdit.tags.tagsArray
            qualitySegmentedControl.selectedSegmentIndex = ItemQuality.itemQualityIndex(quality: itemToEdit.quality)
            addCategoryButton.setTitle("Category: \(itemToEdit.itemCategory.rawValue)", for: .normal)
            chosenCategory = itemToEdit.itemCategory
            locationButton.setTitle("Location: \(String(describing: itemToEdit!.coordinate))", for: .normal)
            selectedLocationCoordinates = itemToEdit.location
            valueTextField.text = String(itemToEdit.value)
            
            for tag in itemToEdit.tags.tagsArray {
                addCustomTag(string: tag)
            }
            
            findLocationStringFromCoordinates(item: itemToEdit)
        }
        
        else {
            setupInitialUI()
        }
    }
    
    fileprivate func setupOfferRequestSegmentedControl() {
        offerRequestSegmentedControl = UISegmentedControl()
        offerRequestSegmentedControl.tintColor = UIProperties.sharedUIProperties.purpleColour
        offerRequestSegmentedControl.backgroundColor = UIProperties.sharedUIProperties.whiteColour
        offerRequestSegmentedControl.insertSegment(withTitle: "Offer", at: 0, animated: true)
        offerRequestSegmentedControl.insertSegment(withTitle: "Request", at: 1, animated: true)
        offerRequestSegmentedControl.addTarget(self, action: #selector(offerRequestSegmentControlChanged), for: .valueChanged)
        //self.navigationItem.titleView = offerRequestSegmentedControl
    }
    
    func setupInitialUI(){
        
        offerStepsArray = ["What kind of post is this?", "Item Title & Description", "Add some photos", "Add tags/keywords to enhance searches for this item", "What condition is it in?", "What category does it fall under?", "Pick up Location?", "What is its value?"]
        requestStepsArray = ["What kind of post is this?", "Item Title & Description", "Add some sample photos?", "Select or add tags/keywords to enhance searches for this item", "What's the worst condition you would accept?", "What category does it fall under?", "Drop off Location?", "Requests cannot have a value!"]
        stepIndex = 0
        
        view.bringSubview(toFront: stepByStepView)
        
        //setup Question Label
        questionLabel = UILabel(frame: CGRect(x: 10, y: 25, width: view.frame.width-20, height: 50))
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.font = UIFont(name: "Avenir-Light", size: 15)
        questionLabel.center.x = view.center.x
        questionLabel.textAlignment = .center
        questionLabel.text = offerStepsArray[stepIndex]
        
        stepByStepView.addSubview(questionLabel)
        
        //setup response view
        responseView = UIView(frame: CGRect(x: 0, y: 80, width: view.frame.width, height: 170))
        responseView.center.x = view.center.x
        responseView.backgroundColor = UIProperties.sharedUIProperties.whiteColour
        
        stepByStepView.addSubview(responseView)
        
        //setup preview warning label
        previewWarningLabel = UILabel(frame: CGRect(x: 10, y: 295, width: view.frame.width-20, height: 30))
        previewWarningLabel.font = UIFont(name: "Avenir-LightOblique", size: 12)
        previewWarningLabel.center.x = view.center.x
        previewWarningLabel.textAlignment = .center
        previewWarningLabel.text = "You'll be able to preview this info. before posting"
        
        stepByStepView.addSubview(previewWarningLabel)
        
        //setup nextPrevious Buttons
        nextButton = UIButton(type: .custom)
        nextButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 15)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: UIControlEvents.touchUpInside)
        nextButton.tintColor = UIProperties.sharedUIProperties.whiteColour
        nextButton.backgroundColor = UIProperties.sharedUIProperties.purpleColour
        nextButton.layer.borderColor = UIProperties.sharedUIProperties.blackColour.cgColor
        nextButton.layer.borderWidth = 3
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        
        previousButton = UIButton(type: .custom)
        previousButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        previousButton.setTitle("Previous", for: .normal)
        previousButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 15)
        previousButton.addTarget(self, action: #selector(previousButtonAction), for: UIControlEvents.touchUpInside)
        previousButton.tintColor = UIProperties.sharedUIProperties.whiteColour
        previousButton.backgroundColor = UIProperties.sharedUIProperties.purpleColour
        previousButton.layer.borderColor = UIProperties.sharedUIProperties.blackColour.cgColor
        previousButton.layer.borderWidth = 3
        previousButton.layer.cornerRadius = previousButton.frame.height/2
        
        nextPreviousButtonStackView = UIStackView(arrangedSubviews: [previousButton,nextButton])
        nextPreviousButtonStackView.backgroundColor = UIColor.black
        nextPreviousButtonStackView.axis = .horizontal
        nextPreviousButtonStackView.frame = CGRect.zero
        nextPreviousButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        nextPreviousButtonStackView.distribution = .fillEqually
        stepByStepView.addSubview(nextPreviousButtonStackView)
        
        //previewWarningLabel Constraints
//        let previewWarningLabelTopConstraint = NSLayoutConstraint(item: previewWarningLabel, attribute: .top, relatedBy: .equal, toItem: responseView, attribute: .bottom, multiplier: 1, constant: 10)
//        let previewWarningLabelLeadingConstraint = NSLayoutConstraint(item: previewWarningLabel, attribute: .leading, relatedBy: .equal, toItem: stepByStepView, attribute: .leading, multiplier: 1, constant: 10)
//        let previewWarningLabelTrailingConstraint = NSLayoutConstraint(item: previewWarningLabel, attribute: .trailing, relatedBy: .equal, toItem: stepByStepView, attribute: .trailing, multiplier: 1, constant: 10)
//        //let previewWarningLabelBottomConstraint = NSLayoutConstraint(item: previewWarningLabel, attribute: .bottom, relatedBy: .equal, toItem: nextPreviousButtonStackView, attribute: .top, multiplier: 1, constant: 10)
//
//        NSLayoutConstraint.activate([previewWarningLabelTopConstraint, previewWarningLabelLeadingConstraint, previewWarningLabelTrailingConstraint])
        
        
        //nextPreviousButtons Constraints
        let nextPreviousStackViewTopConstraint = NSLayoutConstraint(item: nextPreviousButtonStackView, attribute: .top, relatedBy: .equal, toItem: responseView, attribute: .bottom, multiplier: 1, constant: 10)
        
        let nextPreviousStackViewWidthConstraint = NSLayoutConstraint(item: nextPreviousButtonStackView, attribute: .width, relatedBy: .equal,
                                                                      toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.width*0.8)
        
        let nextPreviousStackViewHeightConstraint = NSLayoutConstraint(item: nextPreviousButtonStackView, attribute: .height, relatedBy: .equal,
                                                                       toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        
        let centralizeXconstraint = NSLayoutConstraint(item: nextPreviousButtonStackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([nextPreviousStackViewWidthConstraint, nextPreviousStackViewHeightConstraint, centralizeXconstraint, nextPreviousStackViewTopConstraint])
        
        
        titleTopConstraint.isActive = false
        descriptionTopConstraint.isActive = false
        //tagButtonTopConstraintToCustomTagTextFieldBottom.isActive = false
        tagButtonTopConstraintToValueBottom.isActive = false
        valueTextFieldTopConstraint.isActive = false
        customTagTrailingConstraint.isActive = false
        customTagTextFieldTopConstraint.isActive = false
        photoCollectionViewTopConstraint.isActive = false
        qualitySegmentTopConstraint.isActive = false
        categoryButtonTopConstraint.isActive = false
        locationButtonTopConstraint.isActive = false
        locationButtonBottomConstraint.isActive = false
        
        setupCascadingQuestions()
    }
    
    //next, previous button actions
    @objc func previousButtonAction(sender:UIButton!) {
        print("previous Clicked")
        stepIndex = stepIndex - 1
        setupCascadingQuestions()
    }
    
    @objc func nextButtonAction(sender:UIButton!) {
        nextQuestion()
        print("next Clicked")
        
    }
    
    func nextQuestion(){
        
        if  (nextButton.titleLabel?.text == "Preview"){
            stepIndex = offerStepsArray.count
        }
        else {
            stepIndex = stepIndex + 1
            if (stepIndex < offerStepsArray.count){
                questionLabel.text = offerStepsArray[stepIndex]
            }
        }
        setupCascadingQuestions()
    }
    
    //step by step questions
    func setupCascadingQuestions(){
        
        //show default UI
        if (stepIndex == offerStepsArray.count){
            
            for view in responseView.subviews {
                view.isHidden = true
            }
            
            topConstraintInResponseView.isActive = false
            bottomConstraintInResponseView.isActive = false
            trailingConstraintInResponseView.isActive = false
            leadingConstraintInResponseView.isActive = false
            
            questionLabel.removeFromSuperview()
            responseView.removeFromSuperview()
            previewWarningLabel.removeFromSuperview()
            nextPreviousButtonStackView.removeFromSuperview()
            view.sendSubview(toBack: stepByStepView)
            
            view.addSubview(titleTextField)
            view.addSubview(descriptionTextField)
            view.addSubview(tagButtonView)
            view.addSubview(customTagTextField)
            view.addSubview(addCustomTagButton)
            view.addSubview(photoCollectionView)
            photoCollectionView.reloadData()
            view.addSubview(addCategoryButton)
            view.addSubview(locationButton)
            view.addSubview(valueTextField)
            view.addSubview(qualitySegmentedControl)
            
            if (offerRequestSegmentedControl.selectedSegmentIndex == 1){
                valueTextField.isEnabled = false
                valueTextField.backgroundColor = UIColor.gray
            }
            
            titleTextField.isHidden = false
            descriptionTextField.isHidden = false
            tagButtonView.isHidden = false
            customTagTextField.isHidden = false
            addCustomTagButton.isHidden = false
            photoCollectionView.isHidden = false
            addCategoryButton.isHidden = false
            locationButton.isHidden = false
            valueTextField.isHidden = false
            qualitySegmentedControl.isHidden = false
            
            titleTopConstraint.isActive = true
            titleLeadingConstraint.isActive = true
            titleTrailingConstraint.isActive = true
            
            descriptionTopConstraint.isActive = true
            descriptionLeadingConstraint.isActive = true
            descriptionTrailingConstraint.isActive = true
            
            tagButtonTopConstraintToCustomTagTextFieldBottom.isActive = true
            tagButtonTopConstraintToValueBottom.isActive = true
            tagButtonHeightConstraint.isActive = true
            tagButtonLeadingConstraint.isActive = true
            tagButtonTrailingConstraint.isActive = true
            
            valueTextFieldTopConstraint.isActive = true
            valueTextFieldTrailingConstraint.isActive = true
            
            customTagTextFieldTopConstraint.isActive = true
            customTagTextFielLeadingConstraint.isActive = true
            customTagTrailingConstraint.isActive = true
            
            addTagButtonTopConstraint.isActive = true
            addTagButtonTrailingConstraint.isActive = true
            addTagButtonBottomConstraint.isActive = true
            
            photoCollectionViewTopConstraint.isActive = true
            photoCollectionViewLeadingConstraint.isActive = true
            photoCollectionViewTrailingConstraint.isActive = true
            
            qualitySegmentTopConstraint.isActive = true
            qualitySegmentHeightConstraint.isActive = true
            qualitySegmentLeadingConstraint.isActive = true
            qualitySegmentTrailingConstraint.isActive = true
            
            categoryButtonTopConstraint.isActive = true
            categoryButtonLeadingConstraint.isActive = true
            categoryButtonTrailingConstraint.isActive = true
            
            locationButtonTopConstraint.isActive = true
            locationButtonLeadingConstraint.isActive = true
            locationButtonTrailingConstraint.isActive = true
            locationButtonBottomConstraint.isActive = true
            
            view.layoutIfNeeded()
        }
            
            //ask if offer or request
        else if (stepIndex == 0){
            nextPreviousButtonStackView.isHidden = true
            
            offerRequestSegmentedControl.frame = CGRect(x: 0, y: 30, width: 300, height: 30)
            offerRequestSegmentedControl.center.x = responseView.center.x
            offerRequestSegmentedControl.layer.cornerRadius = 4
            offerRequestSegmentedControl.addTarget(self, action: #selector(moveOfferRequestSegmentControl), for: .valueChanged)
            
            responseView.addSubview(offerRequestSegmentedControl)
        }
            
            //title and description
        else if (stepIndex == 1){
            
            nextPreviousButtonStackView.isHidden = false
            previousButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            previousButton.isHidden = true
            
            for view in responseView.subviews {
                view.isHidden = true
            }
            questionLabel.text = offerStepsArray[stepIndex]
            titleTextField.isHidden = false
            descriptionTextField.isHidden = false
            responseView.addSubview(titleTextField)
            responseView.addSubview(descriptionTextField)
            
            topConstraintInResponseView = NSLayoutConstraint(item: titleTextField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10)
            
            bottomConstraintInResponseView = NSLayoutConstraint(item: titleTextField, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: descriptionTextField, attribute: NSLayoutAttribute.top, multiplier: 1, constant: -10)
            
            responseView.addConstraints([topConstraintInResponseView, bottomConstraintInResponseView])
        }
            
            //photos
        else if (stepIndex == 2){
            
            previousButton.frame = CGRect(x: 0, y: 0, width: nextPreviousButtonStackView.frame.width/2, height: nextPreviousButtonStackView.frame.height)
            nextPreviousButtonStackView.distribution = .fillEqually
            previousButton.isHidden = false
            
            if (offerRequestSegmentedControl.selectedSegmentIndex == 1){
                questionLabel.text = requestStepsArray[stepIndex]
            }
                
            else {
                questionLabel.text = offerStepsArray[stepIndex]
            }
            
            for view in responseView.subviews {
                view.isHidden = true
            }
            
            photoCollectionView.isHidden = false
            setupPhotoCollectionView()
            responseView.addSubview(photoCollectionView)
            
            topConstraintInResponseView = NSLayoutConstraint(item: photoCollectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10)
            
            bottomConstraintInResponseView = NSLayoutConstraint(item: photoCollectionView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -20)
            
            trailingConstraintInResponseView = NSLayoutConstraint(item: photoCollectionView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: responseView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
            
            leadingConstraintInResponseView = NSLayoutConstraint(item: photoCollectionView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: responseView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10)
            
            responseView.addConstraints([topConstraintInResponseView, bottomConstraintInResponseView, leadingConstraintInResponseView, trailingConstraintInResponseView])
        }
            
            //tags
        else if (stepIndex == 3){
            for view in responseView.subviews {
                view.isHidden = true
            }
            
            customTagTextField.isHidden = false
            tagButtonView.isHidden = false
            addCustomTagButton.isHidden = false
            
            questionLabel.text = offerStepsArray[stepIndex]
            responseView.addSubview(customTagTextField)
            responseView.addSubview(tagButtonView)
            responseView.addSubview(addCustomTagButton)
            
            topConstraintInResponseView = NSLayoutConstraint(item: customTagTextField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10)
            trailingConstraintInResponseView = NSLayoutConstraint(item: customTagTextField, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -10)
            leadingConstraintInResponseView = NSLayoutConstraint(item: customTagTextField, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10)
            responseView.addConstraints([topConstraintInResponseView, trailingConstraintInResponseView, leadingConstraintInResponseView])
        }
            
            //quality
        else if (stepIndex == 4){
            for view in responseView.subviews {
                view.isHidden = true
            }
            
            if (offerRequestSegmentedControl.selectedSegmentIndex == 1){
                questionLabel.text = requestStepsArray[stepIndex]
            }
                
            else {
                questionLabel.text = offerStepsArray[stepIndex]
            }
            
            qualitySegmentedControl.isHidden = false
            responseView.addSubview(qualitySegmentedControl)
            
            topConstraintInResponseView = NSLayoutConstraint(item: qualitySegmentedControl, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10)
            responseView.addConstraints([topConstraintInResponseView])
        }
            
            //Category
        else if (stepIndex == 5){
            
            nextButton.setTitle("Next", for: .normal)
            
            for view in responseView.subviews {
                view.isHidden = true
            }
            
            addCategoryButton.isHidden = false
            questionLabel.text = offerStepsArray[stepIndex]
            responseView.addSubview(addCategoryButton)
            
            topConstraintInResponseView = NSLayoutConstraint(item: addCategoryButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10)
            responseView.addConstraints([topConstraintInResponseView])
        }
            
            //location
        else if (stepIndex == 6){
            
            if (offerRequestSegmentedControl.selectedSegmentIndex == 1){
                nextButton.setTitle("Preview", for: .normal)
            }
            
            for view in responseView.subviews {
                view.isHidden = true
            }
            
            if (offerRequestSegmentedControl.selectedSegmentIndex == 1){
                questionLabel.text = "Drop off Location?"
            }
                
            else {
                questionLabel.text = offerStepsArray[stepIndex]
            }
            
            locationButton.isHidden = false
            responseView.addSubview(locationButton)
            
            topConstraintInResponseView = NSLayoutConstraint(item: locationButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10)
            responseView.addConstraints([topConstraintInResponseView])
        }
            
            //value
        else if (stepIndex == 7){
            
            nextButton.setTitle("Preview", for: .normal)
            
            for view in responseView.subviews {
                view.isHidden = true
            }
            
            valueTextField.isHidden = false
            questionLabel.text = offerStepsArray[stepIndex]
            responseView.addSubview(valueTextField)
            
            topConstraintInResponseView = NSLayoutConstraint(item: valueTextField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10)
            
            leadingConstraintInResponseView = NSLayoutConstraint(item: valueTextField, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10)
            
            trailingConstraintInResponseView = NSLayoutConstraint(item: valueTextField, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: responseView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -10)
            
            responseView.addConstraints([topConstraintInResponseView,leadingConstraintInResponseView, trailingConstraintInResponseView])
        }
    }
    
    @objc func moveOfferRequestSegmentControl(sender: UISegmentedControl!){
        
        if(stepIndex == 0){
            offerRequestSegmentedControl.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
            offerRequestSegmentedControl.tintColor = UIProperties.sharedUIProperties.lightGreenColour
            offerRequestSegmentedControl.backgroundColor = UIProperties.sharedUIProperties.blackColour
            self.navigationItem.titleView = offerRequestSegmentedControl
            offerRequestSegmentedControl.center.x = (self.navigationItem.titleView?.center.x)!
            nextQuestion()
        }
    }
    
    
    @objc func offerRequestSegmentControlChanged(){
        switch offerRequestSegmentedControl.selectedSegmentIndex {
        case 0: valueTextField.isEnabled = true
            valueTextField.backgroundColor = UIColor.white
        
        if !(editingBool){
        
            if (stepIndex < 8){
                questionLabel.text = offerStepsArray[stepIndex]
            }
        
            if (stepIndex == 7){
                nextButton.setTitle("Preview", for: .normal)
            }
            else {
                nextButton.setTitle("Next", for: .normal)
                }
            }
        case 1: valueTextField.isEnabled = false
            valueTextField.backgroundColor = UIColor.gray
        
        if !(editingBool){
            if (stepIndex < 8){
                questionLabel.text = requestStepsArray[stepIndex]
            }
            if (stepIndex == 6){
                nextButton.setTitle("Preview", for: .normal)
            }
            else {
                nextButton.setTitle("Next", for: .normal)
                }
            }
            
        default: valueTextField.isEnabled = false
            valueTextField.backgroundColor = UIColor.gray
            

        }
    }
    
    func setupTagButtonsView(){
        
        let defaultTags = ["mom", "student", "ubc", "nike", "hiker"]
        
        for defaultTag in defaultTags {
            
            let currentButton = UIButton(frame: CGRect(x: 5, y: 8, width: 50, height: 20))
            
            currentButton.setTitle(defaultTag, for: .normal)
            currentButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
            currentButton.addTarget(self, action: #selector(addOrRemoveThisDefaultTag), for: UIControlEvents.touchUpInside)
            
            currentButton.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
            currentButton.sizeToFit()
            
            currentButton.layer.borderWidth = 1
            currentButton.layer.borderColor = UIColor.gray.cgColor
            currentButton.layer.cornerRadius = 10
            
            defaultTagStackView.addArrangedSubview(currentButton)
        }
        
        defaultTagStackView.alignment = .center
        defaultTagStackView.spacing = 1
        defaultTagStackView.distribution = .fillProportionally
        
        customTagStackView.alignment = .leading
        customTagStackView.spacing = 1
        customTagStackView.distribution = .fillProportionally
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func openCategories(_ sender: UIButton) {
        
        self.view.addSubview(categoryTableView)
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.bringSubview(toFront: categoryTableView)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func findLocationStringFromCoordinates(item: Item){
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks!.count > 0) {
                let pm = placemarks![0]
                
                if(pm.thoroughfare != nil && pm.subThoroughfare != nil){
                    // not all places have thoroughfare & subThoroughfare so validate those values
                    
                    self.locationButton.setTitle("Location: \(pm.thoroughfare ?? "Unknown Place"), \(pm.subThoroughfare ?? "Unknown Place")", for: UIControlState.normal)
                    
                }
                else if(pm.subThoroughfare != nil) {
                    
                    self.locationButton.setTitle("Location: \(pm.thoroughfare ?? "Unknown Place"), \(pm.subLocality ?? "Unknown Place")", for: UIControlState.normal)
                }
                    
                else {
                    self.locationButton.setTitle("Location: Unknown Place", for: UIControlState.normal)
                }
            }
            else {
                self.locationButton.setTitle("Location: Unknown Place", for: UIControlState.normal)
            }
        })
    }
    
    //imagePicker Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        myImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if myImage != nil {
            print("image loaded: \(myImage!)")
        }
        photosArray.append(myImage!)
        dismiss(animated: true, completion: nil)
        photoCollectionView.reloadData()
    }
    
    func presentImagePickerAlert() {
        
        let photoSourceAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler:{ (action) in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler:{ (action) in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        photoSourceAlert.addAction(cameraAction)
        photoSourceAlert.addAction(photoLibraryAction)
        photoSourceAlert.addAction(cancelAction)
        
        self.present(photoSourceAlert, animated: true, completion: nil)
    }
    
    func addCustomTag(string: String){
        
        if (string != ""){
            
            let newButton = UIButton(frame: CGRect(x: 5, y: 8, width: 50, height: 20))
            
            newButton.setTitle(string, for: .normal)
            newButton.setTitleColor(UIProperties.sharedUIProperties.whiteColour, for: UIControlState.normal)
            newButton.addTarget(self, action: #selector(addOrRemoveThisDefaultTag), for: UIControlEvents.touchUpInside)
            
            newButton.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
            newButton.sizeToFit()
            
            newButton.backgroundColor = UIProperties.sharedUIProperties.purpleColour
            newButton.layer.borderWidth = 1
            newButton.layer.borderColor = UIProperties.sharedUIProperties.blackColour.cgColor
            newButton.layer.cornerRadius = 10
            
            customTagStackView.addArrangedSubview(newButton)
            
            if !(editingBool){
                chosenTagsArray.append(string)
            }
            
            customTagTextField.resignFirstResponder()
            customTagTextField.text = ""
        }
    }
    
    @IBAction func addCustomTagButton(_ sender: UIButton) {
        
        let newCustomTag =  customTagTextField.text
        addCustomTag(string: newCustomTag!)
    }
    
    @objc func addOrRemoveThisDefaultTag(sender: UIButton){
        
        if(sender.titleColor(for: UIControlState.normal) == UIColor.gray){
            
            sender.setTitleColor(UIProperties.sharedUIProperties.whiteColour, for: UIControlState.normal)
            sender.layer.borderColor = UIProperties.sharedUIProperties.blackColour.cgColor
            sender.backgroundColor = UIProperties.sharedUIProperties.purpleColour
            
            chosenTagsArray.append((sender.titleLabel?.text)!)
        }
            
        else if(sender.titleColor(for: UIControlState.normal) == UIProperties.sharedUIProperties.whiteColour){
            
            sender.setTitleColor(UIColor.gray, for: UIControlState.normal)
            sender.layer.borderColor = UIColor.gray.cgColor
            sender.backgroundColor = UIProperties.sharedUIProperties.whiteColour
            
            chosenTagsArray.remove(at:chosenTagsArray.index(of:((sender.titleLabel?.text)!))!)
        }
    }
    
    //category chooser table views
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: cellID)!
        cell.textLabel?.text = ItemCategory.stringValue(index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)!
        self.addCategoryButton.setTitle("Category: \(cell.textLabel?.text ?? "Unknown")", for: UIControlState.normal)
        chosenCategory = ItemCategory.enumName(index: indexPath.row)
        self.navigationController?.navigationBar.isHidden = false
        categoryTableView.removeFromSuperview()
    }
    
    
    //thePostMethod
    fileprivate func validateFields() {
        
        guard (offerRequestSegmentedControl.selectedSegmentIndex != -1) else {
            let alert = UIAlertController(title: "Whoops", message: "You must offer or request this", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard (titleTextField.text != "") else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a title", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard (titleTextField.text!.count < 18) else {
            let alert = UIAlertController(title: "Whoops", message: "Title needs to be less than 18 characters", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
//        guard (descriptionTextField.text != "") else {
//            let alert = UIAlertController(title: "Whoops", message: "You must add a description", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            return
//            
//        }
        
        guard (chosenCategory != nil) else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a category", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
            
        }
        
        guard (selectedLocationCoordinates != nil) else {
            let alert = UIAlertController(title: "Whoops", message: "You must add a location", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard !(valueTextField.text == "" && offerRequestSegmentedControl.selectedSegmentIndex == 0) else {
            let alert = UIAlertController(title: "Whoops", message: "Offered items must have a value", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let user = AppData.sharedInstance.currentUser!
        
        let tags:Tag = Tag()
        if chosenTagsArray.count > 0 {
            tags.tagsArray = chosenTagsArray
        }
        
        let realItem: Item = Item.init(name: titleTextField.text!, category: chosenCategory, description: descriptionTextField.text!, location: selectedLocationCoordinates, posterUID:  user.UID, quality: chosenQuality, tags: tags, photos: [""], value: Int(valueTextField.text!) ?? 0,  itemUID: nil)
        
        var photoRefs:[String] = []
        
        BusyActivityView.show(inpVc: self)
        
        if (editingBool){
            //NEED TO CHANGE THIS APPROACH OF DELETING THE ITEM FIRST
            WriteFirebaseData.delete(itemUID: itemToEdit.UID, completion: {(success) in
                
                if (success){
                    
                    
                }
                else {
                    
                    
                }
                
            })
            
            
            if (photosArray.count+itemToEdit.photos.count) == 0 {
                photoRefs.append("")
            }
            else {
                
                photoRefs = itemToEdit.photos
                for index in 0..<photosArray.count {
                    let storagePath = "\(realItem.UID!)/\(index)"
                    
                    ImageManager.uploadImage(image: photosArray[index],
                                             userUID: (AppData.sharedInstance.currentUser?.UID)!,
                                             filename: storagePath, completion : {(success, photoRefStr) in
                                                
                                                if (success){
                                                    
                                                    photoRefs.append(photoRefStr!)
                                                    
                                                    if (index == self.photosArray.count) {
                                                        
                                                        realItem.photos = photoRefs
                                                        
                                                        WriteFirebaseData.write(item: realItem, type: self.offerRequestSegmentedControl.selectedSegmentIndex){(success) in
                                                            
                                                            if (success){
                                                                
                                                                Alert.Show(inpVc: self, customAlert: nil, inpTitle: "Done", inpMessage: "Your item was successfully uploaded", inpOkTitle: "Ok")
                                                                
                                                                BusyActivityView.hide()
                                                                self.navigationController?.popToRootViewController(animated: true)
                                                                
                                                            }
                                                            else {
                                                                Alert.Show(inpVc: self, customAlert: nil, inpTitle: "Error", inpMessage: "Your item could not be posted. Please try again", inpOkTitle: "Ok")
                                                                
                                                                BusyActivityView.hide()
                                                            }
                                                            
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                    }}
                                                else {
                                                    
                                                    Alert.Show(inpVc: self, customAlert: nil, inpTitle: "Error", inpMessage: "There was an error uploading one or more of your images & so your item wasnt uploaded", inpOkTitle: "Try again")
                                                    
                                                    BusyActivityView.hide()
                                                    
                                                }
                                                
                                                
                    })
                }
            }
        }
        else {
        
            if (photosArray.count == 0) {
                photoRefs.append("")
            }
            else {
                for index in 0..<photosArray.count {
                    let storagePath = "\(realItem.UID!)/\(index)"
                    
                    ImageManager.uploadImage(image: photosArray[index],
                                                               userUID: (AppData.sharedInstance.currentUser?.UID)!,
                                                               filename: storagePath, completion : {(success, photoRefStr) in
                                                                
                                                                if (success){
                                                                
                                                                    photoRefs.append(photoRefStr!)
                                                                    
                                                                    if (index == (self.photosArray.count - 1)) {
                                                                    
                                                                    realItem.photos = photoRefs
                                                                    
                                                                        WriteFirebaseData.write(item: realItem, type: self.offerRequestSegmentedControl.selectedSegmentIndex){(success) in
                                                                        
                                                                        if (success){
                                                                            
                                                                            Alert.Show(inpVc: self, customAlert: nil, inpTitle: "Done", inpMessage: "Your item was successfully uploaded", inpOkTitle: "Ok")
                                                                            
                                                                            BusyActivityView.hide()
                                                                            self.navigationController?.popToRootViewController(animated: true)
                                                                            
                                                                        }
                                                                        else {
                                                                            Alert.Show(inpVc: self, customAlert: nil, inpTitle: "Error", inpMessage: "Your item could not be posted. Please try again", inpOkTitle: "Ok")
                                                                            
                                                                            BusyActivityView.hide()
                                                                        }
                                                                        
                                                                        
                                                                    }
                                                                    
                                                                    
                                                                    
                                                                    }}
                                                                else {
                                                                    
                                                                    Alert.Show(inpVc: self, customAlert: nil, inpTitle: "Error", inpMessage: "There was an error uploading one or more of your images & so your item wasnt uploaded", inpOkTitle: "Try again")
                                                                    
                                                                    BusyActivityView.hide()
                                                                    
                                                                }
                                                                    
                                                                
                    })
                    
                }
            }
        }

        
    }
    
    @IBAction func postItem(_ sender: UIBarButtonItem) {
        switch(qualitySegmentedControl.selectedSegmentIndex){
        case 0: chosenQuality = ItemQuality.New
        case 1: chosenQuality = ItemQuality.GentlyUsed
        case 2: chosenQuality = ItemQuality.WellUsed
        case 3: chosenQuality = ItemQuality.DamagedButFunctional
        default:
            chosenQuality = ItemQuality.GentlyUsed
        }
        validateFields()
    }
    
    
    @IBAction func selectPostLocationButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showPostMap", sender: self)
    }
    
    
    //photos CollectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        if (editingBool){
            if(itemToEdit.photos[0] == ""){
                return ((itemToEdit.photos.count-1)+photosArray.count+1)
            }
            else {
                return ((itemToEdit.photos.count)+photosArray.count+1)
            }
        }
        else {
            return (photosArray.count+1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (editingBool){
            if(itemToEdit.photos.count+photosArray.count == 0){
                 return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height);
            }
        }
        else {
            if (photosArray.count == 0){
                 return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height);
            }
        }
        
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height);
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! PostPhotoCollectionViewCell
        
        
        if(editingBool){
            
            if(itemToEdit.photos[0] == ""){
            
            if((itemToEdit.photos.count-1)+photosArray.count == indexPath.item){
                cell.postCollectionViewCellImageView.image = #imageLiteral(resourceName: "addImage")
                cell.postCollectionViewCellImageView.layer.borderWidth = 0
                cell.postCollectionViewCellImageView.layer.cornerRadius = 0
                cell.contentMode = .scaleAspectFit
            }
            
            else if(indexPath.item < (itemToEdit.photos.count-1)+photosArray.count){
                
                
                if(indexPath.item < (itemToEdit.photos.count-1)){
                    cell.postCollectionViewCellImageView.sd_setImage(with:storageRef.child(itemToEdit.photos[indexPath.item]), placeholderImage: UIImage.init(named: "placeholder"))
                }
                
                else {
                    cell.postCollectionViewCellImageView.image = photosArray[(indexPath.item-(itemToEdit.photos.count-1))]
                }
                
                cell.postCollectionViewCellImageView.layer.cornerRadius = 10
                cell.postCollectionViewCellImageView.layer.borderWidth = 3.0
                cell.postCollectionViewCellImageView.layer.borderColor = UIProperties.sharedUIProperties.blackColour.cgColor
                cell.postCollectionViewCellImageView.layer.masksToBounds = true
                cell.postCollectionViewCellImageView.clipsToBounds = true
                cell.postCollectionViewCellImageView.contentMode = .scaleAspectFill
            }
            }
            else{
                if((itemToEdit.photos.count)+photosArray.count == indexPath.item){
                    cell.postCollectionViewCellImageView.image = #imageLiteral(resourceName: "addImage")
                    cell.postCollectionViewCellImageView.layer.borderWidth = 0
                    cell.postCollectionViewCellImageView.layer.cornerRadius = 0
                    cell.contentMode = .scaleAspectFit
                }
                    
                else if(indexPath.item < (itemToEdit.photos.count)+photosArray.count){
                    
                    
                    if(indexPath.item < (itemToEdit.photos.count)){
                        cell.postCollectionViewCellImageView.sd_setImage(with:storageRef.child(itemToEdit.photos[indexPath.item]), placeholderImage: UIImage.init(named: "placeholder"))
                    }
                        
                    else {
                        cell.postCollectionViewCellImageView.image = photosArray[(indexPath.item-(itemToEdit.photos.count))]
                    }
                    
                    cell.postCollectionViewCellImageView.layer.cornerRadius = 10
                    cell.postCollectionViewCellImageView.layer.borderWidth = 3.0
                    cell.postCollectionViewCellImageView.layer.borderColor = UIProperties.sharedUIProperties.blackColour.cgColor
                    cell.postCollectionViewCellImageView.layer.masksToBounds = true
                    cell.postCollectionViewCellImageView.clipsToBounds = true
                    cell.postCollectionViewCellImageView.contentMode = .scaleAspectFill
                }
                
                
            }
        }
        
        else  {
            if(photosArray.count == indexPath.item){
                cell.postCollectionViewCellImageView.image = #imageLiteral(resourceName: "addImage")
                cell.postCollectionViewCellImageView.contentMode = .scaleAspectFit
                cell.postCollectionViewCellImageView.layer.borderWidth = 0
                
            }
        
            else if(indexPath.item < photosArray.count){
                cell.postCollectionViewCellImageView.image = photosArray[indexPath.item]
                
                cell.postCollectionViewCellImageView.layer.cornerRadius = 10
                cell.postCollectionViewCellImageView.layer.borderWidth = 3.0
                cell.postCollectionViewCellImageView.layer.borderColor = UIProperties.sharedUIProperties.blackColour.cgColor
                cell.postCollectionViewCellImageView.layer.masksToBounds = true
                cell.postCollectionViewCellImageView.clipsToBounds = true
                cell.postCollectionViewCellImageView.contentMode = .scaleAspectFill
                
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //if we are editing an existing post
        if (editingBool){
            
            if (itemToEdit.photos[0] == ""){
            //if we click on the plus picture
            if ((indexPath.item) + 1 > (self.photosArray.count + (itemToEdit.photos.count-1))){
                presentImagePickerAlert()
            }
            //else we click on an existing picture
            else {
                let changePhotoAlert = UIAlertController(title: "View or Delete Photo?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                
                var viewAction: UIAlertAction!
                var changeAction: UIAlertAction!
                
                //if the picture was already existing
                if(indexPath.item < (itemToEdit.photos.count-1)){
                    
                    viewAction = UIAlertAction(title: "View Photo", style: UIAlertActionStyle.default, handler:{ (action) in
                        //open photo
                        
                    })
                    
                    changeAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.destructive, handler:{ (action) in
                        //
                        
                        self.itemToEdit.photos.remove(at: indexPath.item)
                        self.photoCollectionView.reloadData()
                    })
                }
                    
                //else if the picture was just added
                else {
                    
                    viewAction = UIAlertAction(title: "View Photo", style: UIAlertActionStyle.default, handler:{ (action) in
                        //open photo
                        self.fullscreenImage(image: self.photosArray[indexPath.item - (self.itemToEdit.photos.count-1)])
                        
                    })
                    
                    changeAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.destructive, handler:{ (action) in
                        
                        self.photosArray.remove(at: (indexPath.item-self.itemToEdit.photos.count-1))
                        self.photoCollectionView.reloadData()
                    })
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                
                changePhotoAlert.addAction(viewAction)
                changePhotoAlert.addAction(changeAction)
                changePhotoAlert.addAction(cancelAction)
                
                self.present(changePhotoAlert, animated: true, completion: nil)
            }
            }
            else {
                //if we click on the plus picture
                if ((indexPath.item) + 1 > (self.photosArray.count + (itemToEdit.photos.count))){
                    presentImagePickerAlert()
                }
                    //else we click on an existing picture
                else {
                    let changePhotoAlert = UIAlertController(title: "View or Delete Photo?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                    
                    var viewAction: UIAlertAction!
                    var changeAction: UIAlertAction!
                    
                    //if the picture was already existing
                    if(indexPath.item < (itemToEdit.photos.count)){
                        
                        viewAction = UIAlertAction(title: "View Photo", style: UIAlertActionStyle.default, handler:{ (action) in
                            //open photo
                            
                        })
                        
                        changeAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.destructive, handler:{ (action) in
                            //
                            
                            self.itemToEdit.photos.remove(at: indexPath.item)
                            self.photoCollectionView.reloadData()
                        })
                    }
                        
                        //else if the picture was just added
                    else {
                        
                        viewAction = UIAlertAction(title: "View Photo", style: UIAlertActionStyle.default, handler:{ (action) in
                            //open photo
                            self.fullscreenImage(image: self.photosArray[indexPath.item - (self.itemToEdit.photos.count)])
                            
                        })
                        
                        changeAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.destructive, handler:{ (action) in
                            
                            self.photosArray.remove(at: (indexPath.item-self.itemToEdit.photos.count))
                            self.photoCollectionView.reloadData()
                        })
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                    
                    changePhotoAlert.addAction(viewAction)
                    changePhotoAlert.addAction(changeAction)
                    changePhotoAlert.addAction(cancelAction)
                    
                    self.present(changePhotoAlert, animated: true, completion: nil)
                }
            }
            
        }
        //else if we are creating a new post
        else {
            //if we click on the plus picture
            if ((indexPath.item) + 1 > self.photosArray.count){
                presentImagePickerAlert()
            }
            //else if we click on an image
            else {
                let changePhotoAlert = UIAlertController(title: "View or Delete Photo?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                
                let viewAction = UIAlertAction(title: "View Photo", style: UIAlertActionStyle.default, handler:{ (action) in
                    self.fullscreenImage(image: self.photosArray[indexPath.item])
                })
                
                let changeAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.destructive, handler:{ (action) in
                    self.photosArray.remove(at: indexPath.item)
                    self.photoCollectionView.reloadData()
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                
                changePhotoAlert.addAction(viewAction)
                changePhotoAlert.addAction(changeAction)
                changePhotoAlert.addAction(cancelAction)
                
                self.present(changePhotoAlert, animated: true, completion: nil)
            }
        }
    }
    
    //textView methods
    func textFieldDidBeginEditing(_ textField: UITextField) {

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.removeGestureRecognizer(tapGesture)

    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        if descriptionTextField.textColor == .lightGray && descriptionTextField.isFirstResponder {
            descriptionTextField.text = nil
            descriptionTextField.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        
        self.view.removeGestureRecognizer(tapGesture)
        
        if descriptionTextField.text.isEmpty || descriptionTextField.text == "" {
            descriptionTextField.textColor = .lightGray
            descriptionTextField.text = "Optional Description"
        }
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        customTagTextField.resignFirstResponder()
        valueTextField.resignFirstResponder()
    }
    
    //fullcreen image methods
    func fullscreenImage(image: UIImage) {
        
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    

    
}
