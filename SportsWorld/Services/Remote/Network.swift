//
//  Network.swift
//  SportsApp
//
//  Created by  sherouk ahmed  on 12/08/2024.
//

import Foundation
import Alamofire

class Network {
    
    func fetch<T: Codable>(url: String, type: T.Type, complitionHandler: @escaping (T?)->Void) {
        let url = URL(string:url)
        guard let URL = url else { return  }
        AF.request(URL).response { data in
            
            guard let data = data.data else { return  }
           
            do{
                let result = try JSONDecoder().decode(T.self, from: data)
                //print(result)
                complitionHandler(result)
            }catch let error{
                print(error)
                complitionHandler(nil)
            }
        }
    }
    
}
