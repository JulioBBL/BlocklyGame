//
//  Toolbox.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 21/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import Foundation

enum ToolboxType: String {
    case begginer = "Begginer"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case extreme = "Extreme"
    
    func path() -> String {
        switch self {
        case .begginer:
            return "begginerToolbox.xml"
        case .intermediate:
            return "intermidateToolbox.xml"
        case .advanced:
            return "advancedToolbox.xml"
        case .extreme:
            return "toolbox.xml"
        }
    }
}
