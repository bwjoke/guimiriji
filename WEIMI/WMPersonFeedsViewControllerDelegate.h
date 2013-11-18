//
//  WMPersonFeedsViewControllerDelegate.h
//  WEIMI
//
//  Created by mzj on 13-3-5.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WMPersonFeedsViewControllerDelegate <NSObject>

@optional
- (void)tableViewDidSwipe:(UISwipeGestureRecognizer *)swipeGesture;

@end
