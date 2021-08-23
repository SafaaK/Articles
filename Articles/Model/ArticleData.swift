//
//  Article.swift
//  Articles
//
//  Created by Safaa Khalaf on 20/8/21.
//

import Foundation

struct ArticleData: Codable,Equatable{
    let status: String
    let totalResults: Int
    let articles: [Article]  
}
  

struct Article: Codable,Equatable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable, Equatable {
    let name: String?
    let id: String?
}

