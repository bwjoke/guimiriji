//
//  WMPersonTagView.h
//  WEIMI
//
//  Created by mzj on 13-2-26.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKKVOImageView.h"

@interface WMPersonTagView : UIView

@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) NKKVOImageView *infoImageView;
@property (nonatomic, retain) UIImageView *notifyImageView;

@end
