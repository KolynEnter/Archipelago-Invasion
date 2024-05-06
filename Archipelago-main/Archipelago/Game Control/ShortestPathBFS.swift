//
//  ShortestPathBFS.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/23/23.
//

// GFG

import Foundation

struct Cell: CustomStringConvertible {
    public var description: String {
        if x == -1 && y == -1 {
            return "(#, #)"
        }
        return "(\(x), \(y))"
    }
    var x: Int
    var y: Int
    var dist: Int
    var prev: [Cell]
    var valid: Bool = false
    
    init(x: Int, y: Int, dist: Int, prev: [Cell]) {
        self.x = x
        self.y = y
        self.dist = dist
        self.prev = prev
    }
}

class BFS<T> {
    private var matrix: [[T]]!
    private var srcPoint: Point2D!
    private var endPoint: Point2D!
    
    init(matrix: [[T]]!) {
        self.matrix = matrix
    }
    
    // start: Monster position
    // end: Player position
    func shortestPath(start: Point2D, end: Point2D, searchingRadius: Int) -> Stack<Cell> {
        var cells = getCells(start: start, end: end, searchingRadius: searchingRadius)
        if cells.isEmpty {return Stack<Cell>()}

        //BFS
        var queue = Queue<Cell>()
        var src: Cell = cells[srcPoint.x][srcPoint.y]
        
        src.valid = true
        src.dist = 0
        queue.enqueue(src)
        var dest = Cell(x: 0, y: 0, dist: Int.max, prev: [])
        var p: Cell
        var count: Int = 0
        while !queue.isEmpty() {
            p = queue.dequeue()!
            if count > 1000 { // likely a barrier in the way, just return
                return Stack<Cell>()
            }
            // dest found
            if p.x == endPoint.x && p.y == endPoint.y {
                dest = p
                break
            }
            
            count += 1
            // up
            visit(cells: cells, queue: &queue, x: p.x-1, y: p.y, parent: p)
            // down
            visit(cells: cells, queue: &queue, x: p.x+1, y: p.y, parent: p)
            // left
            visit(cells: cells, queue: &queue, x: p.x, y: p.y-1, parent: p)
            // right
            visit(cells: cells, queue: &queue, x: p.x, y: p.y+1, parent: p)
        }

        if dest.dist != Int.max {
            var path = Stack<Cell>()
            p = dest
            path.push(p)
            while !p.prev.isEmpty {
                path.push(p.prev[0])
                p = p.prev[0]
            }
            return path
        }
        return Stack<Cell>()
    }
    
    private func getCells(start: Point2D, end: Point2D, searchingRadius: Int) -> [[Cell]] { // space optimized cells
        guard let map = matrix as? [[TileObject]] else {return [[Cell]]()}
        let startX: Int = start.x
        let startY: Int = start.y
        let endX: Int = end.x
        let endY: Int = end.y
        let startTile = map[startX][startY]
        let endTile = map[endX][endY]
        if startTile.isTall || startTile.isLiquid || !startTile.isWalkable || endTile.isTall || endTile.isLiquid || !endTile.isWalkable {
            return [[Cell]]()
        }
        
        var rowMin = startX - searchingRadius
        var rowMax = startX + searchingRadius
        var colMin = startY - searchingRadius
        var colMax = startY + searchingRadius
        
        var rowMinOffset: Int?
        var rowMaxOffset: Int?
        var colMinOffset: Int?
        var colMaxOffset: Int?
        
        if rowMin < 0 {
            rowMinOffset = abs(rowMin)
        }
        if rowMax > map.count {
            rowMaxOffset = rowMax - (map.count-1)
        }
        if colMin < 0 {
            colMinOffset = abs(colMin)
        }
        if colMax > map[0].count {
            colMaxOffset = colMax - (map[0].count-1)
        }
        
        srcPoint = Point2D(x: searchingRadius, y: searchingRadius)
        if let rowMinOffset = rowMinOffset {
            srcPoint.x -= rowMinOffset
        }
        if let colMinOffset = colMinOffset {
            srcPoint.y -= colMinOffset
        }
        endPoint = Point2D(x: srcPoint.x - (startX - endX), y: srcPoint.y - (startY - endY))
        
        rowMin = max(0, startX - searchingRadius)
        rowMax = min(map.count, startX + searchingRadius)
        colMin = max(0, startY - searchingRadius)
        colMax = min(map[0].count, startY + searchingRadius)
        
        var cellsRow = 2 * searchingRadius + 1 - (rowMinOffset ?? 0) - (rowMaxOffset ?? 0)
        var cellsCol = 2 * searchingRadius + 1 - (colMinOffset ?? 0) - (colMaxOffset ?? 0)
        
        if cellsRow + rowMin > map.count {
            cellsRow -= (cellsRow + rowMin - map.count)
        }
        if cellsCol + colMin > map[0].count {
            cellsCol -= (cellsCol + colMin - map[0].count)
        }
        
        rowMax = rowMax - rowMin + 1 - (rowMinOffset ?? 0) - (rowMaxOffset ?? 0)
        colMax = colMax - colMin + 1 - (colMinOffset ?? 0) - (colMaxOffset ?? 0)
        
        var cells = [[Cell]](repeating: [Cell](repeating: Cell(x: -1, y: -1, dist: Int.max, prev: []),
                                               count: cellsCol), count: cellsRow)
        for i in 0 ..< cellsRow {
            for j in 0 ..< cellsCol {
                let x: Int = i + rowMin
                let y: Int = j + colMin
                if x > map.count-1 || y > map[0].count-1 {continue}

                if !map[x][y].isLiquid && !map[x][y].isTall && map[x][y].isWalkable {
                    cells[i][j] = Cell(x: i, y: j, dist: Int.max, prev: [])
                    cells[i][j].valid = true
                }
            }
        }

        return cells
    }
    
    private func visit(cells: [[Cell]], queue: inout Queue<Cell>, x: Int, y: Int, parent: Cell) {

        if x < 0 || x >= cells.count || y < 0 || y >= cells[0].count || !cells[x][y].valid {
            return
        }
        let dist = parent.dist + 1
        var p: Cell = cells[x][y]
        if dist < p.dist {
            p.dist = dist
            p.prev = [parent]
            queue.enqueue(p)
        }
    }
}
