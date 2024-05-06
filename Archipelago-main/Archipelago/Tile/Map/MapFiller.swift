//
//  MapFiller.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/23/23.
//

import SpriteKit

class MapFiller {
    private var row: Int
    private var col: Int
    private var edgeLength: Int = 1024

    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }

    // need a data structure for different tiles with different chances
    func filledMap(with noise: Perlin2D) -> [[TileObject]] {
        let matrix = noise.octaveMatrix(width: row, height: col, octaves: 4, persistance: 3)
        var map = [[TileObject]](repeating: [TileObject](repeating: LandOne(x: 0, y: 0), count: col), count: row)
        
        for i in 0 ..< matrix.count-1 {
            for j in 0 ..< matrix[i].count-1 {
                if matrix[i][j] < 0.1 {
                    map[i][j] = idToTile(id: .Water, x: CGFloat(i*edgeLength+edgeLength/2),
                                         y: CGFloat(j*edgeLength+edgeLength/2))
                } else if matrix[i][j] < 0.4 {
                    map[i][j] = idToTile(id: .Grass, x: CGFloat(i*edgeLength+edgeLength/2),
                                         y: CGFloat(j*edgeLength+edgeLength/2))
                } else {
                    map[i][j] = idToTile(id: .Tree, x: CGFloat(i*edgeLength+edgeLength/2),
                                         y: CGFloat(j*edgeLength+edgeLength/2))
                }
            }
        }
        return map
    }
    
    func filledMap(with file: String) -> [[TileObject]] {
        let path = loadingDataFromTxt(resource: file)
        return loadMap(path)
    }
    
    private func loadMap(_ path: String?) -> [[TileObject]] {
        var map = [[TileObject]](repeating: [TileObject](repeating: LandOne(x: 0, y: 0), count: col), count: row)
        
        let mapHeight = row*edgeLength
        
        do {
            var string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            string = string.replacingOccurrences(of: "[", with: "")
            string = string.replacingOccurrences(of: "]", with: "")
            let lines = string.split(separator: "\n")
            var i = 0
            for line in lines {
                let tiles = line.split(separator: " ")
                var j = 0
                for tile in tiles {
                    let id = TileID.allCases[Int(tile)!-1]
                    let x: CGFloat = CGFloat(i*edgeLength+edgeLength/2)
                    let y: CGFloat = CGFloat(mapHeight-(j*edgeLength+edgeLength/2))
                    
                    map[i][j] = idToTile(id: id, x: x, y: y)
                    j += 1
                }
                i += 1
            }
        } catch {}
        
        return map
    }
    
    private func loadingDataFromTxt(resource: String) -> String? {
        var height = 0
        var width = 0
        let path = Bundle.main.path(forResource: resource, ofType: "txt")
        do {
            let string = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            let lines = string.split(separator: "\n")
            for line in lines {
                let tiles = line.split(separator: " ")
                if (width < tiles.count) {
                    width = tiles.count
                }
            }
            height = lines.count
        } catch {}
        
        row = height
        col = width
        
        return path
    }
}
