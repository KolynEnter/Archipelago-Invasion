//
//  TextureManager.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/25/23.
//

// https://stackoverflow.com/questions/36509270/preloading-sprite-kit-textures

import SpriteKit

// Singleton

class TextureManager {

    private var textures = [String: SKTexture]()

    static let sharedInstance = TextureManager()

    private init(){}

    func getTexture(withName name: String) -> SKTexture? {return textures[name]}

    func addTexture(withName name: String) {
        textures[name] = SKTexture(imageNamed: name)
    }

    func addTextures(withNames names: [String]) {
        for name in names {
            addTexture(withName: name)
        }
    }
    
    func preloadAllTextures() {
        if textures.isEmpty {return}
        textures.forEach {
            $0.value.preload {
                
            }
        }
    }

    func removeTexture(withName name: String)->Bool {
        if textures[name] != nil {
            textures[name] = nil
            return true
        }
        return false
    }
    
    func removeAllTextures() {
        if textures.isEmpty {return}
        textures.removeAll()
    }
}
