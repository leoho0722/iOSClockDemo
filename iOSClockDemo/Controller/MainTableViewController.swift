import UIKit
import RealmSwift
import UserNotifications

class MainTableViewController: UITableViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var emptyView:UIView!
    @IBOutlet weak var editButton:UIButton!
    
    var clockIndexPathRow:Int = 0 //用來取得滑動的那一個 Row 的 IndexPath.row
    var clockPrimaryKey:String? = nil //用來取得滑動的那一個 Row 的資料 Primary Key
    var notificationID:String? = nil
    var second:Double!
//    var openSwitch:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.black
        refreshControl?.backgroundColor = UIColor.clear
        refreshControl?.attributedTitle = NSAttributedString(string: "下拉更新中", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
        refreshControl?.addTarget(self, action: #selector(updateData), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
                
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let clock = realm.objects(ClockRealm.self)
        if (clock.count > 0) {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
            return clock.count
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainClockCell", for: indexPath) as! MainClockTableViewCell
        let realm = try! Realm()
        let clock = realm.objects(ClockRealm.self)
        if (clock.count > 0) {
            cell.timeLabel.text = clock[indexPath.row].time
            cell.clockDescriptionLabel.text = clock[indexPath.row].clockDecscription + "，" + clock[indexPath.row].repeatDay
            cell.clockEnabledSwitch.isOn = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { (action, sourceView, completeHandler) in
            self.clockIndexPathRow = indexPath.row
            self.getClockPrimaryKey()
            self.deleteData()
            completeHandler(true)
        }
        let trailingSwipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return trailingSwipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.deleteData()
        }
    }
    
    // MARK: - 取資料庫主鍵、刪除資料、更新資料
    
    func getClockPrimaryKey() {
        let realm = try! Realm()
        let id = realm.objects(ClockRealm.self)
        if (id.count > 0) {
            self.clockPrimaryKey = id[self.clockIndexPathRow].clockID
        }
    }
    
    func deleteData() {
        let realm = try! Realm()
        let deleteClock = realm.objects(ClockRealm.self).filter("clockID = '\(self.clockPrimaryKey!)'").first
        try! realm.write {
            realm.delete(deleteClock!)
            tableView.reloadData()
        }
    }
    
    @objc func updateData() {
        //延遲0.5秒讀取更新
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - 通知推播
    
    func createNotificationID() {
        let realm = try! Realm()
        let id = realm.objects(ClockRealm.self)
        if (id.count > 0) {
            self.notificationID = id[self.clockIndexPathRow].clockID
        }
    }
    
    func notification(openSwitch:Bool) {
        if (openSwitch) {
            let content = UNMutableNotificationContent()
            content.title = "iOSClockDemo"
            content.body = "時間到了"
            content.badge = 0
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (second - 11), repeats: false)
            let request = UNNotificationRequest(identifier: "\(String(describing: self.notificationID))", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if (error != nil) {
                    print("通知發生錯誤！")
                }
            }
        } else {
            print("通知已被關閉")
        }
    }
    
    @IBAction func clockSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            self.notification(openSwitch: true)
        } else {
            self.notification(openSwitch: false)
        }
    }
    

    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as? AddClockTableViewController
        self.second = sourceViewController?.tmpSecond
        self.createNotificationID()
        self.notification(openSwitch: true)
    }
}

//UIRefreshControll 下拉更新↓
//https://medium.com/@JJeremy.XUE/swift-%E7%8E%A9%E7%8E%A9-%E4%B8%8B%E6%8B%89%E5%88%B7%E6%96%B0-uirefreshcontrol-a77d09847b3c

//UIDatePicker 計算時間差↓
//https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E8%B7%9D%E9%9B%A2%E7%8F%BE%E5%9C%A8%E7%9A%84%E6%99%82%E9%96%93%E6%98%AF%E5%A4%9A%E4%B9%85-e6ac123d39da
//https://github.com/babipapi/demoTimeCountDown/blob/master/demoTimeCountDown/ViewController.swift

// 本地通知推播↓
//https://medium.com/@mikru168/ios-%E6%9C%AC%E5%9C%B0%E9%80%9A%E7%9F%A5-local-notification-b25229f279ec
