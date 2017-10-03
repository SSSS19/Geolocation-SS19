//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Shehab Saqib on 26/01/2016.
//  Copyright © 2016 Shehab Saqib. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override var childViewControllerForStatusBarStyle : UIViewController? {
        return nil
    }
}
