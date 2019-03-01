//
//  RankingProductListViewController.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class RankingProductListViewController: UIViewController {

    var productRankList = [ProductRank]()
    
    @IBOutlet weak var rankListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rankListTableView.tableFooterView = UIView.init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- UITableview DataSource
extension RankingProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productRankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: ProductRankListCell.identifier) as! ProductRankListCell
        cell.selectionStyle = .none
        let productRank: ProductRank = self.productRankList[indexPath.row]
        cell.countLabel.text = "Views = \(String(productRank.view_count!))"
        let productName = DatabaseManager.sharedInstance.getProductName(with: productRank.id)
        cell.nameLabel.text = "Name = \(productName)"
        return cell
    }
}
