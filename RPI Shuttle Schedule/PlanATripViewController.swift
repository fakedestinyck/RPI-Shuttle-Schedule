//
//  PlanATripViewController.swift
//  RPI Shuttle Schedule
//
//  Created by  on Sep/8/2017.
//
//

import UIKit

class PlanATripViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var mainView: PlanATripView!
    @IBOutlet weak var searchButtonUIView: SearchButtonView!
    
    var myPicker: UIPickerView! = UIPickerView()
    let fromButton = UIButton()
    let toButton = UIButton()
    let fromTextField = UITextField()

    
    var tmpPickerChosen = ""
    var shouldChangeValueBecauseOfPicker = false
    var nowEditing = UIButton()

    
    static let staticScale = min(UIScreen.main.bounds.width/375.0, UIScreen.main.bounds.height/630.0)
    let staticScale:CGFloat = PlanATripViewController.staticScale
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    static let staticDeltaX = (UIScreen.main.bounds.width-375.0*staticScale)/2.0
    static let staticDeltaY = (UIScreen.main.bounds.height-630.0*staticScale)/2.0
    let staticDeltaX:CGFloat = PlanATripViewController.staticDeltaX
    let staticDeltaY:CGFloat = PlanATripViewController.staticDeltaY
    var picker_locations = [String]()
    
    let eastPicker = ["Tibbits Ave", "B-Lot", "Colonie", "Brinsmade", "Sunset 1&2", "E-lot", "B-lot", "13th/Peoples", "9th/Sage", "West lot", "Sage(East Route)"]
    let westPicker = ["Sage Ave(West Route)", "Blitman", "City Station", "Poly Tech", "15th & College"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gstSearch:UITapGestureRecognizer = UITapGestureRecognizer(target: PlanATrip.self, action: #selector(PlanATrip.searchTap))
        mainView.addGestureRecognizer(gstSearch)
        searchButtonUIView.isHidden = true
        produceOtherUI()
        self.myPicker = UIPickerView(frame: CGRect(x: 0, y: 15, width: 0, height: 0))
        self.myPicker.delegate = self
        self.myPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates and data sources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker_locations.count
    }
    
    //MARK: Delegates
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker_locations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tmpPickerChosen = picker_locations[row]
    }
    


    class func hitTest(tapLocation:CGPoint) {
        if PlanATrip.rectangle2.contains(CGPoint(x: (tapLocation.x-staticScale*47)/staticScale-staticDeltaX, y: (tapLocation.y-staticScale*280)/staticScale-staticDeltaY)) {// 280=351-71 Idk why I separate 351 to 2 numbers......
            // click "search"
            if let topController = UIApplication.topViewController() {
                (topController as! PlanATripViewController).searchButtonClicked()
            }
        } else {
            print(CGPoint(x: (tapLocation.x-staticScale*47)/staticScale-staticDeltaX, y: (tapLocation.y-staticScale*287)/staticScale-staticDeltaY))
        }
    }
    
    func searchButtonClicked() {
        searchButtonUIView.isHidden = false
    }
    
    func produceOtherUI() {
        //departure location button
        fromButton.setTitle("Select Location", for: .normal)
        fromButton.setTitle("fromButton", for: .reserved) //Use "reserved" to mark buttons
        fromButton.contentHorizontalAlignment = .left
        fromButton.contentVerticalAlignment = .top
        fromButton.setTitleColor(UIColor(hue: 1, saturation: 0.632, brightness: 0.992, alpha: 1), for: .normal)
        fromButton.titleLabel?.font = UIFont(name: ".AppleSystemUIFont", size: 20*PlanATripViewController.staticScale)
        fromButton.setTitleColor(UIColor(white: 0.278, alpha: 1), for: UIControlState.highlighted)
        self.view.addSubview(fromButton)
        var stringSize = fromButton.titleRect(forContentRect: UIScreen.main.bounds)
        let thisSize1 = fromButton.intrinsicContentSize
        let deltaHeight1 = (thisSize1.height-24*staticScale)/2
        fromButton.frame = CGRect(x: 27*staticScale+staticDeltaX, y: 108*staticScale+staticDeltaY+PlanATripViewController.statusBarHeight-deltaHeight1, width: stringSize.width, height: 24*staticScale)
        
        //departure location textfield
        fromTextField.frame = fromButton.frame
        fromTextField.isHidden = true
        self.view.addSubview(fromTextField)
        self.view.bringSubview(toFront: fromButton)
        fromTextField.delegate = self
        
        fromButton.addTarget(self, action: #selector(button), for: UIControlEvents.touchUpInside)
        fromTextField.addTarget(self, action: #selector(textField), for: UIControlEvents.editingDidBegin)
        
        
        //destination
        toButton.setTitle("Select Destination", for: .normal)
        toButton.setTitle("toButton", for: .reserved) //Use "reserved" to mark buttons
        toButton.contentHorizontalAlignment = .left
        toButton.contentVerticalAlignment = .top
        toButton.setTitleColor(UIColor(hue: 1, saturation: 0.632, brightness: 0.992, alpha: 1), for: .normal)
        toButton.titleLabel?.font = UIFont(name: ".AppleSystemUIFont", size: 20*PlanATripViewController.staticScale)
        toButton.setTitleColor(UIColor(white: 0.278, alpha: 1), for: UIControlState.highlighted)
        self.view.addSubview(toButton)
        toButton.isEnabled = false
        toButton.setTitleColor(UIColor.lightGray, for: .disabled)
        stringSize = toButton.titleRect(forContentRect: UIScreen.main.bounds)
        let thisSize2 = toButton.intrinsicContentSize
        let deltaHeight2 = (thisSize2.height-24*staticScale)/2
        toButton.frame = CGRect(x: 27*staticScale+staticDeltaX, y: 190*staticScale+staticDeltaY+PlanATripViewController.statusBarHeight-deltaHeight2, width: stringSize.width, height: 24*staticScale)

        
        toButton.addTarget(self, action: #selector(button), for: UIControlEvents.touchUpInside)
        
    }
    
    func donePicker(sender: AnyObject) {
        //let needTransY = nowEditing.title(for: .normal) == "Select Location" || nowEditing.title(for: .normal) == "Select Destination"
        
        // there's two situation (except haven't chosen yet):
        if toButton.title(for: .normal) != "Select Destination" {
            // if current "to destination" is WEST, should be changed to EAST(in other words, change to "Select Destination")
            if westPicker.index(of: toButton.title(for: .normal)!) != nil {
                toButton.setTitle("Select Destination", for: .normal)
                toButton.sizeToFit()
            }
        }
        nowEditing.setTitle(tmpPickerChosen, for: .normal)
//        let thisSize = nowEditing.intrinsicContentSize
//        let deltaHeight = (thisSize.height-24*staticScale)/2
//        if needTransY {
//            nowEditing.frame = CGRect(x: 27*staticScale+staticDeltaX, y: nowEditing.frame.minY-deltaHeight, width: thisSize.width, height: 24*staticScale)
//        } else {
//            nowEditing.frame = CGRect(x: 27*staticScale+staticDeltaX, y: nowEditing.frame.minY, width: thisSize.width, height: 24*staticScale)
//        }
        //nowEditing.frame = CGRect(x: 27*staticScale+staticDeltaX, y: nowEditing.frame.minY, width: nowEditing.frame.size.width, height: 24*staticScale)
        nowEditing.sizeToFit()
        
        
        nowEditing.setTitleColor(UIColor(hue: 0.714, saturation: 0.515, brightness: 0.945, alpha: 1), for: .normal)
        //fromButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        if nowEditing.title(for: .reserved) == "fromButton" {
            toButton.isEnabled = true
        }
        
        
        self.fromTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func cancelPicker(sender:UIButton) {
        //Remove view when select cancel
        self.fromTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func button(sender: UIButton) {
        self.fromTextField.resignFirstResponder()
//        nowEditing = sender
//        let needTransY = nowEditing.title(for: .normal) == "Select Location" || nowEditing.title(for: .normal) == "Select Destination"
//        //nowEditing.setTitle(tmpPickerChosen, for: .normal)
//        let thisSize = nowEditing.intrinsicContentSize
//        let deltaHeight = (thisSize.height-24*staticScale)/2
//        if needTransY {
//            nowEditing.frame = CGRect(x: 27*staticScale+staticDeltaX, y: nowEditing.frame.minY-deltaHeight, width: thisSize.width, height: 24*staticScale)
//        }
        nowEditing = sender
        if nowEditing.title(for: .reserved) == "fromButton" {
            picker_locations = ["Union"] + eastPicker+westPicker
        } else if nowEditing.title(for: .reserved) == "toButton" {
            if fromButton.title(for: .normal) == "Union" {
                picker_locations = eastPicker+westPicker
            } else if eastPicker.index(of: fromButton.title(for: .normal)!) != nil {
                //if route is ***EAST***
                picker_locations = eastPicker + ["Union"]
            } else {
                picker_locations = westPicker + ["Union"]
            }
        }
        if nowEditing.title(for: .normal) == "Select Location" || nowEditing.title(for: .normal) == "Select Destination" {
            tmpPickerChosen = picker_locations[0]
        }

        self.fromTextField.becomeFirstResponder()
    }
    
    func textField(sender: UITextField) {
        //Create the view
        let tintColor: UIColor = UIColor(red: 101.0/255.0, green: 98.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        myPicker.tintColor = tintColor
        myPicker.center.x = inputView.center.x
        inputView.addSubview(myPicker) // add date picker to UIView
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width - 110), y: 0, width: 100, height: 35))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(tintColor, for: UIControlState.normal)
        doneButton.setTitleColor(tintColor, for: UIControlState.highlighted)
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: #selector(donePicker), for: UIControlEvents.touchUpInside) // set button click event
        let cancelButton = UIButton(frame: CGRect(x: 10, y: 0, width:100, height: 35))
        cancelButton.setTitle("Cancel", for: UIControlState.normal)
        cancelButton.setTitle("Cancel", for: UIControlState.highlighted)
        cancelButton.setTitleColor(tintColor, for: UIControlState.normal)
        cancelButton.setTitleColor(tintColor, for: UIControlState.highlighted)
        inputView.addSubview(cancelButton) // add Button to UIView
        cancelButton.addTarget(self, action: #selector(cancelPicker), for: UIControlEvents.touchUpInside) // set button click event
        sender.inputView = inputView
        
        if nowEditing.title(for: .normal) != "Select Location" && nowEditing.title(for: .normal) != "Select Destination" {
            let position = picker_locations.index(of: nowEditing.title(for: .normal)!)
            myPicker.selectRow(position!, inComponent: 0, animated: false)
            tmpPickerChosen = nowEditing.title(for: .normal)!
        } else {
            myPicker.selectRow(0, inComponent: 0, animated: false)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
