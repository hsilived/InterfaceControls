 //
 //  AppUserDefaults.swift
 //  Nuke & Juke
 //
 //  Created by DeviL on 2015-10-17.
 //  Copyright © 2015 Orange Think Box. All rights reserved.
 //
 
import UIKit
import SpriteKit
import GameKit
 
class AppUserDefaults {

    let defaults = UserDefaults.standard
        
//    func resetGame() {
//
//        setBool(true, forKey: soundEffectsKey)
//        setBool(true, forKey: musicKey)
//        setBool(false, forKey: hideAdsKey)
//        setBool(true, forKey: runOnceKey)
//        setBool(false, forKey: firstSessionHelpKey)
//
//        setAmount(0, forKey: scoreKey)
//        setAmount(0, forKey: highScoreKey)
//        setAmount(0, forKey: averageScoreKey)
//        setAmount(0, forKey: totalScoreKey)
//        setAmount(0, forKey: gamesPlayedKey)
//        setAmount(50, forKey: soundLevelKey)
//        setAmount(50, forKey: musicLevelKey)
//
//        //team variables
//        let defaultname = "HEROES"
//        let defaultstadium = "Orange Think Box Place"
//        let defaultlocation = "Buffalo"
//        let defaultLogo = "field_logo"
//        let defaultprimaryColor = SKColorWithRGBA(r: 0, g: 165, b: 225, a: 255)//@"00A5E1"
//        let defaultScondaryColor = SKColorWithRGBA(r: 255, g: 80, b: 0, a: 255)//@"FF5000"
//        let defaultnumbersColor = SKColorWithRGBA(r: 255, g: 255, b: 255, a: 255)//@"FFFFFF"
//
//        setSavedData(name: defaultname, location: defaultlocation, stadium: defaultstadium, logo: defaultLogo, primaryColor: defaultprimaryColor, secondaryColor: defaultScondaryColor, numbersColor: defaultnumbersColor, defaultSettings: true)
//
//        let defaultQBName: String = "Joe Jones"
//        let defaultQBNumber: Int = 23
//        let defaultQBSkinTone = SKColorWithRGBA(r: 210, g: 134, b: 96, a: 255)//@"D28660"
//        setQB(name: defaultQBName, number: defaultQBNumber, skinTone: defaultQBSkinTone)
//
//
//        resetAchievements()
//
//        defaults.synchronize()
//        print("game has been reset!")
//    }
    
    //Ints
    func getAmount(forKey key: String) -> Int {
        return defaults.integer(forKey: key)
    }
    func setAmount(_ amount: Int, forKey key: String) {
        defaults.set(amount, forKey: key)
    }
    
    func getAmount(forKey key: String) -> Double {
        return defaults.double(forKey: key)
    }
    func setAmount(_ amount: Double, forKey key: String) {
        defaults.set(amount, forKey: key)
    }
    
    //Bools
    func getBool(forKey key: String) -> Bool {
        return defaults.bool(forKey: key)
    }
    func setBool(_ bool: Bool, forKey key: String) {
        defaults.set(bool, forKey: key)
    }
    
    //Dates
    func getDate(forKey key: String) -> Date {
        return (defaults.data(forKey: key) as AnyObject) as? Date ?? Date()
    }
    func setDate(_ date: Date, forKey key: String) {
        defaults.set(date, forKey: key)
    }
    
    //String
    func getString(forKey key: String) -> String {
        return defaults.string(forKey: key) ?? ""
    }
    func setString(_ text: String, forKey key: String) {
        defaults.set(text, forKey: key)
    }
    
    //Object
    func getObject(forKey key: String) -> AnyObject? {
        return defaults.object(forKey: key) as AnyObject
    }
    func setObject(_ object: AnyObject, forKey key: String) {
        defaults.set(object, forKey: key)
    }
    
    
    // MARK: - Team Info
    
