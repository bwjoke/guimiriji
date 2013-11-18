//
//  WMBindDetailViewController.h
//  WEIMI
//
//  Created by Tang Tianyong on 7/16/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@protocol WMBindDetailViewDelegate <NSObject>

@optional
- (void)unbindDidSuccess:(NSString *)type;

@end

@interface WMBindDetailViewController : WMTableViewController <UIAlertViewDelegate>

@property (nonatomic, retain) NSString *type;
@property (nonatomic, assign) id<WMBindDetailViewDelegate>delegate;

@end
