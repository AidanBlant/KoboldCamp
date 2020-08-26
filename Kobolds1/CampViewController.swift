//
//  FirstViewController.swift
//  Kobolds1
//
//  Created by Aidan Blant on 8/23/20.
//  Copyright © 2020 Aidan Blant. All rights reserved.
//

import UIKit

struct Point{
    public var x : Int
    public var y : Int
}
let blockChar : Character = "█"


class CampViewController: UIViewController {

    
    // MARK: - MAP PROPERTIES
    
    @IBOutlet weak var campView: UITextView!
//    let blockChar : Character = "█"

    // This block will all be part of the "Map" Object that tilesONScreen will call to to get current displayed map
//    var aString : String = ""
    var totalMapWidth : Int = 100
    var totalMapHeight : Int = 100
    
    var campMap : Map = Map()
    
    var tilesOnScreen : NSMutableAttributedString // String
    {
        set {
            updateMapOnScreen()
        }
        get {
            // This should return aString (theFullMap)
            // but adjusted for the subbox that it is
            // so offset by X/Y tile that is at topLeft
            // Check that map is valid, otherwise print string: "Map Not Loaded Properly"
            if( campMap.mapTiles.count <= 0 )
            {
                return NSMutableAttributedString(string: "Map Not Loaded Properly campMap.mapTiles.count == \(campMap.mapTiles.count)")
            }
            
            var mapOnScreen = NSMutableAttributedString.init(string: "")
            
            for y in 0..<mapTileHeight
            {
                for x in 0..<mapTileWidth
                {
                    let theTile = campMap.mapTiles[x+currentMapXOffset][y+currentMapYOffset]
                    
                    mapOnScreen = mapOnScreen + theTile.getTile()
                    
/*                    if( theTile.hasWall ){
                        // Set Color depending on type of object
//                        let greenColor = UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 1)
                        let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor.gray];
                        let attributedString = NSMutableAttributedString(string: "\(blockChar)", attributes: attributedStringColor)
                        mapOnScreen = mapOnScreen + attributedString
//                            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: range)
                    }else if( theTile.hasFloor ){
                        let grassTile = NSMutableAttributedString(string: ",", attributes: [NSAttributedString.Key.foregroundColor : UIColor.green] )
                        mapOnScreen = mapOnScreen + grassTile// NSMutableAttributedString(string: ",")
                    }else{
//                        mapOnScreen += "\(blockChar)"
                        mapOnScreen = mapOnScreen + NSMutableAttributedString(string: "\(blockChar)")
                    }*/
                    
//mapOnScreen += aString[ (((y+currentMapYOffset)*totalMapWidth)+(x+currentMapXOffset)) ]
                }
            }
            let dontRange = (mapOnScreen.string as NSString).range(of: mapOnScreen.string)
            mapOnScreen.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Courier", size: 21.0)!, range: dontRange)
            return mapOnScreen
        }
        
    }
    
    var panDelay : Date = Date()
    
    
    // MARK: -  Important Mapping Stuff
    var fontSize : Int = 21
    var mapTileWidth : Int = 32
    var mapTileHeight : Int = 35
    
    //start with 0,0 offset
//    var currentMapOffset : CGPoint = CGPoint(x: 0, y: 0) // Again
    var currentMapXOffset : Int = 0
    var currentMapYOffset : Int = 5
    var globalPoint : CGPoint {
        get {
//            campView.superView!.convert(campView.frame.origin, to: nil)
            self.view.convert(campView.frame.origin, to: nil)
        }
    }
    
    
    
    // Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
 //        campView.textContainer.lineFragmentPadding = 0;
        
        // To Change color of a block
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTouchesRequired = 1
        campView.addGestureRecognizer(tap)
        
        
        // Now for two finger pan touch recognizer to move around the map
        // Handle one-finger pans
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(sceneViewPannedOneFinger))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        campView.addGestureRecognizer(panRecognizer)

        // Handle two-finger pans
