//
//  WMMenCell.h
//  WEIMI
//
//  Created by King on 11/21/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "NKTableViewCell.h"
#import "WMTagLabel.h"
#import "NKBadgeView.h"

@interface WMMenCell : NKTableViewCell

@property (nonatomic, assign) NKKVOImageView *avatar;

@property (nonatomic, assign) UILabel *name;
@property (nonatomic, assign) UILabel *count;
@property (nonatomic, assign) UIView *tagBg;
@property (nonatomic, assign) WMTagLabel *tags;

@property (nonatomic, assign) UIImageView *score;
@property (nonatomic, assign) UIImageView *scoreB;
@property (nonatomic, assign) UILabel *scoreLabel;

@property (nonatomic, assign) NKBadgeView *feedBadge;

@property (nonatomic, assign) BOOL shouldShowBadge;
@property (nonatomic, assign) NSString *user_id;
@end
