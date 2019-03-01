//
//  SubCategoryViewController.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class SubCategoryViewController: UIViewController {

    @IBOutlet weak var subCategoryTableView: UITableView!
    
    var subCategory = [ProductCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subCategoryTableView.tableFooterView = UIView.init()
    }
}

extension SubCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return subCategory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.selectionStyle = .none
        
        let category: ProductCategory = self.subCategory[indexPath.row]
        cell?.textLabel?.text = category.name
        return cell!
    }
}

extension SubCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category: ProductCategory = self.subCategory[indexPath.row]

        // Check if subcategory Exists
        if category.child_categories.count > 0 && category.productList.count == 0 {
            let subCategoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            subCategoryViewController.subCategory = CategoryViewModel.sharedInstance.fetchSubCategoryList(category: category)
            self.navigationController?.pushViewController(subCategoryViewController, animated: true)
        } else if category.child_categories.count == 0 && category.productList.count > 0 {
            let productListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductsListViewController") as! ProductsListViewController
            productListViewController.subCategory = self.subCategory
            productListViewController.categoryIndex = indexPath.row
            self.navigationController?.pushViewController(productListViewController, animated: true)
        }
    }
}
