//
//  WMMojingDetailViewViewController.h
//  WEIMI
//
//  Created by SteveMa on 13-11-4.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@interface WMMojingDetailViewViewController : WMTableViewController<UIWebViewDelegate>

@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,strong)NSString *url;
@end
