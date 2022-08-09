//
//  Model.swift
//  PLAYO iOS Assignment
//
//  Created by Sourav Bhattacharjee on 09/08/22.
//

import Foundation

struct News: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
}