//        let twoFingerPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(sceneViewPannedTwoFingers))
//        twoFingerPanRecognizer.minimumNumberOfTouches = 2
//        twoFingerPanRecognizer.maximumNumberOfTouches = 2
//        campView.addGestureRecognizer(twoFingerPanRecognizer)

        generateMap()
    }
    
    
    func offsetMapBy(x: Int, y: Int)
    {
        // TODO: Make sure to clamp to 0...99, can't go above or below
        var newX = currentMapXOffset - x
        var newY = currentMapYOffset - y
        
        if( newX < 0 ){
            newX = 0
        }
        if( newY < 0 ){
            newY = 0
        }
        if( newX > 68)
        {
            newX = 68
        }
        if( newY > 65)
        {
            newY = 65
        }
        print("Newoffset is: (\(newX),\(newY))")
        currentMapXOffset = newX
        currentMapYOffset = newY
        updateMapOnScreen()
    }

        
    

    //
    func generateMap(){
        if( campMap.mapTiles.count <= 100 ){
            campMap = MapGenerator.generateMap()
        }
        updateMapOnScreen()
        
    }
    
    func updateMapOnScreen()
    {
        campView.attributedText = tilesOnScreen
    }
    
    
    
    
    // Touch Stuff
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {

        let touchPoint = sender.location(in: self.view)

//        printLocalXY(point: convertToLocalXY(touchPoint))
//        printGlobalXY(point: convertToGLobalXY(convertToLocalXY(touchPoint)))
//        convertTpToLocalXY(touchPoint)
//        convertTpToGlobalXY(touchPoint)
            
        print("_______________________________________")
//        print("currentOffset: (\(currentMapXOffset),\(currentMapYOffset))")
//        printTpToGlobalXY(touchPoint)
//        printTpToLocalXY(touchPoint)
        printTpToGlobalAndLocalXY(touchPoint)
//        printLocalXYToGlobalXY()
        toggleBox(point: convertTpToLocalXY(touchPoint))
    }
    
    // Test Screen touching
    func toggleBox(point : Point)
    {
        campMap.mapTiles[point.x + currentMapXOffset][point.y + currentMapYOffset].hasWall = !campMap.mapTiles[point.x + currentMapXOffset][point.y + currentMapYOffset].hasWall
        updateMapOnScreen()
    }
    
        @objc func sceneViewPannedOneFinger(sender: UIPanGestureRecognizer) {
    //        print("one finger pan!!!")
    //    }
    //
    //       @objc func sceneViewPannedTwoFingers(sender: UIPanGestureRecognizer) {
            
    //            print("panDelay: \(panDelay) Date(): \(Date())")
                if( Date() >= panDelay ){
                    let velocity : CGPoint = sender.velocity(in: campView)
                    
                    
                    if(velocity.x > 0){
                        print("gesture went right \(velocity.x / 12.625)");
                    }
                    else{
                        print("gesture went left \(velocity.x / 12.625)");
                    }
                
                    if(velocity.y > 0){
                        print("gesture moving up \((velocity.y)/21)")
                    }
                    else{
                        print("gesture moving bottom \((velocity.y)/21)")
                    }
                    
                    offsetMapBy(x: Int(velocity.x/12.625/2.0), y: Int(velocity.y/21.0/2.0))
                    
                    panDelay = Date() + 0.5
                }
            
            }
    
    
   // MARK: - Coordinates

    // Conversions
    func convertTpToLocalXY(_ tp : CGPoint)->Point
    {
        
        let localX : Int = Int( tp.x/12.625 )
        let localY : Int = Int( (tp.y - 44.0 )/21.0 )//print("(\(localX),\(localY))")  // <- This is local
        return Point(x: localX, y :localY)
    }
    func convertTpToGlobalXY(_ tp: CGPoint)->Point
    {
        let globalX : Int = Int( Int(tp.x/12.625) + currentMapXOffset )
        let globalY : Int = Int( Int(tp.y-44.0)/21 + currentMapYOffset )
        return Point(x: globalX, y: globalY )
    }
    
    
    
    func convertLocalXYToGLobalXY(_ tp: Point)->Point
    {
        let globalX = Int(tp.x) + currentMapXOffset
        let globalY = Int(tp.y) + currentMapYOffset
        return Point(x: globalX, y: globalY)
    }
    
    
    // Printing Function
    func printTpToGlobalXY(_ tp: CGPoint){
        let globalX : Int = Int(tp.x/12.625) + Int(currentMapXOffset)
        let globalY : Int = Int((tp.y-44.0)/21.0)+currentMapYOffset
        print("globalxy: (\(globalX),\(globalY))")
    }
    func printTpToLocalXY(_ tp : CGPoint){
        print("localxy: (\(Int( tp.x/12.625)),\(Int((tp.y - 44.0 )/21.0)))")
    }
    func printTpToGlobalAndLocalXY(_ tp: CGPoint){
        print("globalxy: (\(Int(tp.x/12.625)+currentMapXOffset),\(Int(tp.y-44.0)/21+currentMapYOffset)) localxy: (\(Int( tp.x/12.625 )),\(Int((tp.y - 44.0 )/21.0)))")
    }
    
    
    func printLocalXYToLocalXY(point : Point)
    {
        print("localxy: (\(point.x),\(point.y))")
    }
    func printLocalXYToGlobalXY(point : Point)
    {
        print("globalxy: (\(point.x),\(point.y))")
    }
    func printLocalXYToGlobalAndLocalY(point : Point)
    {
//        print("localxy: \(2) globbalxy:\(2)")
    }
    
}


// Might put this in another file, anticipating a lot of clutter.
// Although, this is the ViewController, I should do all the simulation in a simulator class
// Will look into that once I get there.

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}



// concatenate attributed strings
func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}



// concatenate attributed strings
func + (left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}


