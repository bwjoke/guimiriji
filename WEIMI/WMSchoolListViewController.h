//
//  WMSchoolListViewController.h
//  WEIMI
//
//  Created by Tang Tianyong on 7/29/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@protocol WMSchoolListViewDelegate <NSObject>

@optional
- (void)schoolDidSelect:(NSDictionary *)university;

@end

@interface WMSchoolListViewController : WMTableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *schools;
@property (nonatomic, assign) id<WMSchoolListViewDelegate> delegate;

@end
