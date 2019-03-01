//
//  RankingViewController.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController {
    
    @IBOutlet weak var rankingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.rankingTableView.tableFooterView = UIView.init()
    }
}

extension RankingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryViewModel.sharedInstance.responseVo.rankings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.selectionStyle = .none
        cell?.textLabel?.text = CategoryViewModel.sharedInstance.responseVo.rankings[indexPath.row].ranking
        return cell!
    }
}

extension RankingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RankingProductListViewController") as! RankingProductListViewController
        vc.productRankList = CategoryViewModel.sharedInstance.responseVo.rankings[indexPath.row].productRankList
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
