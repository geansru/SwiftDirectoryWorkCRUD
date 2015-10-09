//
//  ViewController.swift
//  WorkWithFiles
//
//  Created by Dmitriy Roytman on 09.10.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//
import ZipZap
import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    var list = [String]()
    let fileManager = NSFileManager.defaultManager()
    var dest: String?
    var currentDir:String?
    lazy var baseDir: String = {
       let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return paths[0]
    }()
    // MARK: @IBOutlet
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    // MARK: @IBAction
    @IBAction func download() {
        let path = "http://www.litmir.co/BookFileDownloadLink/?id=259416"
        let url = NSURL(string: path)!
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let data = data {
                self.currentDir = self.baseDir + "/" + "fb2"
                if !self.checkCurrentDir() {
                    _ = try! self.fileManager.createDirectoryAtPath(self.currentDir!, withIntermediateDirectories: true, attributes: nil)
                }
                self.unarchive(data)
            }
        }
        dataTask.resume()
    }
    
    @IBAction func create(sender: AnyObject) {
        textField.resignFirstResponder()
        if textField.text!.isEmpty {
            print("textField is empty")
        } else {

            let newDirName = textField.text!
            currentDir = baseDir + "/" + newDirName
            if checkCurrentDir() { return }
            try! fileManager.createDirectoryAtPath(currentDir!, withIntermediateDirectories: true, attributes: nil)
            checkCurrentDir()
        }
    }
    
    @IBAction func listDir() {
        if currentDir != nil {
            list = try! fileManager.contentsOfDirectoryAtPath(currentDir!)
        } else {
            print("Current dir is nil please create/choose current directory.")
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Helper
    func unarchive(data: NSData) {

        do {
            let archive = try ZZArchive(data: data)
            var index = 0
            for e in archive.entries {
                let data = try! e.newData()
                let name = String(format: "%2i.fb2", index)
                save(data, name: name)
                index++
            }
        } catch _ {
            
        }
    }
    
    func save(data: NSData, name: String) {
//        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
        let path = currentDir! + "/" + name
        if !fileManager.fileExistsAtPath(currentDir!) {
            _ = try! fileManager.createDirectoryAtPath(currentDir!, withIntermediateDirectories: true, attributes: nil)
        }
        fileManager.createFileAtPath(path, contents: data, attributes: nil)
    }
    
    
    func checkCurrentDir() -> Bool {
        if fileManager.fileExistsAtPath(currentDir!) {
            print("\(currentDir)")
            return true
        } else {
            print("\(currentDir) is not exists")
        }
        return false
    }
    
    func configureView() {
        createButton.layer.cornerRadius = 5
        createButton.layer.masksToBounds = true
    }

}

