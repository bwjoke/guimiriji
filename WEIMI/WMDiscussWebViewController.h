//
//  WMDiscussWebViewController.h
//  WEIMI
//
//  Created by steve on 13-7-10.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"

@interface WMDiscussWebViewController : WMTableViewController<UIWebViewDelegate>

@property(nonatomic,strong)NSString *url;
@end
