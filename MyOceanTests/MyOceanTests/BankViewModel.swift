//
//  BankViewModel.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/26/24.
//

import Foundation

class BankViewModel {
    
    let account1 = BankAccount(initialBalance: 100)
    let account2 = BankAccount(initialBalance: 50)
    
    func transfer(amount: Int, from: BankAccount, to: BankAccount) async throws {
        let beforeRemain = await from.balanceConfig()
        print("beforeRemain", beforeRemain)
        
        let avilable = await from.withdraw(amount: amount)
        
        let afterRemain = await from.balanceConfig()
        print("afterRemain", afterRemain)
        await to.deposit(amount: avilable)
    }

    // 2개의 Task 블록은 동시에 실행되므로 어떤 작업이 먼저 시작될지 예측할 수 없음 + 어떤 작업이 먼저 종료될지 예측할 수 없음
    // 같은 블럭내에서는 순차적으로(동기적으로) 실행됨
    func update() async {
        
        // Task 1 블록이 먼저 수행된 경우
        // account2: 0
        // account1: 150
        // complete
        // account1: 50
        // account2: 100
        // complete
        
        // Task 2 블록이 먼저 수행된 경우
        // account1: 50
        // account2: 100
        // complete
        // account2: 25
        // account1: 175
        // complete
        
        Task {
            try await transfer(amount: 75, from: account2, to: account1)
            print("Transfer complete :: acccount2 => account1: 75")
        }
        
        Task {
            try await transfer(amount: 50, from: account1, to: account2)
            print("Trasnfer complete :: account1 => account2: 50")
        }
    }

    func config() async {
        Task {
            let balance1 = await account1.balanceConfig()
            let balance2 = await account2.balanceConfig()
            
            print("account1 balance1 = \(balance1), account2 balance2 = \(balance2)")
        }
    }
}
