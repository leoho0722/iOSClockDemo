import UIKit

class MainClockTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var clockEnabledSwitch:UISwitch!
    @IBOutlet weak var clockDescriptionLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
