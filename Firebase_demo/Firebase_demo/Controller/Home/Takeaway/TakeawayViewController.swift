//
//  TakeawayViewController.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/19/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

class TakeawayViewController: UIViewController {

    @IBOutlet weak var takeawayBillTableView: UITableView!
    
    let takeawayBillCellID = "takeawayBillCellID"
    let rowHeight: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews() {
        navigationController?.title = "Gọi đồ mang về"
        
        takeawayBillTableView.delegate = self
        takeawayBillTableView.dataSource = self
        
        takeawayBillTableView.register(UITableViewCell.self, forCellReuseIdentifier: takeawayBillCellID)
    }
    
    @IBAction func makeTakeawayBillTapped(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
extension TakeawayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: takeawayBillCellID, for: indexPath)
        cell.textLabel?.text = "avc"
        return cell
    }
    
    
}
extension TakeawayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}
