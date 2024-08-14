//
//  Network.swift
//  SportsApp
//
//  Created by  sherouk ahmed  on 12/08/2024.
//

import Foundation
import Alamofire

class Network : Networkprotocol{
    
    func fetch<T: Codable>(url: String, type: T.Type, complitionHandler: @escaping (T?)->Void) {
        let url = URL(string:url)
        guard let newURL = url else {
            complitionHandler(nil)
            return  }
        print("Fetching data from URL: \(newURL)")
        AF.request(newURL).response { data in
            guard let data = data.data else {
                complitionHandler(nil)
                return  }
            print("fetching in background")
            do{
                let result = try JSONDecoder().decode(T.self, from: data)
                complitionHandler(result)
            }catch let error{
                print(error.localizedDescription)
                complitionHandler(nil)
            }
        }
    }
    
}
