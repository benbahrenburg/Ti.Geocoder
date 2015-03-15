/**
 * TiGeocoder
 *
 * Native Geo Coders for Titanium
 *
 * Created by Benjamin Bahrenburg (bencoding)
 * Copyright (c) 2015 Benjamin Bahrenburg (bencoding). All rights reserved.
 *
 */

#import "TiModule.h"
#import <CoreLocation/CoreLocation.h>

@interface TiGeocoderModule : TiModule<CLLocationManagerDelegate>{
@private
    BOOL _isStarted;
    //KrollCallback *positionCallback;
    KrollCallback *_placeCallback;
    float _staleLimit;
}

@property (nonatomic, strong) CLLocationManager * locManager;

@end
