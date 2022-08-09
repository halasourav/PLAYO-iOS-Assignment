//
//  ViewController.swift
//  PLAYO iOS Assignment
//
//  Created by Sourav Bhattacharjee on 09/08/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    let newsUrl = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=759e86f1ea40433e8ba4bba3ef9965ee"
    let header: HTTPHeaders = ["Accept": "application/json"]
    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task.init {
            do {
                let news = try await getNews()
                self.news.append(news)
            } catch {
                print("Error: Unable Fetch News")
            }
        }
    }

    func getNews() async throws -> News{
        return try await AF.request(newsUrl, method: .get, headers: header).serializingDecodable(News.self).value
    }

}

