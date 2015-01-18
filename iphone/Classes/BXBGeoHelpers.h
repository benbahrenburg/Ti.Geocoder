/**
 * TiGeocoder
 *
 * Native Geo Coders for Titanium
 *
 * Created by Benjamin Bahrenburg (bencoding)
 * Copyright (c) 2015 Benjamin Bahrenburg (bencoding). All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "TiUtils.h"
#import <CoreLocation/CoreLocation.h>


@interface BXBGeoHelpers : NSObject<CLLocationManagerDelegate>{
    CLLocationManager *locationPermissionManager; // used for just permissions requests
}

- (void) disabledLocationServiceMessage;
- (void) requestPermission;
- (NSDictionary*)buildFromPlaceLocation:(CLPlacemark *)placemark;
- (NSDictionary*)locationDictionary:(CLLocation*)newLocation;

@end
