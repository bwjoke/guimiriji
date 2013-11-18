//
//  WMAddZDYDafenViewController.h
//  WEIMI
//
//  Created by King on 4/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@interface WMAddZDYDafenViewController : WMTableViewController

@property (nonatomic, assign) NKTextViewWithPlaceholder *textField;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL finishAction;

@end
