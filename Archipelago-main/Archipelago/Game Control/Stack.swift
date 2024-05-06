//
//  Stack.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/21/23.
//

// https://medium.com/devslopes-blog/swift-data-structures-stack-4f301e4fa0dc

import Foundation

struct Stack<T> {
    private var items: [T] = []
    
    func peek() -> T {
        guard let topElement = items.first else {
            fatalError("This stack is empty.")
        }
        return topElement
    }
    
    mutating func pop() -> T {
        return items.removeFirst()
    }
    
    mutating func push(_ element: T) {
        items.insert(element, at: 0)
    }
    
    func isEmpty() -> Bool {
        return items.isEmpty
    }
}
