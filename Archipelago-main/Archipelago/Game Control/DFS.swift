//
//  DFS.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/21/23.
//

// GFG

import Foundation

struct Pair<T> {
    var first: T
    var second: T
    
    init(first: T, second: T) {
        self.first = first
        self.second = second
    }
}

class DFS<T> {
    private let dRow: [Int] = [0, 1, 0, -1]
    private let dCol: [Int] = [-1, 0, 1, 0]
    var matrix: [[T]]!
    private var totalCol: Int!
    private var totalRow: Int!
    private var vis: [[Bool]]!
    var invalidTilePositions = [Pair<Int>]()
    
    init(matrix: [[T]]!) {
        self.matrix = matrix
        totalCol = matrix.count
        totalRow = matrix[0].count
        vis = [[Bool]](repeating: [Bool](repeating: false, count: totalCol), count: totalRow)
    }
    
    func resetVis() {
        vis = [[Bool]](repeating: [Bool](repeating: false, count: totalCol), count: totalRow)
    }
    
    private func isValid(row: Int, col: Int) -> Bool {
        if row < 0 || col < 0 || row >= totalRow || col >= totalCol {
            return false
        }
        if vis[row][col] {
            return false
        }
        guard let map = matrix as? [[TileObject]] else {return false}
        if map[row][col].isLiquid || map[row][col].isTall || !map[row][col].isWalkable {
            invalidTilePositions.append(Pair(first: Int(map[row][col].x), second: Int(map[row][col].y)))
            return false
        }
        return true
    }
    
    // This is not shortest path, replace this
    // rather than give the actual row & col, give the directions
    func DFS(x: Int, y: Int, targetX: Int, targetY: Int) -> Bool {
        var stack = Stack<Pair<Int>>()
        var row = x
        var col = y
        stack.push(Pair(first: row, second: col))
        
        while !stack.isEmpty() {
            let curr: Pair<Int> = stack.pop()
            row = curr.first
            col = curr.second
            if !isValid(row: row, col: col) {continue}
            
            if row == targetX && col == targetY {
                return true
            }
            vis[row][col] = true
            for i in 0 ..< 4 {
                let adjx: Int = row + dRow[i]
                let adjy: Int = col + dCol[i]
                stack.push(Pair<Int>(first: adjx, second: adjy))
            }
        }
        return false
    }
}
