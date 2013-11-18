//
//  WMSetNameViewController.h
//  WEIMI
//
//  Created by steve on 13-4-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMTextField.h"

@interface WMSetNameViewController : WMTableViewController<NKSegmentControlDelegate>

@property (nonatomic, assign) WMTextField *textField;
@end
