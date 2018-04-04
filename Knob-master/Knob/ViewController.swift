

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    @IBOutlet weak var knob: Knob! 
    @IBOutlet weak var BPMlabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tempoStepper: UIStepper!
    @IBOutlet weak var tsUpperLabel: UILabel!
    @IBOutlet weak var tsLowerLabel: UILabel!
    @IBOutlet weak var tsUpperStepper: UIStepper!
    @IBOutlet weak var tsLowerStepper: UIStepper!
    
    var bpm: Double = 90
    var lastPos: Double = 0
    
    var metronomeTimer: Timer!
    var metronomeIsOn = false
    var metronomeSoundPlayer: AVAudioPlayer!
    var metronomeAccentPlayer: AVAudioPlayer!
    
    var count: Int = 0 {
        didSet {
            if count == 0 {
                countLabel.text = String(tsUpper)
            } else {
                countLabel.text = String(count)
            }
        }
    }
   
    var tempo: TimeInterval = 90 {
        didSet {
            //BPMlabel.text = String(format: "%.0f", bpm)
            tempoStepper.value = bpm
        }
    }
 
    var tsUpper: Int = 4 {
        didSet {
            tsUpperLabel.text = String(tsUpper)
            tsUpperStepper.value = Double(tsUpper)
        }
    }
    var tsLower: Int = 4 {
        didSet {
            tsLowerLabel.text = String(tsLower)
            tsLowerStepper.value = Double(tsLower)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempoStepper.autorepeat = true
        //bpm = 90
        tsUpper = 4
        tsLower = 4
       
        
        let metronomeSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "snizzap1", ofType: "wav")!)
        let metronomeAccentURL = URL(fileURLWithPath: Bundle.main.path(forResource: "snizzap2", ofType: "wav")!)
        
        metronomeSoundPlayer = try? AVAudioPlayer(contentsOf: metronomeSoundURL)
        metronomeAccentPlayer = try? AVAudioPlayer(contentsOf: metronomeAccentURL)
        
        metronomeSoundPlayer.prepareToPlay()
        metronomeAccentPlayer.prepareToPlay()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepTempo(_ sender: UIStepper) {
        //BPMlabel.text = "\(Double(sender.value))"
        //bpm += sender.value
        //bpm += tempoStepper.value
        var value = tempoStepper.value
        
        if (tempoStepper.value > value) {
            value += 1
        } else {
            value -= 1
        }
        
        BPMlabel?.text = (String(format: "%.0f", bpm + value))
        
        restartMetronome()
    }
   
    
    @IBAction func stepTsUpper(_ sender: UIStepper) {
        tsUpper = Int(sender.value)
        
        restartMetronome()
    }
    
    
    @IBAction func stepTsLower(_ sender: UIStepper) {
        tsLower = Int(sender.value)
        restartMetronome()
    }
    
    
    @IBAction func toggleClick(_ sender: UIButton) {
        if metronomeIsOn {
            stopMetronome(sender)
        } else {
            startMetronome(sender)
        }
    }
  
    func stopMetronome(_ sender: UIButton) {
        metronomeIsOn = false
        metronomeTimer?.invalidate()
        count = 0
        sender.setTitle("Start", for: UIControlState())
    }
    
    func startMetronome(_ sender: UIButton) {
        metronomeIsOn = true
        sender.setTitle("Stop", for: UIControlState())
        let metronomeTimeInterval:TimeInterval = (240.0 / Double(tsLower)) / bpm
        metronomeTimer = Timer.scheduledTimer(timeInterval: metronomeTimeInterval, target: self, selector: #selector(playMetronomeSound), userInfo: nil, repeats: true)
        metronomeTimer?.fire()
    }
    
    func playMetronomeSound() {
        count += 1
        if count == 1 {
            metronomeAccentPlayer.play()
        } else {
            metronomeSoundPlayer.play()
            if count == tsUpper {
                count = 0
            }
        }
    }
    
    func restartMetronome() {
        if metronomeIsOn {
            stopMetronome(playButton)
            startMetronome(playButton)
        }
    }

    
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
        
        
        if(bpm < 30)
        {
            bpm = 30
            knob.tintColor = UIColor.red
            knob.isEnabled = false
       
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
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
           //knob.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        }
        
        print("value: \(knob.value)") // console output
        
       
        if 30...400 ~= bpm {
        BPMlabel?.text = (String(format: "%.0f", bpm))
        }
        restartMetronome()

  
        }
    
}

