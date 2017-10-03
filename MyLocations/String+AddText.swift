//
//  String+AddText.swift
//  MyLocations
//
//  Created by Shehab Saqib on 25/01/2016.
//  Copyright © 2016 Shehab Saqib. All rights reserved.
//

import Foundation

extension String {
    mutating func addText(_ text: String?, withSeparator separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
