//
//  ViewController.swift
//  iFeed
//
//  Created by Tarokh on 8/19/20.
//  Copyright © 2020 Tarokh. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreData
import DZNEmptyDataSet

class HomeViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet var iFeedTableView: UITableView!
    @IBOutlet var deleteItem: UIBarButtonItem!
    @IBOutlet var addItem: UIBarButtonItem!
    
    
    
    //MARK: - Variables
    var iFeedItems: [NSManagedObject] = []
    var managedContext: NSManagedObjectContext?
    var newFeedItems: NSManagedObject?
    
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iFeedTableView.register(UINib(nibName: "iFeed", bundle: nil), forCellReuseIdentifier: "iFeedCell")
        iFeedTableView.delegate = self
        iFeedTableView.dataSource = self
        
        iFeedTableView.emptyDataSetSource = self
        iFeedTableView.emptyDataSetDelegate = self
        
        iFeedTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        iFeedItems = []
        iFeedTableView.separatorStyle = .none
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Feed")
        do {
            let feeds = try managedContext?.fetch(fetchRequest)
            for data in feeds! {
                iFeedItems.append(data)
                DispatchQueue.main.async {
                    self.iFeedTableView.separatorStyle = .singleLine
                    self.iFeedTableView.reloadData()
                }
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    

    //MARK: - Functions
    @IBAction func deleteFeed(_ sender: UIBarButtonItem) {
        iFeedTableView.isEditing = true
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            shouldAutoDismiss: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        let textfield = alertView.addTextField("https://www.example.com/rss")
        textfield.delegate = self
        alertView.addButton("Add") {
            self.addFeed(url: textfield.text!)
        }
        
        alertView.showEdit("Feed", subTitle: "Enter Your RSS Feed URL", colorStyle: 0xF9A42E)
        
    }
    
    private func addFeed(url: String) {
        RSSParser.getRSSFeed(rss: url) { (rss, status) in
            let title = rss?.title
            let feedDescription = rss?.feedDescription
            //let countInt: Int? = rss?.items.count
            //let countString = "\(countInt!)"
            self.save(title: title!, url: url, description: feedDescription ?? "")
            print(rss!)
        }
    }
    
    func save(title: String, url: String, description: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Feed", in: managedContext)
        let feeds = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        feeds.setValue(title, forKey: "title")
        feeds.setValue(url, forKey: "rss")
        feeds.setValue(description, forKey: "feedDescription")
        //feeds.setValue(count, forKey: "count")
        iFeedItems.append(feeds)
        
        do {
            try managedContext.save()
            print("Data Saved Successfully!")
            DispatchQueue.main.async {
                self.iFeedTableView.separatorStyle = .singleLine
                self.iFeedTableView.beginUpdates()
                self.iFeedTableView.insertRows(at: [IndexPath(row: self.iFeedItems.count - 1, section: 0)], with: .automatic)
                self.iFeedTableView.reloadData()
                self.iFeedTableView.endUpdates()
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFeed" {
            if let indexPath = self.iFeedTableView.indexPathForSelectedRow {
                let feedVC = segue.destination as? FeedViewController
                let item = iFeedItems[indexPath.row]
                feedVC?.url = item.value(forKey: "rss") as? String
            }
        }
    }

}

//MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iFeedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iFeedCell") as! iFeedCell
        let item = iFeedItems[indexPath.row]
        cell.titleLabel.text = item.value(forKey: "title") as? String
        if item.value(forKey: "feedDescription") as? String == "" {
            cell.aboutLabel.text = item.value(forKey: "rss") as? String
        }
        else {
            cell.aboutLabel.text = item.value(forKey: "feedDescription") as? String
        }
        
        cell.countLabel.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToFeed", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            
            context.delete(iFeedItems[indexPath.row] as NSManagedObject)
            iFeedItems.remove(at: indexPath.row)
            
            do {
                try context.save()
                self.iFeedTableView.deleteRows(at: [indexPath], with: .fade)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
}

//MARK: - DZNEmptyDataSetDelegate, DZNEmptyDataSetSource
extension HomeViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "Please add some rss feeds!"

        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        
        

        return NSAttributedString(string: text, attributes: attributes)
    }

    
}
