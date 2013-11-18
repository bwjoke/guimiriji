//
//  WMPersonFeedsViewController.h
//  WEIMI
//
//  Created by mzj on 13-2-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@protocol WMPersonFeedsViewControllerDelegate;

@interface WMPersonFeedsViewController : WMTableViewController

@property (nonatomic, assign) id<WMPersonFeedsViewControllerDelegate> delegate;

@end
