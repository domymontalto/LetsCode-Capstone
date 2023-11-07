//
//  PlayerViewController.swift
//  LetsCode
//
//  Created by Domenico Montalto on 11/6/23.
//

import SwiftUI
import AVKit

struct PlayerViewController: UIViewControllerRepresentable {
    
    @ObservedObject var model:ContentModel
    
    var videoURL: URL?
    
    private var player: AVPlayer {
        return AVPlayer(url: videoURL!)
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        
        //Make and return an instance of the AVPlayerController
        let controller = AVPlayerViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.player = player
        
        return controller
    }
    
    func updateUIViewController(_ playerViewController: AVPlayerViewController, context: Context) {
        
        //Updates the AVPlayerController with the new url
        if let videoURL = videoURL {
            playerViewController.player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
        }
        
        //Control playback based on isPlaying value
        if model.isPlaying {
            playerViewController.player?.play()
        } else {
            playerViewController.player?.pause()
        }
        
    }
    

}

//#Preview {
//    PlayerViewController()
//}
