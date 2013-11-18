//
//  WMTopicNameViewController.h
//  WEIMI
//
//  Created by Tang Tianyong on 7/23/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMTextField.h"

@protocol WMTopicNameViewDelegate <NSObject>

@optional
-(void)updateTopicnickSuccess;

@end

@interface WMTopicNameViewController : WMTableViewController

@property (nonatomic, strong) WMTextField *textField;
@property (nonatomic, assign)id<WMTopicNameViewDelegate>delegate;

@end
