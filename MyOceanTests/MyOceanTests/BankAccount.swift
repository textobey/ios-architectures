//
//  BankAccount.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/26/24.
//

import Foundation

actor BankAccount {
    
    private var balance: Int
    
    init(initialBalance: Int) {
        balance = initialBalance
    }
    
    func deposit(amount: Int) {
        balance += amount
    }
    
    func withdraw(amount: Int) -> Int {
        if balance >= amount {
            balance -= amount
            return amount
        } else {
            let avilable = balance
            balance = 0
            return avilable
        }
    }
    
    func balanceConfig() -> Int {
        return self.balance
    }
}
