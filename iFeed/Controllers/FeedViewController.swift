//
//  FeedViewController.swift
//  iFeed
//
//  Created by Tarokh on 8/20/20.
//  Copyright © 2020 Tarokh. All rights reserved.
//

import UIKit
import JGProgressHUD

class FeedViewController: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet var feedTableView: UITableView!
    
    
    
    //MARK: - Variables
    var url: String?
    var feedItems = [FeedModel]()
    var hud: JGProgressHUD?
    
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchRSS(url: url!)
        
        feedTableView.register(UINib(nibName: "Feed", bundle: nil), forCellReuseIdentifier: "feedCell")
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.isHidden = true
        
        hud = JGProgressHUD(style: .dark)
        hud?.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud?.show(in: self.view)
        
    }
    
    
    //MARK: - Function
    private func fetchRSS(url: String) {
        RSSParser.getRSSFeed(rss: url) { (rss, status) in
            for rssItems in rss!.items {
                let title = rssItems.title!
                let htmlURL = rssItems.link!
                let date = rssItems.pubDate!
                self.feedItems.append(FeedModel(title: title, htmlURL: htmlURL, date: self.getDate(date: date)))
                print("The feed items are: \(self.feedItems)")
            }
            DispatchQueue.main.async {
                self.hud?.dismiss(animated: true)
                self.feedTableView.isHidden = false
                self.feedTableView.reloadData()
            }
        }
    }
    
    private func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToURL" {
            if let indexPath = feedTableView.indexPathForSelectedRow {
                let webVC = segue.destination as? WebController
                let htmlItem = feedItems[indexPath.row].htmlURL
                webVC?.htmlURL = htmlItem
            }
        }
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedCell
        let feeds = feedItems[indexPath.row]
        cell.configCell(with: feeds)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToURL", sender: self)
    }
    
}
