import UIKit

class InputDescriptionViewController: UIViewController {

    @IBOutlet weak var clockDescriptionTextField:UITextField!
    
    var clockDescriptionText:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clockDescriptionTextField.text = clockDescriptionText
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
