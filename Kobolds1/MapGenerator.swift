//
//  MapGenerator.swift
//  Kobolds1
//
//  Created by Aidan Blant on 8/25/20.
//  Copyright © 2020 Aidan Blant. All rights reserved.
//

import Foundation
import UIKit

let grassTiles : [NSMutableAttributedString] = [
    NSMutableAttributedString(string: ",", attributes: [NSAttributedString.Key.foregroundColor : UIColor.green] ),
    NSMutableAttributedString(string: "'", attributes: [NSAttributedString.Key.foregroundColor : UIColor.green] ),
    NSMutableAttributedString(string: ".", attributes: [NSAttributedString.Key.foregroundColor : UIColor.green] ),
    NSMutableAttributedString(string: "`", attributes: [NSAttributedString.Key.foregroundColor : UIColor.green] ),
]
let wallTile = NSMutableAttributedString(string: "\(blockChar)", attributes:  [NSAttributedString.Key.foregroundColor : UIColor.gray])
let emptySpace = NSMutableAttributedString(string: "\(blockChar)", attributes:  [NSAttributedString.Key.foregroundColor : UIColor.gray])

struct Tile {
    var hasWall : Bool
    var hasFloor : Bool
    var version : Int?
    
    init(hasWall : Bool, hasFloor : Bool ){
        self.hasWall = hasWall
        self.hasFloor = hasFloor
//        self.version = Int.random(in: 0..<4)
    }
    
    func getTile()->NSMutableAttributedString{
        if( hasWall ){
            return wallTile
        }
        if( hasFloor ){
            return grassTiles[version ?? 0]
        }
        
        return emptySpace
    }
}



class Map {
    
    public var mapTiles : [[Tile]]
    
    init(){
        mapTiles = [[Tile]]()
    }
    init(mapTiles : [[Tile]])
    {
        self.mapTiles = mapTiles
    }
}



 class MapGenerator{
    
    static func generateMap()->Map{
        let newMap = Map()
        newMap.mapTiles = Array(repeating: Array(repeating: Tile(hasWall: false, hasFloor: true)/*, version: Int.random(in: 0..<4))*/, count: 100), count: 100)
        for i in 0..<100{
            for j in 0..<100{
                newMap.mapTiles[i][j].version = Int.random(in: 0..<4)
            }
        }
        
        for i in 0..<100{
            newMap.mapTiles[i][0].hasWall = true
            newMap.mapTiles[0][i].hasWall = true
            newMap.mapTiles[i][99].hasWall = true
            newMap.mapTiles[99][i].hasWall = true
        }
        
        for i in 0..<100{
            newMap.mapTiles[Int.random(in: 0..<100)][Int.random(in: 0..<100)].hasWall = true
        }
        
        return newMap
    }
    
    
}
