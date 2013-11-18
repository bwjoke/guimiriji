//
//  WMChooseSchoolViewController.h
//  WEIMI
//
//  Created by Tang Tianyong on 7/29/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMSchoolListViewController.h"

@protocol WMChooseSchoolViewDelegate <NSObject>

@optional
- (void)schoolDidSelect:(NSDictionary *)university;

@end

@interface WMChooseSchoolViewController : WMTableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, WMSchoolListViewDelegate>

@property (nonatomic, assign) id<WMChooseSchoolViewDelegate> delegate;

@property (nonatomic, copy) NSString *initialProvince;

@end
