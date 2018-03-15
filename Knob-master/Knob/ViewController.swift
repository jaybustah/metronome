

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var knob: Knob!
    @IBOutlet weak var BPM_label: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    /////
    var metronomeTimer: Timer!
    var metronomeIsOn = false
    var metronomeSoundPlayer: AVAudioPlayer!
    var metronomeAccentPlayer: AVAudioPlayer!
    /////
    
    var bpm: Double = 90
    var lastPos: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    @IBAction func toggleClick(_ sender: UIButton!) {
        if metronomeIsOn {
      //      stopMetronome(sender)
        } else {
        //    startMetronome(sender)
        }
        
        func stopMetronome(_ sender: UIButton) {
            metronomeIsOn = false
            metronomeTimer?.invalidate()
            //count = 0
            sender.setTitle("Start", for: UIControlState())
        }
        
        func startMetronome(_ sender: UIButton) {
            metronomeIsOn = true
            sender.setTitle("Stop", for: UIControlState())
            let metronomeTimeInterval:TimeInterval = (240.0 / Double(tsLower)) / bpm
            metronomeTimer = Timer.scheduledTimer(timeInterval: metronomeTimeInterval, target: self, selector: #selector(playMetronomeSound), userInfo: nil, repeats: true)
            metronomeTimer?.fire()
        }
 
        
    }
*/
    @IBAction func knobRotated(_ sender: Knob) {
        super.viewDidLoad()
        
        var diff: Double
        diff = (knob.value) - lastPos
        
        if ((diff) > M_PI)
        {
            diff -= 2 * M_PI
        }
        else if (diff < -M_PI)
        {
            diff += 2 * M_PI}
        
        lastPos = knob.value
        bpm += diff * 10
        
        var feedbackGenerator : UISelectionFeedbackGenerator? = nil
        
        if(bpm < 30)
        {
            bpm = 30
            knob.tintColor = UIColor.red
            knob.isEnabled = false
                        generator.notificationOccurred(.error)
            //knob.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        }
        else if (bpm < 400 && bpm > 30)
        {
            knob.tintColor = UIColor.blue
            knob.isEnabled = true
            //knob.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        }
        else if (bpm > 400)
        {
            bpm = 400
            knob.tintColor = UIColor.red
            knob.isEnabled = false
            
            generator.notificationOccurred(.error)
            //knob.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        }
        
        print("value: \(knob.value)")
        if 30...400 ~= bpm {
        BPM_label?.text = (String(format: "%.0f", bpm)) // zero decimal places
        }
        
        
 //
 let metronomeSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "snizzap1", ofType: "wav")!)
 let metronomeAccentURL = URL(fileURLWithPath: Bundle.main.path(forResource: "snizzap2", ofType: "wav")!)
 /*
 metronomeSoundPlayer = try? AVAudioPlayer(contentsOf: metronomeSoundURL)
 metronomeAccentPlayer = try? AVAudioPlayer(contentsOf: metronomeAccentURL)
 
 metronomeSoundPlayer.prepareToPlay()
 metronomeAccentPlayer.prepareToPlay()
 */
    }
}

