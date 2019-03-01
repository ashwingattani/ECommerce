//
//  ProductsViewController.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class ProductsListViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView:  UICollectionView!
    @IBOutlet weak var productListTableView:    UITableView!

    var subCategory = [ProductCategory]()
    var productList = [Product]()
    var categoryIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.productListTableView.tableFooterView = UIView.init()
        productList = subCategory[categoryIndex].productList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK:- UICollectionView DataSource
extension ProductsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategory.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as! ProductListCell
        let category: ProductCategory = self.subCategory[indexPath.row]
        cell.textLabel.text = category.name
        if indexPath.row == categoryIndex {
            cell.textLabel.textColor = .blue
        }
        else {
            cell.textLabel.textColor = .black
        }
        
        return cell
    }
}
// MARK:- UICollectionView Delegate
extension ProductsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryIndex = indexPath.row
        productList = subCategory[categoryIndex].productList
        self.productListTableView.reloadData()
        self.categoryCollectionView.reloadData()
    }
}
// MARK:- UICollectionView FlowLayout
extension ProductsListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: ((UIScreen.main.bounds.width - 20)/2), height: categoryCollectionView.bounds.height)
    }
}

// MARK:- UITableview DataSource
extension ProductsListViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.selectionStyle = .none
        let product: Product = self.productList[indexPath.row]
        cell?.imageView?.image = #imageLiteral(resourceName: "ecommerce")
        cell?.textLabel?.text = product.name
        return cell!
    }
}

extension ProductsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product: Product = self.productList[indexPath.row]
        let productDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        productDetailViewController.product = product
        self.navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}



