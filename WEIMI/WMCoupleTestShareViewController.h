//
//  WMCoupleTestShareViewController.h
//  WEIMI
//
//  Created by Tang Tianyong on 10/11/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@interface WMCoupleTestShareViewController : WMTableViewController

@property (nonatomic, assign) CGFloat score;
@property (nonatomic, retain) UIImage *manAvatar;
@property (nonatomic, retain) UIImage *womanAvatar;
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) void(^goBackAction)(void);

@end
