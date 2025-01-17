//
//  GooglePlaces.swift
//  GooglePlaces
//
//  Created by Honghao Zhang on 2016-02-12.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

public class GooglePlaces: GoogleMapsService {
    
    fileprivate static var pendingRequest: Alamofire.Request?
    
    public static let placeAutocompleteURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    public class func placeAutocomplete(forInput input: String,
                                        sessiontoken: String? = nil,
                                        offset: Int? = nil,
                                        locationCoordinate: LocationCoordinate2D? = nil,
                                        radius: Int? = nil,
                                        language: String? = nil,
                                        types: [PlaceType]? = nil,
                                        components: String? = nil,
                                        cancelPendingRequestsAutomatically: Bool = true,
                                        completion: ((PlaceAutocompleteResponse?, NSError?) -> Void)?) {
        
        var requestParameters: [String : Any] = baseRequestParameters + ["input" : input]
        
        if let sessiontoken = sessiontoken {
            requestParameters["sessiontoken"] = sessiontoken
        }
        
        if let offset = offset {
            requestParameters["offset"] = offset
        }
        
        if let locationCoordinate = locationCoordinate {
            requestParameters["location"] = "\(locationCoordinate.latitude),\(locationCoordinate.longitude)"
        }
        
        if let radius = radius {
            requestParameters["radius"] = radius
        }
        
        if let language = language {
            requestParameters["language"] = language
        }
        
        if let types = types {
            requestParameters["types"] = types.map { $0.rawValue }.joined(separator: "|")
        }
        
        if let components = components {
            requestParameters["components"] = components
        }
        
        if pendingRequest != nil && cancelPendingRequestsAutomatically {
            pendingRequest?.cancel()
            pendingRequest = nil
        }
        
        let request = AF.request(placeAutocompleteURLString, method: .get, parameters: requestParameters)
        
        // debugging only:
        //print("\n - autocomplete request: ", request, " at: ", NSDate(timeIntervalSince1970: TimeInterval(TimeInterval(NSDate().timeIntervalSince1970))))
        
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                // Nil
                if value is NSNull {
                    completion?(PlaceAutocompleteResponse(), nil)
                    return
                }
                
                // JSON
                guard let json = value as? [String : AnyObject] else {
                    NSLog("Error: Parsing json failed")
                    completion?(nil, NSError(domain: "GooglePlacesError", code: -2, userInfo: nil))
                    return
                }
                
                guard let response = Mapper<PlaceAutocompleteResponse>().map(JSON: json) else {
                    NSLog("Error: Mapping directions response failed")
                    completion?(nil, NSError(domain: "GooglePlacesError", code: -3, userInfo: nil))
                    return
                }
                
                var error: NSError?
                
                switch response.status {
                case .none:
                    let userInfo = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: "")
                    ]
                    error = NSError(domain: "GooglePlacesError", code: -1, userInfo: userInfo)
                case .some(let status):
                    switch status {
                    case .ok:
                        break
                    default:
                        let userInfo = [
                            NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: status.rawValue, comment: ""),
                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                        ]
                        error = NSError(domain: "GooglePlacesError", code: -1, userInfo: userInfo)
                    }
                }
                
                pendingRequest = nil
                
                completion?(response, error)
            case .failure(let error):
                if (error as NSError).code == NSURLErrorCancelled {
                    // nothing to do, another active request is coming
                    return
                }
                completion?(nil, NSError(domain: "GooglePlacesError", code: -1, userInfo: nil))
            }
        }
        
        pendingRequest = request
    }
}



// MARK: - Place Details
public extension GooglePlaces {
    
    static let placeDetailsURLString = "https://maps.googleapis.com/maps/api/place/details/json"
    
    class func placeDetails(forPlaceID placeID: String,
                            forSessionToken sessiontoken: String? = nil,
                            extensions: String? = nil,
                            language: String? = nil,
                            completion: ((_ response: PlaceDetailsResponse?, _ error: NSError?) -> Void)?) {
        
        var requestParameters = baseRequestParameters + ["placeid" : placeID]
        
        if let sessiontoken = sessiontoken {
            requestParameters["sessiontoken"] = sessiontoken
        }
        
        if let extensions = extensions {
            requestParameters["extensions"] = extensions
        }

        if let language = language {
            requestParameters["language"] = language
        }
        
        // critical: 'fields' parameter described as "optional" in documentation (it is not if you do not want to be billed for all data skus)
        requestParameters["fields"] = "address_components"
        
        let placeDetailsRequest = AF.request(placeDetailsURLString, method: .get, parameters: requestParameters)
        
        // debugging only:
        //print("\n - place details request: ", placeDetailsRequest.request, " at: ", NSDate(timeIntervalSince1970: TimeInterval(TimeInterval(NSDate().timeIntervalSince1970))), "\n")
        
        placeDetailsRequest.responseJSON { response in

            switch response.result {
            case .success(let value):
                // Nil
                if value is NSNull {
                    completion?(PlaceDetailsResponse(), nil)
                    return
                }

                // JSON
                guard let json = value as? [String : Any] else {
                    NSLog("Error: Parsing json failed")
                    completion?(nil, NSError(domain: "GooglePlacesError", code: -2, userInfo: nil))
                    return
                }

                guard let response = Mapper<PlaceDetailsResponse>().map(JSON: json) else {
                    NSLog("Error: Mapping directions response failed")
                    completion?(nil, NSError(domain: "GooglePlacesError", code: -3, userInfo: nil))
                    return
                }

                var error: NSError?

                switch response.status {
                case .none:
                    let userInfo = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: "")
                    ]
                    error = NSError(domain: "GooglePlacesError", code: -1, userInfo: userInfo)
                case .some(let status):
                    switch status {
                    case .ok:
                        break
                    default:
                        let userInfo = [
                            NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: status.rawValue, comment: ""),
                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                        ]
                        error = NSError(domain: "GooglePlacesError", code: -1, userInfo: userInfo)
                    }
                }

                completion?(response, error)
            case .failure:
                NSLog("Error: GET failed")
                completion?(nil, NSError(domain: "GooglePlacesError", code: -1, userInfo: nil))
                return
            }
        }
    }
}
