//
//  ContentView.swift
//  SampleApp
//
//  Created by Louielar Lingat on 30/11/2020.
//  Copyright © 2020 UBX. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var uname = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sample App Login")
                    .bold()
                
                TextField("Username", text: $uname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
                
                TextField("Password", text: $uname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                NavigationLink(destination: ContentViewB()) {
                    Text("Login")
                }
            }
        }
    }
}

struct ContentViewB : View {
    var body: some View {
        NavigationView {
            VStack{
                Section {
                    TotalSupplyAndBalances()
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
                
                Section {
                    ApprovalContenView()
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
                
                Section {
                    TransferFundsView()
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
            }
            
        }.navigationBarTitle("")
            .navigationBarHidden(true)
    }
}

struct TotalSupplyAndBalances: View {
    @State private var address = ""
    @State private var balance = ""
    
    @ObservedObject var apiManager = ApiManager()
    
    func getAmt() -> String {
        return apiManager.totalSupply
    }
    
    func getBalance() -> String {
        return apiManager.balance
    }
    
    func getOwnerBalance() -> String {
        return apiManager.ownerBalance
    }
    
    func getAcct1Balance() -> String {
        return apiManager.acct1Balance
    }
    
    func getAcct2Balance() -> String {
        return apiManager.acct2Balance
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Total Supply:").bold()
                Text(getAmt())
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
            HStack {
                Text("Owner Wallet Balance").bold()
                Text(getOwnerBalance())
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
            HStack {
                Text("Account 1 Balance").bold()
                Text(getAcct1Balance())
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
            HStack {
                Text("Account 2 Balance").bold()
                Text(getAcct2Balance())
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
            Button(action: {
                self.apiManager.getAllBalances()
            }) {
                Text("Get All Balances")
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
            
            HStack {
                Text("Balance:").bold()
                Text(getBalance())
            }
            
            TextField("Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
            
            Button(action: {
                self.apiManager.getBalanceOf(address: self.address, type: "no")
            }) {
                Text("Get Balance")
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
        }
    }
}

struct ApprovalContenView: View {
    @State private var address = ""
    @State private var amount = ""
    @ObservedObject var apiManager = ApiManager()
    
    func getApprovalMsg() -> String {
        return apiManager.approvalMsg
    }
    
    var body: some View {
        VStack {
            Text("Approval:").bold()
            Text(getApprovalMsg())
            
            TextField("Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Amount", text: $amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                self.apiManager.approve(sender: self.address, amount: Int(self.amount) ?? 0)
            }) {
                Text("Approve")
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
        }
    }
}

struct TransferFundsView: View {
    @State private var sAdd = ""
    @State private var pKey = ""
    @State private var rAdd = ""
    @State private var amount = ""
    @ObservedObject var apiManager = ApiManager()
    
    func getTransferMsg() -> String {
        return apiManager.transferMsg
    }
    
    var body: some View {
        VStack {
            Text("Transfer:").bold()
            Text(getTransferMsg())
            
            TextField("Sender Address", text: $sAdd)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Private Key", text: $pKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Recipient Address", text: $rAdd)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Amount", text: $amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            Button(action: {
                self.apiManager.moveFundsFrom(sender: self.sAdd, with: self.pKey, to: self.rAdd, amount: Int(self.amount) ?? 0)
            }) {
                Text("Transfer")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

