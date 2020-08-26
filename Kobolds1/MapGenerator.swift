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
    public let height : Int
    public let width : Int
    
    public var mapTiles : [[Tile]]
    
    init(){
        mapTiles = [[Tile]]()
        self.height = 100
        self.width = 100
    }
    init(mapTiles : [[Tile]])
    {
        self.mapTiles = mapTiles
        self.height = 100
        self.width = 100
    }
    init(width: Int, height: Int){
        self.width = width
        self.height = height
        self.mapTiles = [[Tile]]()
    }
}



 class MapGenerator{
    
    
    static func generateMap(height : Int, width : Int)->Map{
        let newMap = Map()
        newMap.mapTiles = Array(repeating: Array(repeating: Tile(hasWall: false, hasFloor: true)/*, version: Int.random(in: 0..<4))*/, count: height), count: width)
        for i in 0..<height{
            for j in 0..<width{
                newMap.mapTiles[i][j].version = Int.random(in: 0..<4)
            }
        }
        
        for i in 0..<width{ // TODO: Only works if width and height the same
            newMap.mapTiles[i][0].hasWall = true
            newMap.mapTiles[i][height-1].hasWall = true
        }
        for j in 0..<height{
            newMap.mapTiles[width-1][j].hasWall = true
            newMap.mapTiles[0][j].hasWall = true
        }
        
        for i in 0..<height{ // TODO: Fix this
            newMap.mapTiles[Int.random(in: 0..<height)][Int.random(in: 0..<width)].hasWall = true
        }
        
        return newMap
    }
    
    
}
