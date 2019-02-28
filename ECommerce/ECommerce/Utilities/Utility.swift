//
//  Utility.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation
import MBProgressHUD
import SystemConfiguration

class Utility {
    static let sharedInstance = Utility()
    
    func showLoader() {
        DispatchQueue.main.async {
            if let topController = UIApplication.topViewController() {
                var hud : MBProgressHUD = MBProgressHUD()
                hud = MBProgressHUD.showAdded(to: topController.view, animated: true)
                hud.label.text = "Loading..."
            }
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            if let topController = UIApplication.topViewController() {
                MBProgressHUD.hide(for: topController.view, animated: true)
            }
        }
    }
    
    func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func showAlert(title: String,message: String) {
        if let topController = UIApplication.topViewController() {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                topController.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? =
        UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
