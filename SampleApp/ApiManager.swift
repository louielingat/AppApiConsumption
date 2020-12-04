//
//  ApiManager.swift
//  SampleApp
//
//  Created by Louielar Lingat on 03/12/2020.
//  Copyright © 2020 UBX. All rights reserved.
//

import Alamofire

/*
 {
   "ownerAddress": "0x629c6ddDBE95ce177ed2Fda98D7C387BC2539798",
   "ownerPrivateKey": "0x4c81466a24dc352bf8afd0ac4b232d13961cbcb9a9a1fe71c57f665d29371223",
 
   "senderAddress": "0xE0bC64B6b395A8373a901B02264C8D34F5FD2310",
   "senderPrivateKey": "0x2760e631ba91057d83e25e2d9e191da7e93ae92b9d8c3d9426555083256979e0",
 
   "recipientAddress": "0x92323C77F55EC43911Bcb2152776baA08469218E"
 }
 */

class ApiManager: ObservableObject {
    @Published var totalSupply = "---"
    @Published var ownerBalance = "---"
    @Published var acct1Balance = "---"
    @Published var acct2Balance = "---"
    @Published var balance = "---"
    @Published var transferMsg = "---"
    @Published var approvalMsg = "---"
    
    init() {
        getTotalSupply()
        getAllBalances()
    }
    
    let domain = "http://nexus-dev.ubx.ph:8080/api/wallet/"
    
    func getTotalSupply() {
        var request = URLRequest(url:URL(string: "\(domain)totalSupply")!)
        
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request).validate(statusCode:200..<600).responseJSON() {(response) -> Void in
            
            do {
                let jsonModel = try JSONDecoder().decode(TotalSupply.self, from: response.data!)
                self.totalSupply = jsonModel.totalSupply
            } catch let parsingError {
                print("Error parsing json: \(parsingError)")
            }
        }
    }
    
    func getBalanceOf(address: String, type: String) {
        var request = URLRequest(url:URL(string: domain + "balances/" + address)!)
        
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request).validate(statusCode:200..<600).responseJSON() {(response) -> Void in
            
            do {
                let jsonModel = try JSONDecoder().decode(Balance.self, from: response.data!)
                switch(type) {
                    case "acct1":
                        self.acct1Balance = jsonModel.balance
                    break
                    case "acct2":
                        self.acct2Balance = jsonModel.balance
                    break
                    case "owner":
                        self.ownerBalance = jsonModel.balance
                    break
                    
                default:
                    self.balance = jsonModel.balance
                    break
                }
                
            } catch let parsingError {
                print("Error parsing json: \(parsingError)")
            }
        }
    }
    
    func getAllBalances() {
        getBalanceOf(address: "0x629c6ddDBE95ce177ed2Fda98D7C387BC2539798",
                     type: "owner")
        getBalanceOf(address: "0xE0bC64B6b395A8373a901B02264C8D34F5FD2310",
                     type: "acct1")
        getBalanceOf(address: "0x92323C77F55EC43911Bcb2152776baA08469218E",
                     type: "acct2")
    }
    
    func moveFundsFrom(sender: String = "", with pKey: String, to recipient: String, amount: Int) {
        var request = URLRequest(url:URL(string: domain + "transfer")!)
        var params = ["recipient":recipient,
                      "amount":amount] as [String : Any]
        
        if (sender != "") {
            params["sender"] = ["address":sender,
                                "privateKey":pKey] as [String : Any]
            
        }
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Error")
            return
        }
        
        Alamofire.request(request).validate(statusCode:200..<600).responseJSON() {(response) -> Void in
            
            do {
                let jsonModel = try JSONDecoder().decode(Message.self, from: response.data!)
                self.transferMsg = jsonModel.message
            } catch let parsingError {
                print("Error parsing json: \(parsingError)")
            }
        }
    }
    
    func approve(sender: String, amount: Int) {
        var request = URLRequest(url:URL(string: "\(domain)approve")!)
        let params = ["sender":sender,
                      "amount":amount] as [String : Any]
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Error")
            return
        }
        
        Alamofire.request(request).validate(statusCode:200..<600).responseJSON() {(response) -> Void in
            
            do {
                let jsonModel = try JSONDecoder().decode(Message.self, from: response.data!)
                self.approvalMsg = jsonModel.message
            } catch let parsingError {
                print("Error parsing json: \(parsingError)")
            }
        }
    }
}
