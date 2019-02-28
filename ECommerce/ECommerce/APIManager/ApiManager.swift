//
//  ApiManager.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

typealias RequestCompletionBlock = (Data?, URLResponse?, Error?) -> ()
public enum RJILParameterEncoding {
    case JSON
    case URL
    case BODY
}
let kApplicationErrorDomain = "Domain Error"

class ApiManager {
    
    //MARK:- Public
    
    var pendingTasks:[PendingTask] = [PendingTask]()
    
    var isRefreshingToken:Bool = false
    var urlString:String? = ""
    var errorMessage:String? = ""
    var httpStatusCode:Int?
    

//    //Following API paths will be served from CDN
//    lazy var cdnAPIPathList:[String] = {
//        var _cdnAPIPathList = [String]()
//        _cdnAPIPathList.append("allpastprogs/")
//        _cdnAPIPathList.append("getMobileChannelList/get/")
//        _cdnAPIPathList.append("getepg/get")
//        return _cdnAPIPathList
//    }()
    
    lazy var excludeAPIForCommonHeaders:[String] = {
       var _excludeAPIForCommonHeaders = [String]()
        _excludeAPIForCommonHeaders.append("/dictionary/dictionary.json")
        return _excludeAPIForCommonHeaders
    }()
    
    static let defaultManager = ApiManager()
    
    func setupAPICache(){
        // setting cache of size 500 MB
        let memoryCapacity = 2000 * 1024 * 1024
        let diskCapacity = 2000 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "urlCache")
        URLCache.shared = urlCache
    }
    func patch(request:URLRequest, completion:@escaping RequestCompletionBlock) {
        createDataTask(withRequest:request, httpMethod: "PATCH", completion: completion)
    }
    
    func post(request:URLRequest, completion:@escaping RequestCompletionBlock) {
        createDataTask(withRequest:request, httpMethod: "POST", completion: completion)
    }
    
    func put(request:URLRequest, completion:@escaping RequestCompletionBlock) {
        createDataTask(withRequest:request, httpMethod: "PUT", completion: completion)
    }
    
    func get(request:URLRequest, completion:@escaping RequestCompletionBlock) {
        createDataTask(withRequest:request, httpMethod: "GET", completion: completion)
    }
    
    var commonHeaders:[String:String]{
        get{
            var _commonHeaders = [String:String]()
            _commonHeaders["device"] = "phone"
            _commonHeaders["os"] = "ios"
            _commonHeaders["deviceid"] = UIDevice.current.identifierForVendor?.uuidString //UniqueDeviceID
            _commonHeaders["devicetype"] = "phone"//UIDevice.current.type.rawValue
              return _commonHeaders
        }
    }
    
    static func parse(data:Data) -> [String:Any]?{
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [String:Any]
            
        }catch let error {
            print(String(data: data, encoding: .utf8) ?? "")
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    private func getRequest(forPath path:String) -> URLRequest {
        
        urlString = path
        return URLRequest(url: URL(string: urlString!)!)
    }
    
    func prepareRequest(path:String, params: Dictionary<String, Any>? = nil, encoding:RJILParameterEncoding) -> URLRequest {
        var request:URLRequest?
        if let params = params {
            switch encoding {
            case .JSON:
                //JSON
                request = getRequest(forPath: path)
                do{
                    let jsonData:Data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                    request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request?.httpBody = jsonData
                }
                catch{
                    print(error)
                }
                break
            case .BODY:
                //POST BODY
                request = getRequest(forPath: path)
                var paramString:String = ""
                for (key, value) in params {
                    guard let escapedKey:String = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        else { fatalError("Key should be of type string") }
                    var escapedValue:String?
                    if let valueAsString:String = value as? String {
                        escapedValue = valueAsString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    }
                    else {
                        escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    }
                    
                    paramString = paramString + escapedKey + "=" + escapedValue! + "&"
                }
                request?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request?.httpBody = paramString.data(using: String.Encoding.utf8)
                break
            case .URL:
                //URL
                var paramString = ""
                for (key, value) in params {
                    let escapedKey = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    let escapedValue = (value as AnyObject).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    paramString += escapedKey! + "=" + escapedValue! + "&"
                }
                
                if paramString.characters.last == "&"{
                    paramString = paramString.substring(to: paramString.index(before: paramString.endIndex))
                }
                
                let pathWithParams = path + "?" + paramString
                request = getRequest(forPath: pathWithParams)
                break
            }
        }
        else {
            request = getRequest(forPath: path)
        }
        
        if excludeAPIForCommonHeaders.contains(path) == false {
            request?.allHTTPHeaderFields = commonHeaders //Common Headers to be set with Each API call
        }
        
        return request!
    }
    
    func downloadData(withURL urlString:String,completion:@escaping (_ urlString:String, _ responseData:Data?)->()){
        var dataDownloadTask: URLSessionDownloadTask!
        
        if let url = URL(string: urlString) {
            dataDownloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (location,response,error) in
                if location != nil {
                    do{
                        let responseData:Data = try Data(contentsOf: location!)
                        completion(urlString, responseData)
                    }
                    catch{
                        print(error)
                        completion(urlString, nil)
                    }
                }
            })
            
            dataDownloadTask.resume()
        }
    }
    
    //MARK:- Private Methods
    
    //Based on environment return the base url
