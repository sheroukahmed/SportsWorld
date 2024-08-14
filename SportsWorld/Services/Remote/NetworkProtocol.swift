//
//  NetworkProtocol.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 13/08/2024.
//

import Foundation

protocol Networkprotocol {

   func fetch<T: Codable>(url: String, type: T.Type, complitionHandler: @escaping (T?)->Void)
}
