//
//  CategoryViewController.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryTableView.tableFooterView = UIView.init()
        
        // Do any additional setup after loading the view.
        CategoryViewModel.sharedInstance.fetchProductsList()
        
        CategoryViewModel.sharedInstance.reloadData = {
            DispatchQueue.main.async {
                self.categoryTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CategoryViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryViewModel.sharedInstance.topCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.selectionStyle = .none
        let category: ProductCategory = CategoryViewModel.sharedInstance.topCategory[indexPath.row]
        cell?.textLabel?.text = category.name
        return cell!
        
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category: ProductCategory = CategoryViewModel.sharedInstance.topCategory[indexPath.row]
        
        // If Child Categories Count is Greater than 0 and Product List equal to 0, Subcategory Exist
        if category.child_categories.count > 0 && category.productList.count == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            vc.subCategory = CategoryViewModel.sharedInstance.fetchSubCategoryList(category: category)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
