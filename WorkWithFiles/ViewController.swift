//
//  ViewController.swift
//  WorkWithFiles
//
//  Created by Dmitriy Roytman on 09.10.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    var list = [String]()
    let fileManager = NSFileManager.defaultManager()
    var currentDir:String?
    lazy var baseDir: String = {
       let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return paths[0]
    }()
    // MARK: @IBOutlet
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: @IBAction
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: Helper
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

