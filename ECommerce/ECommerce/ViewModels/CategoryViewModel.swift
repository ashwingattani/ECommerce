//
//  CategoryViewModel.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation

let baseURL = "https://stark-spire-93433.herokuapp.com"

class CategoryViewModel {
    
    public static let sharedInstance = CategoryViewModel()
    
    var reloadData : (() -> Void)? = nil
    
    var topCategory : [ProductCategory] = [] {
        didSet {
            if let reload = self.reloadData {
                reload()
            }
        }
    }
    
    var responseVo:ProductResponseVO! = nil
    
    func fetchProductsList() {
        if Utility.sharedInstance.isNetworkAvailable() {
            
            Utility.sharedInstance.showLoader()
            var parameter = WebserviceParameter(httpMethod: .GET)
            parameter.url = baseURL + "/json"
            let request = RequestManager.sharedInstance.createRequest(parameter: parameter)
            ApiManager.defaultManager.get(request: request) { (data, response, error) in
                
                Utility.sharedInstance.hideLoader()
                
                if error == nil {
                    let decoder = JSONDecoder.init()
                    do
                    {
                        self.responseVo = try decoder.decode(ProductResponseVO.self, from: data!)
                        self.evaluateData(responseVO: self.responseVo)
                    }
                    catch {
                        print(error)
                    }
                } else {
                    print(error.debugDescription)
                }
            }
        }
        else {
            Utility.sharedInstance.showAlert(title: "Please Check your Internet Connection", message: "")
        }
    }
    
    func evaluateData(responseVO:ProductResponseVO) {
        let categoryProducts = responseVO.productCategoryList.filter({$0.child_categories.count>0})
        
        for category in categoryProducts {
            var isTopCategory = true
            for category1 in categoryProducts {
                if category.id != category1.id {
                    for childCategory in category1.child_categories {
                        if category.id == childCategory {
                            isTopCategory = false
                            break
                        }
                    }
                }
            }
            if isTopCategory {
                topCategory.append(category)
            }
        }
    }
    
    func fetchSubCategoryList(category:ProductCategory) -> [ProductCategory] {
        var subCategorylist = [ProductCategory]()
        for child in category.child_categories {
            for category in self.responseVo.productCategoryList {
                if child == category.id {
                    subCategorylist.append(category)
                    break
                }
            }
        }
        return subCategorylist
    }
    
}
