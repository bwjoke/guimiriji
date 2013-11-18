//
//  WMSetMobileViewController.h
//  WEIMI
//
//  Created by steve on 13-4-27.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
@protocol WMSetMobileViewControllerDelegate <NSObject>

@optional
-(void)reloadMobile;

@end

#import "WMTableViewController.h"
#import "WMTextField.h"

@interface WMSetMobileViewController : WMTableViewController

@property (nonatomic, assign) WMTextField *textField;
@property (nonatomic, assign)id<WMSetMobileViewControllerDelegate>delegate;
@end
