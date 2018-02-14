

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var knob: Knob!

    //let BPM_label = UILabel()

    @IBOutlet weak var BPM_label: UILabel!
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
        /*
        if let displayThis = knob?.value {
            self.BPM_label?.text = "\(displayThis)"
        }
        */
        
        print("value: \(knob.value)")
        //BPM_label.text = String(knob.value)
        BPM_label?.text = "\(knob.value)"
        
        let label = UILabel()

        label.text = "Hello"
        //self.BPM_label.text = String(self.knob.value)
        
                label.text = "Hello"
        self.view.addSubview(label)
    }
}

