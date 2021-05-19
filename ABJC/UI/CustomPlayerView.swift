//
//  CustomPlayerView.swift
//  ABJC
//
//  Created by Stephen Byatt on 18/5/21.
//
import SwiftUI
import AVKit
import TVUIKit


struct AVPlayerView: UIViewControllerRepresentable {
    
    @Binding var player: AVPlayer
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.player = self.player
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        playerController.modalPresentationStyle = .fullScreen
        
        // init custom info panel here
        let customInfoPanel = UIViewController()
        customInfoPanel.preferredContentSize = CGSize(width: 300, height: 300)
        
        customInfoPanel.view = CustomInfoPanel()
        
        playerController.customInfoViewController = customInfoPanel
        return playerController
    }
}


class CustomInfoPanel: UIView {
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.setTitle("Test", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28,weight: .semibold)
        button.setTitleColor(.label, for: .focused)
        button.addTarget(self, action: #selector(self.buttonAction(sender:)), for: .primaryActionTriggered)
        
        let button2 = UIButton(frame: CGRect(x: 100, y: 0, width: 100, height: 100))
        button2.setTitle("Test 2", for: .normal)
        button2.setTitleColor(.lightGray, for: .normal)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 28,weight: .semibold)
        button2.setTitleColor(.label, for: .focused)
        button2.addTarget(self, action: #selector(self.buttonAction(sender:)), for: .primaryActionTriggered)
        
        
        self.addSubview(button)
        self.addSubview(button2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction(sender:UIButton!) {
        var btn:UIButton = sender
        btn.setTitle("Pressed", for: .normal)
        print("!~!~~~~~~~~ pressed button")
        
    }
    
}
