/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The view controller used as the root of the split view's master-side navigation controller.
*/

import UIKit

class MasterViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tealium = Tealium(config: defaultTealiumConfig)
        
        let extraData : [String:AnyObject] = ["Key" : "value" as AnyObject]

        tealium?.track(title: "test", data: extraData, completion: { (success, info, error) in
            print("*** TRACK COMPLETION HANDLER *** Track finished.")
        })
    
        
    }
    
    @IBAction func unwindInMaster(_ segue: UIStoryboardSegue)  {
        /*
            Empty. Exists solely so that "unwind in master" segues can
            find this instance as a destination.
        */
    }
}
