import UIKit
import RealmSwift

class AddClockTableViewController: UITableViewController{
    
    @IBOutlet weak var clockPicker:UIDatePicker!
    @IBOutlet weak var repeatDayLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var soundLabel:UILabel!
    @IBOutlet weak var afterRemindSwitch:UISwitch!
    @IBOutlet weak var deleteButtonView:UIView!
    
    var clockStr:String!
    var tmpSecond:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repeatDayLabel.text = "永不"
        descriptionLabel.text = "鬧鐘"
        soundLabel.text = "雷達"
        deleteButtonView.isHidden = true
        if #available(iOS 13.4, *) {
            clockPicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getDate() -> String {
        let clockTime = clockPicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        clockStr = dateFormatter.string(from: clockTime)
        return clockStr
    }
    
    
    func saveToRealm() {
        let realm = try! Realm()
        let clockSave = ClockRealm()
        clockSave.time = self.getDate()
        clockSave.repeatDay = self.repeatDayLabel.text!
        clockSave.clockDecscription = self.descriptionLabel.text!
        clockSave.sound = self.soundLabel.text!
        clockSave.afterRemind = afterRemindSwitch.isOn
        try! realm.write {
            realm.add(clockSave)
        }
        print(realm.configuration.fileURL!)
    }
    
    @IBAction func saveClock(_ sender: Any) {
        DispatchQueue.main.async {
            self.saveToRealm()
        }
        if let controller = storyboard?.instantiateViewController(identifier: "MainClock") {
            self.show(controller,sender: self)
        }
    }
    
    @IBAction func clockPicker(_ sender: UIDatePicker) {
        let now = Date()
        let second = Double(clockPicker.date.timeIntervalSince(now))
        self.tmpSecond = second
        print(second)
    }
    
 
    @IBAction func unwindToAddClock(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as? SelectRepeatDayTableViewController
        repeatDayLabel.text = sourceViewController?.selectDay
    }
    
    @IBAction func unwindToAddClockFromInputDescription(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as? InputDescriptionViewController
        descriptionLabel.text = sourceViewController?.clockDescriptionTextField.text
    }
    
    @IBAction func unwindToAddClockFromSelectSound(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as? SelectSoundTableViewController
        soundLabel.text = sourceViewController?.selectSound
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SelectRepeatDay") {
            let controller = segue.destination as? SelectRepeatDayTableViewController
            controller?.selectDay = repeatDayLabel.text
        } else if (segue.identifier == "ClockDescription") {
            let controller = segue.destination as? InputDescriptionViewController
            controller?.clockDescriptionText = descriptionLabel.text
        } else if (segue.identifier == "SelectSound") {
            let controller = segue.destination as? SelectSoundTableViewController
            controller?.selectSound = soundLabel.text
        }
    }
}
