import UIKit

class SelectSoundTableViewController: UITableViewController {
    
    var soundData = [
        ("",["震動模式"]),
        ("商店",["鈴聲商店","下載所有購買的鈴聲"]),
        ("歌曲",["選擇歌曲"]),
        ("鈴聲",["雷達（預設值）","上升","山坡","公告","水晶","宇宙","波浪","信號","急板","指標","星座","海邊","閃爍","頂尖","頂峰","絲綢","開場","煎茶",
        "照耀","遊戲時間","電路","漣漪","漸強","貓頭鷹","輻射","鐘聲","觀星","經典"]),
        ("",["無"])
    ]
    var selectSound: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - TableView DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return soundData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundData[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = soundData[indexPath.section].1[indexPath.row]
        (selectSound == soundData[indexPath.section].1[indexPath.row]) ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0 || section == 4) {
            return 20
        } else {
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 3) {
            return 0
        } else if (section == 1) {
            return 30
        } else {
            return 20
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return ""
        } else if (section == 1) {
            return "商店"
        } else if (section == 2) {
            return "歌曲"
        } else if (section == 3) {
            return "鈴聲"
        } else if (section == 4) {
            return ""
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 1) {
            return "這將會使用「Apple ID」帳號下載所有購買的鈴聲和提示聲"
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            selectSound = soundData[indexPath.section].1[indexPath.row]
        }
    }
}