//    private var baseURL:String {
//        get {
//            return "www.google.com"
//        }
//    }
    
    
    private var isTokenGettingRefreshed:Bool = false
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    private func createDataTask(withRequest request:URLRequest,httpMethod method:String, completion:@escaping RequestCompletionBlock) {
        var originalRequest = request
        originalRequest.httpMethod = method
        originalRequest.timeoutInterval = 30.0
        
        
        //Create a datatask with new completion handler
        let dataTask = URLSession.shared.dataTask(with: originalRequest) {(data, response, error) in
            
            if let responseError = error {
                //TDDO: Manual Exception Handling
                completion(nil, nil, responseError)
                return
            }
            
            //This is a new completion handler
            guard let httpResponse:HTTPURLResponse = response as? HTTPURLResponse else {
                //TODO: Add Manual exception tracking, No Internet Connection
                var errorInfo:[String:String] = [String:String]()
                errorInfo[NSLocalizedDescriptionKey] = "Failed to get response from server."
                completion(nil, nil, NSError(domain: kApplicationErrorDomain, code: 101, userInfo: errorInfo))
                return
                //Did not get response
                //fatalError("Could not get response")
            }
            
            
            self.httpStatusCode = httpResponse.statusCode
            print(httpResponse.statusCode)
            //This condition is added to simulate refresh toke scenario
//            if gSimulateRefreshTokenScenario { self.httpStatusCode = 419 }
            
            if self.httpStatusCode == 419 { //Authentication Failed Refresh Token
                //Authentication Failed
                //Check if token is getting refreshed
                if ApiManager.defaultManager.isRefreshingToken == false{
                    //Put the currentTask in queue
                    let currentTask:PendingTask = PendingTask()
                    currentTask.request = originalRequest
                    currentTask.completionHandler = completion
                    ApiManager.defaultManager.pendingTasks.append(currentTask)
                    //Update the flag so that other requests will start coming in queue
                    ApiManager.defaultManager.isRefreshingToken = true
                    DispatchQueue.global().async(execute: { 
                        DispatchQueue.main.sync {
                            
                        }
                    })
                }
                else{
                    //Token refresh is in progres put the task in queue to finish later
                    let pendingTask:PendingTask = PendingTask()
                    pendingTask.request = originalRequest
                    pendingTask.completionHandler = completion
                    ApiManager.defaultManager.pendingTasks.append(pendingTask)
                }
            }
            else if self.httpStatusCode == 400
            {
                var errorInfo:[String:String] = [String:String]()
                var errorDescription = "Bad Request : "
                
                if let responseData = data, let errorDetails:[String:Any] = ApiManager.parse(data: responseData),let errors = errorDetails["errors"] as? [[String:Any]], errors.count > 0 , let message = errors[0]["message"] as? String{
                    //let message = ""
                    errorDescription = errorDescription + message
                    if message.contains("SSO")
                    {
                        
                        if ApiManager.defaultManager.isRefreshingToken == false{
                            //Put the currentTask in queue
                            let currentTask:PendingTask = PendingTask()
                            currentTask.request = originalRequest
                            currentTask.completionHandler = completion
                            ApiManager.defaultManager.pendingTasks.append(currentTask)
                            //Update the flag so that other requests will start coming in queue
                            ApiManager.defaultManager.isRefreshingToken = true
                            DispatchQueue.global().async(execute: {
                                DispatchQueue.main.sync {
                                        return
                                }
                            })
                        }
                        else{
                            //Token refresh is in progres put the task in queue to finish later
                            let pendingTask:PendingTask = PendingTask()
                            pendingTask.request = originalRequest
                            pendingTask.completionHandler = completion
                            ApiManager.defaultManager.pendingTasks.append(pendingTask)
                        }

                
                    }else if message == "User Validation Failed"{
                       return
                    }
                }                
                errorInfo[NSLocalizedDescriptionKey] = self.errorMessage
                completion(nil, nil, NSError(domain: kApplicationErrorDomain, code: 400, userInfo: errorInfo))
            }
            else if self.httpStatusCode == 504{
                var errorInfo:[String:String] = [String:String]()
                self.errorMessage = "Server Timeout : Please try again in some time"
                errorInfo[NSLocalizedDescriptionKey] = self.errorMessage
                
                completion(nil, nil, NSError(domain: kApplicationErrorDomain, code: 504, userInfo: errorInfo))
            }
            else if self.httpStatusCode == 200 || self.httpStatusCode == 204 {//Success
                completion(data, response, error)
            }
            else {
                var errorInfo:[String:String] = [String:String]()
                let errorDescription = "Unexpected Response : HTTP Status Code :\(String(describing: self.httpStatusCode))"
                if let receivedData = data {
                    let responseString = String(data:receivedData, encoding:.utf8)
                    self.errorMessage = errorDescription + " " + responseString!
                }

                
                errorInfo[NSLocalizedDescriptionKey] = self.errorMessage
                completion(nil, nil, NSError(domain: kApplicationErrorDomain, code: self.httpStatusCode!, userInfo: errorInfo))
            }
            if self.httpStatusCode != 200 && self.httpStatusCode != 204
            {
            }
        }
        
        dataTask.resume()
        
        
    }
    
   
}
