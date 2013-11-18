//
//  WMMarginTextView.h
//  WEIMI
//
//  Created by ZUO on 7/1/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface WMTextView : UIView

@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, retain) UIPlaceHolderTextView *textView;

@end
