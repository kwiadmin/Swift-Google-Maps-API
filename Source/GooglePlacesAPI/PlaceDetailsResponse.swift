//
//  PlaceDetailsResponse.swift
//  GooglePlaces
//
//  Created by Honghao Zhang on 2016-02-20.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - PlaceAutocompleteResponse
public extension GooglePlaces {
    public struct PlaceDetailsResponse: Mappable {
        public var status: StatusCode?
        public var errorMessage: String?
        
        public var result: Result?
        public var htmlAttributions: [String] = []
        
        public init() {}
        public init?(map: Map) { }
        
        public mutating func mapping(map: Map) {
            status <- (map["status"], EnumTransform())
            errorMessage <- map["error_message"]
            
            result <- map["result"]
            htmlAttributions <- map["html_attributions"]
        }
        
        public struct Result: Mappable {
            /// an array of separate address components used to compose a given address. For example, the address "111 8th Avenue, New York, NY" contains separate address components for "111" (the street number, "8th Avenue" (the route), "New York" (the city) and "NY" (the US state).
            public var addressComponents: [AddressComponent] = []
            
            /// a string containing the human-readable address of this place. Often this address is equivalent to the "postal address," which sometimes differs from country to country. This address is generally composed of one or more address_component fields.
            public var formattedAddress: String?
                        
            /// geometry.location the geocoded latitude,longitude value for this place.
            public var geometryLocation: LocationCoordinate2D?
            
            /// the URL of a suggested icon which may be displayed to the user when indicating this result on a map
            public var icon: URL?
            
            /// the human-readable name for the returned result. For establishment results, this is usually the canonicalized business name.
            public var name: String?
            
            /// a boolean flag indicating whether the place has permanently shut down (value true). If the place is not permanently closed, the flag is absent from the response.
            public var permanentlyClosed: Bool = false
            
            /// A textual identifier that uniquely identifies a place. To retrieve information about the place, pass this identifier in the placeId field of a Places API request. For more information about place IDs, see the place ID overview.
            public var placeID: String?
            
            ///  Indicates the scope of the place_id.
            public var scope: Scope?
            
            /// An array of zero, one or more alternative place IDs for the place, with a scope related to each alternative ID. Note: This array may be empty or not present.
            public var alternativePlaceIDs: [PlaceIDScope] = []
            
            /// an array of feature types describing the given result. See the list of supported types for more information.
            public var types: [String] = []
            
            /// the URL of the official Google page for this place. This will be the Google-owned page that contains the best available information about the place. Applications must link to or embed this page on any screen that shows detailed results about the place to the user.
            public var url: URL?
            
            /// the number of minutes this place’s current timezone is offset from UTC. For example, for places in Sydney, Australia during daylight saving time this would be 660 (+11 hours from UTC), and for places in California outside of daylight saving time this would be -480 (-8 hours from UTC).
            public var utcOffset: Int?
            
            /// a simplified address for the place, including the street name, street number, and locality, but not the province/state, postal code, or country. For example, Google's Sydney, Australia office has a vicinity value of 48 Pirrama Road, Pyrmont.
            public var vicinity: String?
            
            public init() {}
            public init?(map: Map) { }
            
            public mutating func mapping(map: Map) {
                addressComponents <- map["address_components"]
                formattedAddress <- map["formatted_address"]
                geometryLocation <- (map["geometry.location"], LocationCoordinate2DTransform())
                icon <- (map["icon"], URLTransform())
                name <- map["name"]
                permanentlyClosed <- map["permanently_closed"]
                placeID <- map["place_id"]
                scope <- (map["scope"], EnumTransform())
                alternativePlaceIDs <- map["alt_ids"]
                types <- map["types"]
                url <- map["url"]
                utcOffset <- map["utc_offset"]
                vicinity <- map["vicinity"]
            }
            
            /**
             *  AddressComponent
             address components used to compose a given address. For example, the address "111 8th Avenue, New York, NY" contains separate address components for "111" (the street number, "8th Avenue" (the route), "New York" (the city) and "NY" (the US state)
             */
            public struct AddressComponent: Mappable {
                /// an array indicating the type of the address component.
                public var types: [String] = []
                
                /// the full text description or name of the address component.
                public var longName: String?
                
                /// an abbreviated textual name for the address component, if available. For example, an address component for the state of Alaska may have a long_name of "Alaska" and a short_name of "AK" using the 2-letter postal abbreviation.
                public var shortName: String?
                
                public init() {}
                public init?(map: Map) { }
                
                public mutating func mapping(map: Map) {
                    types <- map["types"]
                    longName <- map["long_name"]
                    shortName <- map["short_name"]
                }
            }
            
            /// The scope of the place_id
            ///
            /// - app:    The place ID is recognised by your application only. This is because your application added the place, and the place has not yet passed the moderation process.
            /// - google: The place ID is available to other applications and on Google Maps.
            public enum Scope: String {
                case app = "APP"
                case google = "GOOGLE"
            }
            
            public struct PlaceIDScope: Mappable {
                /// The most likely reason for a place to have an alternative place ID is if your application adds a place and receives an application-scoped place ID, then later receives a Google-scoped place ID after passing the moderation process.
                public var placeID: String?
                
                /// The scope of an alternative place ID will always be APP, indicating that the alternative place ID is recognised by your application only.
                public var scope: Scope?
                
                public init() {}
                public init?(map: Map) { }
                
                public mutating func mapping(map: Map) {
                    placeID <- map["place_id"]
                    scope <- (map["scope"], EnumTransform())
                }
            }
        }
    }
}
