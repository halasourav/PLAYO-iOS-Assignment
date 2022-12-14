//
//  ViewController.swift
//  PLAYO iOS Assignment
//
//  Created by Sourav Bhattacharjee on 09/08/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let newsApi = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=759e86f1ea40433e8ba4bba3ef9965ee"
    let header: HTTPHeaders = ["Accept": "application/json"]
    
    var newsUrl = ""
    
    var news = [News]()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsTableView.refreshControl = refreshControl
        updateNewsTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news[0].articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCell", for: indexPath) as! NewsTableViewCell
        cell.newsTitle.text = news[0].articles[indexPath.row].title
        cell.newsBody.text = news[0].articles[indexPath.row].description
        cell.author.text = news[0].articles[indexPath.row].author
        do {
            guard let imageUrl = URL(string: news[0].articles[indexPath.row].urlToImage) else {
                print("Image URL invalid")
                return cell
            }
            let data = try Data(contentsOf: imageUrl)
            DispatchQueue.main.async {
                cell.newsImage.image = UIImage(data: data)
            }
        } catch {
            print("Unable to load image")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsUrl = news[0].articles[indexPath.row].url
        performSegue(withIdentifier: "NewsDetailsSegue", sender: self)
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
        }
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newsDetailsVC = segue.destination as? NewsDetails

        newsDetailsVC?.loadView()
        newsDetailsVC?.newsUrl = newsUrl
        
    }

}


extension ViewController {
    
    func getNews() async throws -> News{
        return try await AF.request(newsApi, method: .get, headers: header).serializingDecodable(News.self).value
    }
    
    func updateNewsTable() {
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        Task.init {
            do {
                let news = try await getNews()
                self.news.append(news)
                newsTableView.delegate = self
                newsTableView.dataSource = self
                newsTableView.reloadData()
                activityIndicator.stopAnimating()
            } catch {
                print("Error: Unable Fetch News")
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing News")
        updateNewsTable()
        refreshControl.endRefreshing()
    }
    
}

