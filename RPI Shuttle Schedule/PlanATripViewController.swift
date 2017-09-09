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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gstSearch:UITapGestureRecognizer = UITapGestureRecognizer(target: PlanATrip.self, action: #selector(PlanATrip.searchTap))
        mainView.addGestureRecognizer(gstSearch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
