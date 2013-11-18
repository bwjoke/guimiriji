//
//  WMGirlToManViewController.h
//  WEIMI
//
//  Created by King on 3/25/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMBaoliaoXiangqingViewController.h"

@interface WMGirlToManViewController : WMTableViewController<WMBaoliaoXiangqingDelegate>

@property (nonatomic, retain) WMMMan     *man;
@property (nonatomic, retain) WMMManUser *manUser;


@end
