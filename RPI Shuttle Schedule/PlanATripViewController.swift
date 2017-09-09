//
//  PlanATripViewController.swift
//  RPI Shuttle Schedule
//
//  Created by  on Sep/8/2017.
//
//

import UIKit

class PlanATripViewController: UIViewController {
    @IBOutlet weak var mainView: PlanATripView!
    @IBOutlet weak var searchButtonUIView: SearchButtonView!
    
    static let staticScale = min(UIScreen.main.bounds.width/375.0, UIScreen.main.bounds.height/630.0)
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gstSearch:UITapGestureRecognizer = UITapGestureRecognizer(target: PlanATrip.self, action: #selector(PlanATrip.searchTap))
        mainView.addGestureRecognizer(gstSearch)
        searchButtonUIView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    class func hitTest(tapLocation:CGPoint) {
        if PlanATrip.rectangle2.contains(CGPoint(x: (tapLocation.x-staticScale*47)/staticScale, y: (tapLocation.y-staticScale*287)/staticScale)) {
            // click "search"
            print("In")
            if let topController = UIApplication.topViewController() {
                (topController as! PlanATripViewController).searchButtonClicked()
            }
        } else {
            print(CGPoint(x: tapLocation.x-staticScale*47, y: tapLocation.y-staticScale*287))
            print(CGPoint(x: (tapLocation.x-staticScale*47)/staticScale, y: (tapLocation.y-staticScale*287)/staticScale))
        }
    }
    
    func searchButtonClicked() {
        searchButtonUIView.isHidden = false
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
