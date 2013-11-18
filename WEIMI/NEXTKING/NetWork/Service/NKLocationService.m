//
//  NKLocationService.m
//  WEIMI
//
//  Created by King on 4/16/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "NKLocationService.h"

@implementation NKLocationService

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NKLoginFinishNotificationKey object:nil];
    
    self.locationManager.delegate = nil;
	[_locationManager release];
    
    [_currentLocation release];
    
    [super dealloc];
}

$singleService(NKLocationService, @"location");



-(id)init{
    
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinish:) name:NKLoginFinishNotificationKey object:nil];
        
        
    }
    return self;
}

-(void)loginFinish:(NSNotification*)anoti{
    

}

-(void)findLocation{
    
    // Create location manager with filters set for battery efficiency.
    if ([CLLocationManager locationServicesEnabled]){
        if (!self.locationManager) {
            self.locationManager = [[[CLLocationManager alloc] init] autorelease];
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        }
        
        // Start updating location changes.
    }
    else{
        
        // Location Service Not Enabled
    }
    
    [self.locationManager startUpdatingLocation];
}

-(void)findCurrentCity{
  
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	//NSLog(@"didFailWithError: %@", error);
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	//NSLog(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
	
	// Work around a bug in MapKit where user location is not initially zoomed to.
	
    self.currentLocation = newLocation;
    
    [self.locationManager stopUpdatingLocation];
}


@end
