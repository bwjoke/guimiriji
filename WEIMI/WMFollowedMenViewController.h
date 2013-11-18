//
//  WMFollowedMenViewController.h
//  WEIMI
//
//  Created by King on 3/14/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMManDetailViewController.h"

@interface WMFollowedMenViewController : WMTableViewController<WMManDetailDelegate>


@property (nonatomic, retain) WMMUser *user;
@property (nonatomic)BOOL hideProgress;
@end
