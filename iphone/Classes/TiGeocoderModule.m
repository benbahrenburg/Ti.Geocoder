/**
 * TiGeocoder
 *
 * Native Geo Coders for Titanium
 *
 * Created by Benjamin Bahrenburg (bencoding)
 * Copyright (c) 2015 Benjamin Bahrenburg (bencoding). All rights reserved.
 *
 */

#import "TiGeocoderModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"


#ifndef BXBGeoHelpers
#import "BXBGeoHelpers.h"
#endif

//BXBGeoHelpers
@implementation TiGeocoderModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"32bae808-920d-4d82-b99d-f0541f686692";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.geocoder";
}

#pragma mark Lifecycle


-(void)startup
{
    _isStarted = NO;
    
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup


#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}


#pragma Public APIs

-(NSNumber*)isSupported:(id)args
{

    if(NSClassFromString(@"UIReferenceLibraryViewController"))
    {
        return NUMBOOL(YES);
    }else{
        return NUMBOOL(NO);
    }
}

-(void)forwardGeocoder:(id)args
{
    
    ENSURE_ARG_COUNT(args,2);
    NSString* address = [TiUtils stringValue:[args objectAtIndex:0]];
    KrollCallback *callback = [args objectAtIndex:1];
    ENSURE_TYPE(callback,KrollCallback);
    ENSURE_UI_THREAD(forwardGeocoder,args);
    
    BXBGeoHelpers * helpers = [[BXBGeoHelpers alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]== NO)
    {
        [helpers disabledLocationServiceMessage];
        return;
    }
    
    [helpers requestPermission];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        
        if(placemarks && placemarks.count > 0)
        {
            NSMutableArray *placeData = [[NSMutableArray alloc] init];
            int placesCount = (int)[placemarks count];
            for (int iLoop = 0; iLoop < placesCount; iLoop++) {
                [placeData addObject:[helpers buildFromPlaceLocation:[placemarks objectAtIndex:iLoop]]];
            }
            
            if (callback){
                NSDictionary *eventOk = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithInt:placesCount],@"placeCount",
                                         placeData,@"places",
                                         NUMBOOL(YES),@"success",
                                         nil];
                
                [self _fireEventToListener:@"completed"
                                withObject:eventOk listener:callback thisObject:nil];
            }
            
        }
        else
        {
            if (callback){
                NSDictionary* eventErr = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [error localizedDescription],@"error",
                                          NUMBOOL(NO),@"success",nil];
                
                [self _fireEventToListener:@"completed"
                                withObject:eventErr listener:callback thisObject:nil];
            }
        }
    }];
    
}
-(void)reverseGeocoder:(id)args
{
    
    ENSURE_ARG_COUNT(args,3);
    CGFloat lat = [TiUtils floatValue:[args objectAtIndex:0]];
    CGFloat lon = [TiUtils floatValue:[args objectAtIndex:1]];
    KrollCallback *callback = [args objectAtIndex:2];
    ENSURE_TYPE(callback,KrollCallback);
    ENSURE_UI_THREAD(reverseGeocoder,args);
    
    
    BXBGeoHelpers * helpers = [[BXBGeoHelpers alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]== NO)
    {
        [helpers disabledLocationServiceMessage];
        return;
    }
    
    [helpers requestPermission];
    
    CLLocation *findLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    
    [self findPlace:findLocation withCallback:callback];
    
}

-(void)getCurrentPlace:(id)callback
{
    ENSURE_SINGLE_ARG(callback,KrollCallback);
    ENSURE_UI_THREAD(getCurrentPlace,callback);
    _placeCallback = callback;
    
    _staleLimit = [TiUtils floatValue:[self valueForUndefinedKey:@"staleLimit"]def:15.0];
    
    BXBGeoHelpers * helpers = [[BXBGeoHelpers alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]== NO)
    {
        [helpers disabledLocationServiceMessage];
        return;
    }
    
    [helpers requestPermission];
        
    [self startFindingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    [self shutdownFindingLocation];
    
    if (_placeCallback!=nil){
        NSDictionary* eventErr = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [error localizedDescription],@"error",
                                  NUMBOOL(NO),@"success",nil];
        [self _fireEventToListener:@"completed"
                        withObject:eventErr listener:_placeCallback thisObject:nil];
        _placeCallback = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self shutdownFindingLocation];
    
    if (_placeCallback!=nil){
        [self findPlace:newLocation withCallback:_placeCallback];
        _placeCallback = nil;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    [self shutdownFindingLocation];
    CLLocation *location = [locations lastObject];
    if (_placeCallback!=nil){
        [self findPlace:location withCallback:_placeCallback];
        _placeCallback = nil;
    }
}

-(void)findPlace:(CLLocation*)location withCallback:(KrollCallback*) callback
{
    BXBGeoHelpers * helpers = [[BXBGeoHelpers alloc] init];
    CLLocationCoordinate2D latlon = [location coordinate];
    CLLocation *findLocation = [[CLLocation alloc] initWithLatitude:latlon.latitude longitude:latlon.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:findLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if(placemarks && placemarks.count > 0)
                       {
                           NSMutableArray* placeData = [[NSMutableArray alloc] init];
                           int placesCount = (int)[placemarks count];
                           for (int iLoop = 0; iLoop < placesCount; iLoop++) {
                               [placeData addObject:[helpers buildFromPlaceLocation:[placemarks objectAtIndex:iLoop]]];
                           }
                           
                           if (callback!=nil){
                               NSDictionary *eventOk = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInt:placesCount],@"placeCount",
                                                        placeData,@"places",
                                                        NUMBOOL(YES),@"success",
                                                        nil];
                               
                               [self _fireEventToListener:@"completed"
                                               withObject:eventOk listener:callback thisObject:nil];
                           }
                       }
                       else
                       {
                           if (callback!=nil){
                               NSDictionary* eventErr = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         [error localizedDescription],@"error",
                                                         NUMBOOL(NO),@"success",nil];
                               [self _fireEventToListener:@"completed"
                                               withObject:eventErr listener:callback thisObject:nil];
                           }
                       }
                   }];
    
}

-(CLLocationManager*)tempLocationManager
{
    if (_locationManager!=nil)
    {
        // if we have an instance, just use it
        return _locationManager;
    }
 
    BXBGeoHelpers * helpers = [[BXBGeoHelpers alloc] init];
    [helpers requestPermission];
    
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        NSString * purpose = [TiUtils stringValue:[self valueForUndefinedKey:@"purpose"]];
        if(purpose!=nil){
            if ([_locationManager respondsToSelector:@selector(setPurpose)]) {
                [_locationManager setPurpose:purpose];
            }
        }
    }
    return _locationManager;
}

-(void)startFindingLocation
{
    if(_isStarted){
        return;
    }
    
    [self.tempLocationManager startUpdatingLocation];
}

-(void) shutdownFindingLocation
{
    if(_locationManager!=nil)
    {
        [[self tempLocationManager] stopUpdatingLocation];
    }
    _isStarted = NO;
}

@end
