// ViewController.swift
// Jay Guerrero

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
    @IBOutlet weak var secondViewSegue: UIButton!
    @IBOutlet weak var tempoTermLabel: UILabel!
    
    
    final class Shared {
        static let shared = Shared()
        var bpm: Double = 90
    }
    
    // variables needed by the tempo stepper
     var bpm: Double = 90
    var lastPos: Double = 0
    var lastStep: Double = 5
    
    // metronome variables
    var metronomeTimer: Timer!
    var metronomeIsOn = false
    var metronomeSoundPlayer: AVAudioPlayer!
    var metronomeAccentPlayer: AVAudioPlayer!
    
    // haptic feedback variables
    let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    
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
    
    @IBAction func secondViewSegueClicked(_ sender: UIButton) {  // to contain future features
        stopMetronome(sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempoStepper.autorepeat = true
        tsUpper = 4
        tsLower = 4
        
        // include sound files
        let metronomeSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "snizzap1", ofType: "wav")!)
        let metronomeAccentURL = URL(fileURLWithPath: Bundle.main.path(forResource: "snizzap2", ofType: "wav")!)
        
        metronomeSoundPlayer = try? AVAudioPlayer(contentsOf: metronomeSoundURL)
        metronomeAccentPlayer = try? AVAudioPlayer(contentsOf: metronomeAccentURL)
        
        metronomeSoundPlayer.prepareToPlay()
        metronomeAccentPlayer.prepareToPlay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stepTempo(_ sender: UIStepper) {
        
        if (tempoStepper.value == lastStep + 1 || tempoStepper.value < lastStep - 10) {
            bpm += 1
        } else {
            bpm -= 1
        }
        
        lastStep = tempoStepper.value
        
        BPMlabel?.text = (String(format: "%.0f", bpm)) // output changes made to bpm by the tempo stepper
        
        restartMetronome() // restart metronome if tempo stepper is clicked
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
    
    @objc func playMetronomeSound() {
        count += 1
        if count == 1 {
            metronomeAccentPlayer.play()
            heavyGenerator.prepare()
            heavyGenerator.impactOccurred()
        } else {
            metronomeSoundPlayer.play()
            lightGenerator.prepare()
            lightGenerator.impactOccurred()
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
        
        if ((diff) > Double.pi)
        {
            diff -= 2 * Double.pi
        }
        else if (diff < -Double.pi)
        {
            diff += 2 * Double.pi}
        
        lastPos = knob.value
        bpm += diff * 10
        
        mediumGenerator.prepare()
        mediumGenerator.impactOccurred() // give haptic feedback as knob rotates
        
        if (bpm < 30)
        {
            bpm = 30
            knob.tintColor = UIColor.red
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            // alert feedback, trying to set bpm out of range
        }
        else if (bpm < 400 && bpm > 30)
        {
            knob.tintColor = UIColor.blue
            knob.isEnabled = true
        }
        else if (bpm > 400)
        {
            bpm = 400
            knob.tintColor = UIColor.red
        }
       
        if 30...400 ~= bpm {
            BPMlabel?.text = (String(format: "%.0f", bpm))
        }
        
        if (bpm <= 50) {
            tempoTermLabel.text = "Grave"
        } else if (bpm > 50 && bpm < 55) {
            tempoTermLabel.text = "Largo"
        } else if (bpm > 55 && bpm < 60) {
            tempoTermLabel.text = "Larghetto"
        } else if (bpm > 60 && bpm < 70) {
            tempoTermLabel.text = "Adagio"
        } else if (bpm > 70 && bpm < 85) {
            tempoTermLabel.text = "Andante"
        } else if (bpm > 85 && bpm < 100) {
            tempoTermLabel.text = "Moderato"
        } else if (bpm > 100 && bpm < 115) {
            tempoTermLabel.text = "Allegretto"
        } else if (bpm > 115 && bpm < 140) {
            tempoTermLabel.text = "Allegro"
        } else if (bpm > 140 && bpm < 150) {
            tempoTermLabel.text = "Vivace"
        } else if (bpm > 150 && bpm < 170) {
            tempoTermLabel.text = "Presto"
        } else if (bpm > 150) {
            tempoTermLabel.text = "Prestissimo"
        }
        
        print("value: \(knob.value)") // console output
        restartMetronome() //restarts metronome when knob is rotated
    }
    
    
}

