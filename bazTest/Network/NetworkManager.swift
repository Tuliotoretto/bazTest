//
//  NetworkManager.swift
//  bazTest
//
//  Created by Julian Garcia  on 17/06/23.
//

import UIKit

class NetworkManager: NSObject {
    static public let shared = NetworkManager()
    
    private override init() {
        super.init()
    }
    
    func loadShowsBy(page: Int, callback: @escaping ([Show]?) -> Void) {
        let url = URL(string: "https://api.tvmaze.com/shows?page=\(page)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let result: [Show]?
            
            if let data = data, error == nil {
                result = try? JSONDecoder().decode([Show].self, from: data)
            } else {
                result = nil
            }
            
            DispatchQueue.main.async {
                callback(result)
            }
        }
        
        task.resume()
    }
    
    @discardableResult
    func loadImage(forURL url: URL, callback: @escaping (UIImage?) -> Void) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let result: UIImage?
            
            if let data = data, error == nil {
                result = UIImage(data: data)
            } else {
                result = nil
            }
            
            DispatchQueue.main.async {
                callback(result)
            }
        }
        
        task.resume()
        
        return task
    }
}
