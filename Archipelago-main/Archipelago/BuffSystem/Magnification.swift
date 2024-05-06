//
//  Magnification.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/23/22.
//

import Foundation

struct Magnification: Hashable {
    var operation: Operation
    var modifingRate: Float
    
    static func == (this: Magnification, that: Magnification) -> Bool {
        return this.operation == that.operation && round(this.modifingRate*10)/10.0 == round(that.modifingRate*10)/10.0
    }
}
