

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var knob: Knob!
    @IBOutlet weak var BPM_label: UILabel!
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
        
        print("value: \(knob.value)")
        //BPM_label?.text = "\(90+((50*knob.value)))"
        BPM_label?.text = (String(format: "%.0f", bpm)) //round to zero decimal places
      
        
       
    }
}

