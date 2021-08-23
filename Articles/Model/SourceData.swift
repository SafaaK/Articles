//
//  SourceData.swift
//  Articles
//
//  Created by Safaa Khalaf on 20/8/21.
//

import Foundation

struct SourceData: Codable{
    let status: String
    let sources: [SourceItem]
}
  

struct SourceItem: Codable , Equatable{
    let id: String
    let name: String?
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let Country: String?
}
