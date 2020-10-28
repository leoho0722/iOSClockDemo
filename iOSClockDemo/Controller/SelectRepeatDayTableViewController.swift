import UIKit

class SelectRepeatDayTableViewController: UITableViewController {

    let repeatDay = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    var selectDay:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repeatDay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatDayCell", for: indexPath)
        cell.textLabel?.text = repeatDay[indexPath.row]
        (selectDay == repeatDay[indexPath.row]) ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)!
//        cell.accessoryType = .checkmark
//    }
//
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)!
//        cell.accessoryType = .none
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            selectDay = repeatDay[indexPath.row]
        }
    }
}
