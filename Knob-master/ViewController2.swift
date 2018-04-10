//
//  ViewController2.swift
//  Knob
//
//  Created by Jay Guerrero on 4/10/18.
//  Copyright © 2018 Chris Gulley. All rights reserved.
//

import UIKit
//import MediaPlayer
import AVFoundation

class ViewController2: UIViewController {
    @IBOutlet weak var volumeSlider: UISlider!
    var audioPlayer:AVAudioPlayer!

    @IBAction func volumeChanged(_ sender: UISlider) {
        audioPlayer.volume = volumeSlider.value

    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
