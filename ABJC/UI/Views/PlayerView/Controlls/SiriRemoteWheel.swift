//
//  SiriRemoteWheel.swift
//  ABJC
//
//  Created by Noah Kamara on 27.11.21.
//

import Foundation
import GameController

class SiriRemoteWheel: ObservableObject {
    @Published var touchPosition: CGPoint = .zero
    @Published var value: Float = 0.5
    @Published var currentRadians: Float = 0
    
    init() {
        setUpControllerObserver()
    }
    
    private func setUpControllerObserver() {
        NotificationCenter.default.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { notification in
            print("CONNECTED")
            self.controllerConnected(notification)
        }
    }
    
    private func controllerConnected(_ note: Notification) {
        
        // Only considering a single controller for simplicity
        guard let controller = GCController.controllers().first else { return }
        
        guard let micro = controller.microGamepad else { return }
        micro.reportsAbsoluteDpadValues = true
        
        micro.dpad.valueChangedHandler = { [weak self] (pad, x, y) in
            guard let self = self else {
                return
            }
            self.touchPosition = .init(x: CGFloat(x), y: CGFloat(y))
            
            let radius = sqrt(x*x + y*y)
            
            // Test if touch is on wheel
            guard radius > 0.5 else {
                return
            }
            
            
            let cos = x / radius
            let sin = y / radius
            let radians = atan2(sin, cos)
            
            // Get and rotation direction
            let normalizedRadians = (radians + (2 * .pi)).truncatingRemainder(dividingBy: 2 * .pi)
            
            let radiansOffset = normalizedRadians - self.currentRadians
            let normalizedRadiansOffset = (radiansOffset + (2 * .pi)).truncatingRemainder(dividingBy: 2 * .pi)
            
            
            if normalizedRadiansOffset > .pi {
                self.value = min(1, self.value + 0.001)
            }
            else {
                self.value = max(0, self.value - 0.001)
            }
            
            self.currentRadians = normalizedRadians
        }
    }
}