    func setSavedData(name: String, location: String, favFruit: String, favColor: SKColor, puppyColor: SKColor, popupColor: SKColor, favNumber: Int) {
        
        var savedData = defaults.dictionary(forKey: "SavedData") as [String: AnyObject]?
        
        if savedData == nil {
            savedData = [String : AnyObject]()
        }
        
        //default settings are set to yes when the game is reset or just started and removed when a custom team is made
        savedData?["name"] = name as AnyObject
        savedData?["location"] = location as AnyObject
        savedData?["favFruit"] = favFruit as AnyObject
        savedData?["favColor"] = NSKeyedArchiver.archivedData(withRootObject: favColor) as AnyObject?
        savedData?["puppyColor"] = NSKeyedArchiver.archivedData(withRootObject: puppyColor) as AnyObject?
        savedData?["favNumber"] = favNumber as NSNumber
        savedData?["popupColor"] = NSKeyedArchiver.archivedData(withRootObject: popupColor) as AnyObject?

        setSaveData(savedData: savedData!)
    }
    
    func getSavedData() -> [String : AnyObject]? {
        
        var savedData = defaults.dictionary(forKey: "SavedData") as [String : AnyObject]?
        if savedData == nil {
            savedData = [String : AnyObject]()
        }
        
        return savedData
    }
    
    func setSaveData(savedData: [String : AnyObject]) {
        
        defaults.set(savedData, forKey: "SavedData")
    }
    
    func getname() -> String {
        
        let savedData = self.getSavedData()
        return savedData!["name"] as! String
    }
    
    func setname(name: String) {
        
        var savedData = self.getSavedData()
        savedData?["name"] = name as AnyObject?
        
        setSaveData(savedData: savedData!)
    }
    
    func getlocation() -> String {
        
        let savedData = self.getSavedData()
        return savedData!["location"] as! String
    }
    
    func setlocation(location: String) {
        
        var savedData = self.getSavedData()
        savedData?["location"] = location as AnyObject?
        
        setSaveData(savedData: savedData!)
    }
    
    func getlogo() -> String {
        
        let savedData = self.getSavedData()
        return savedData!["logo"] as! String
    }
    
    func setlogo(logo: String) {
        
        var savedData = self.getSavedData()
        savedData?["logo"] = logo as AnyObject?
        
        setSaveData(savedData: savedData!)
    }
    
    func getprimaryColor() -> SKColor {
        
        let savedData = self.getSavedData()
        return (NSKeyedUnarchiver.unarchiveObject(with: savedData!["primaryColor"] as! Data)! as? SKColor)!
    }
    
    func setprimaryColor(primaryColor: SKColor) {
        
        var savedData = self.getSavedData()
        savedData?["primaryColor"] = NSKeyedArchiver.archivedData(withRootObject: primaryColor) as AnyObject?
        
        setSaveData(savedData: savedData!)
    }
    
    func getsecondaryColor() -> SKColor {
        
        let savedData = self.getSavedData()
        return (NSKeyedUnarchiver.unarchiveObject(with: savedData!["secondaryColor"] as! Data)! as? SKColor)!
    }
    
    func setsecondaryColor(secondaryColor: SKColor) {
        
        var savedData = self.getSavedData()
        savedData?["secondaryColor"] = NSKeyedArchiver.archivedData(withRootObject: secondaryColor) as AnyObject?
        
        setSaveData(savedData: savedData!)
    }
    
    func getnumbersColor() -> SKColor {
        
        let savedData = self.getSavedData()
        return (NSKeyedUnarchiver.unarchiveObject(with: savedData!["numbersColor"] as! Data)! as? SKColor)!
    }
    
    func setnumbersColor(numbersColor: SKColor) {
        
        var savedData = self.getSavedData()
        savedData?["numbersColor"] = NSKeyedArchiver.archivedData(withRootObject: numbersColor) as AnyObject?
        setSaveData(savedData: savedData!)
    }
    
    //PuppyColor
    func getPuppyColor() -> SKColor {
        let savedData = self.getSavedData()
        return (NSKeyedUnarchiver.unarchiveObject(with: savedData!["PuppyColor"] as! Data)! as? SKColor)!
    }
    func setPuppyColor(color: SKColor) {
        var savedData = self.getSavedData()
        savedData?["PuppyColor"] = NSKeyedArchiver.archivedData(withRootObject: color) as AnyObject?
        self.setSaveData(savedData: savedData!)
    }
       
    //FavNumber
    func getFavNumber() -> Int {
        let savedData = self.getSavedData()
        return Int(savedData!["FavNumber"] as! NSNumber)
    }
    func setFavNumber(number: Int) {
        var savedData = self.getSavedData()
        savedData?["FavNumber"] = number as NSNumber
        self.setSaveData(savedData: savedData!)
    }
}
