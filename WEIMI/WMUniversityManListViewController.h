//
//  WMUniversityManListViewController.h
//  WEIMI
//
//  Created by steve on 13-8-14.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMUniversity.h"
#import "WMManDetailViewController.h"
#import "WMCreateManViewController.h"
#import "WMMMan.h"

@interface WMUniversityManListViewController : WMTableViewController<WMManDetailDelegate>

@property(nonatomic,strong)WMUniversityManList *universityManList;
@property(nonatomic,strong)WMManList *manList;
@end
