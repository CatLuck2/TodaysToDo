//
//  PlayerView.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/12.
//

import AVKit

class PlayerView: UIView {

    // The player assigned to this view, if any.

    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }

    // The layer used by the player.

    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }

    // Set the class of the layer for this view.
    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }
}
