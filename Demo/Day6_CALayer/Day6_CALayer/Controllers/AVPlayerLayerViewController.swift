
import UIKit
import AVFoundation

class AVPlayerLayerViewController: UIViewController {
    @IBOutlet weak var viewForPlayerLayer: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var rateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var loopSwitch: UISwitch!
    @IBOutlet weak var volumeSlider: UISlider!
    
    enum Rate: Int {
        case slowForward, normal, fastForward
    }
    
    let playerLayer = AVPlayerLayer()
    var player: AVPlayer? {
        return playerLayer.player
    }
    var rate: Float {
        switch rateSegmentedControl.selectedSegmentIndex {
        case 0:
            return 0.5
        case 2:
            return 2.0
        default:
            return 1.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rateSegmentedControl.selectedSegmentIndex = 1
        setUpPlayerLayer()
        viewForPlayerLayer.layer.addSublayer(playerLayer)
        //播放结束通知
        NotificationCenter.default.addObserver(self, selector: #selector(AVPlayerLayerViewController.playerDidReachEndNotificationHandler(_:)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player?.currentItem)
        playButton.setTitle("Pause", for: .normal)
    }
}

// MARK: - Layer setup
extension AVPlayerLayerViewController {
    func setUpPlayerLayer() {
        // 1  位置 大小
        playerLayer.frame = viewForPlayerLayer.bounds

        // 2 创建播放器
        let url = Bundle.main.url(forResource: "colorfulStreak", withExtension: "m4v")!
        let item = AVPlayerItem(asset: AVAsset(url: url))
        let player = AVPlayer(playerItem: item)

        // 3 播放结束后的动作
        player.actionAtItemEnd = .none

        // 4  播放声音 和  速率
        player.volume = 1.0
        player.rate = 1.0


        playerLayer.player = player
    }
}

// MARK: - IBActions
extension AVPlayerLayerViewController {
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if player?.rate == 0 {
            player?.rate = rate
            updatePlayButtonTitle(isPlaying: true)
        } else {
            player?.pause()
            updatePlayButtonTitle(isPlaying: false)
        }
    }
    //MARK: - 调整播放速率
    @IBAction func rateSegmentedControlChanged(_ sender: UISegmentedControl) {
        player?.rate = rate
        updatePlayButtonTitle(isPlaying: true)
    }
    
    @IBAction func loopSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            player?.actionAtItemEnd = .none
        } else {
            player?.actionAtItemEnd = .pause
        }
    }
    //MARK: - 调整声音
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        player?.volume = sender.value
    }
}

// MARK: - Triggered actions
extension AVPlayerLayerViewController {
    @objc func playerDidReachEndNotificationHandler(_ notification: Notification) {
        // 1
        guard let playerItem = notification.object as? AVPlayerItem else { return }

        // 2  跳转到初始播放
        playerItem.seek(to: .zero, completionHandler: nil)
            
        // 3
        if player?.actionAtItemEnd == .pause {
          player?.pause()
          updatePlayButtonTitle(isPlaying: false)
        }
    }
}

// MARK: - Helpers
extension AVPlayerLayerViewController {
    func updatePlayButtonTitle(isPlaying: Bool) {
        if isPlaying {
            playButton.setTitle("Pause", for: .normal)
        } else {
            playButton.setTitle("Play", for: .normal)
        }
    }
}
