//
//  HomeArticListModel.swift
//  wazDemo
//
//  Created by cbkj on 2021/7/15.
//

import Foundation

// MARK: - Banner
struct HomeBannerModel: Decodable, Identifiable {
    var desc: String
    var id: Int
    var imagePath: String
    var isVisible: Int
    var order: Int
    var title: String
    var type: Int
    var url: String
}

extension HomeBannerModel: CustomStringConvertible {
    var description: String {
        return "id: \(id), imagePath: \(imagePath), title: \(title), type: \(type)"
    }
}

// MARK: - Artic
class HomeArticListModel: Codable {
    
//    var apkLink: String
//    var audit: Int
//    var author: String
//    var canEdit: Int?
//    var chapterId: Int
//    var chapterName: String
//    var collect: Int
//    var courseId: Int
//    var desc: String
//    var descMd: String
//    var envelopePic: String
//    var fresh: String
//    var host: String
    var id: Int
    var niceDate: String
//    var niceShareDate: String
//    var origin: String
//    var prefix: String
//    var projectLink: String
//    var publishTime: Int
//    var realSuperChapterId: Int
//    var selfVisible: Int
//    var shareDate: Int
//    var shareUser: String
//    var superChapterId: Int
//    var superChapterName: String
//    var tags: [Int]
    var title: String
    var link: URL
//    var type: Int
//    var userId: String
//    var visible: Int
//    var zan: Int
}

extension HomeArticListModel: CustomStringConvertible {
    var description: String {
        return "niceDate: \(niceDate), title:\(title)"
    }
}

extension HomeArticListModel: Identifiable { }


struct ArticBaseModel: Codable {
    var data: ArticDatasModel
}

struct ArticDatasModel: Codable {
    var curPage: Int
    var datas: [HomeArticListModel]
}
