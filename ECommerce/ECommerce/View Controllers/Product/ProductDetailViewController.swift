//
//  ProductDetailViewController.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var product: Product!
    @IBOutlet weak var productDetailCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- UICollectionView DataSource
extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.product.variantList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailCell.identifier, for: indexPath) as! ProductDetailCell
        let variant: Variant = self.product.variantList[indexPath.row]
        cell.colorLabel.text = "Color = \(variant.color)"
        cell.sizeLabel.text =  "Size  = \(variant.size!)"
        cell.priceLabel.text = "Price = \(String(variant.price))"
        return cell
    }
}


// MARK:- UICollectionView FlowLayout
extension ProductDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width , height: productDetailCollectionView.bounds.height)
    }
}
