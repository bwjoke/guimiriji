//
//  WMTopicDetailViewController.h
//  WEIMI
//
//  Created by steve on 13-6-9.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "JSBridgeWebView.h"

@interface WMTopicDetailViewController : WMTableViewController<JSBridgeWebViewDelegate>

@property(nonatomic,retain)NSString *URL;
@end
