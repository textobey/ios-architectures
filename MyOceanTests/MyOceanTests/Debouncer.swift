//
//  Debouncer.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/21/24.
//

import Foundation

public class Debouncer {
    
    private let timeInterval: TimeInterval
    private var timer: Timer?
    
    typealias Handler = () -> Void
    var handler: Handler?
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    // MARK: Debouncer 코드의 매커니즘
    
    // 항상 기존 타이머는 무효화 하고, 새로운 입력값에 대한 타이머를 생성함
    // 이를 통해, 디바운서의 역할대로 짧은 시간(해당 테스트에서는 0.3초)안에 입력되는 값 중 가장 마지막 값만 취득하는 것이 가능
    public func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] (timer) in
            self?.timeIntervalDidFinish(for: timer)
        })
    }
    
    @objc private func timeIntervalDidFinish(for timer: Timer) {
        guard timer.isValid else {
            return
        }
        
        handler?()
        handler = nil
    }
    
}
