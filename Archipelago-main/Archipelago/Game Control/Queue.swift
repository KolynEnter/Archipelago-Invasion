//
//  Queue.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/23/23.
//

// https://benoitpasquier.com/data-structure-implement-queue-swift/

import Foundation

struct Queue<T> {
      private var elements: [T] = []

      mutating func enqueue(_ value: T) {
        elements.append(value)
      }

      mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
          return nil
        }
        return elements.removeFirst()
      }

      var head: T? {
        return elements.first
      }

      var tail: T? {
        return elements.last
      }
    
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
}
