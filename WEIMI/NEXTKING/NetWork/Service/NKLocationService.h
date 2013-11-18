//
//  NKLocationService.h
//  WEIMI
//
//  Created by King on 4/16/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "NKServiceBase.h"
#import <CoreLocation/CoreLocation.h>

@interface NKLocationService : NKServiceBase <CLLocationManagerDelegate>


dshared(NKLocationService);


@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;

-(void)findLocation;



@end
