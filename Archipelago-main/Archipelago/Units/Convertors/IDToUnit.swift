//
//  IDtoUnit.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/24/22.
//

func IDtoUnit(id: UnitID) -> Unit {
    switch(id) {
    case .Ape:
        return Ape(isAlly: false)
    case .Snail:
        return Snail(isAlly: false)
    case .Dummy:
        return Dummy(isAlly: false)
    case .Squirrel:
        return Squirrel(isAlly: false)
    case .Boar:
        return Boar(isAlly: false)
    case .Wolf:
        return Wolf(isAlly: false)
    case .Deer:
        return Deer(isAlly: false)
    case .WoodNymph:
        return WoodNymph(isAlly: false)
    }
    //return Dummy(isAlly: false)
}

extension CaseIterable where Self: Equatable {

    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}
