//
//  ViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 10/14/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit
import AVKit

final class MainViewController: UIViewController {
    
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        setUpVideo()
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    deinit {
        logger()
    }
    
    private func setupView() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
    
    @IBAction func siginUpButtonTapped(_ sender: Any) {
//        App.shared.switchToSignUp()
//        navigationController?.pushViewController(UIStoryboard.SignUpViewController, animated: true)
        show(UIStoryboard.SignUpViewController, sender: self)
    }
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
//        App.shared.switchToLogin()
//        navigationController?.pushViewController(UIStoryboard.LoginViewController, animated: true)
        show(UIStoryboard.LoginViewController, sender: self)
    }
    
//    func setUpVideo() {
//        // Get the path to the resource in the bundle
//        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
//
//        guard bundlePath != nil else {
//            return
//        }
//
//        // Create a URL from it
//        let url = URL(fileURLWithPath: bundlePath!)
//
//        // Create the video player item
//        let item = AVPlayerItem(url: url)
//
//        // Create the player
//        videoPlayer = AVPlayer(playerItem: item)
//
//        // Create the layer
//        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
//
//        // Adjust the size and frame
//        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width * 1.5, y: 0, width: self.view.frame.size.width * 4, height: self.view.frame.size.height)
//
//        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
//
//        // Add it to the view and play it
//        videoPlayer?.playImmediately(atRate: 0.3)
//    }

}
