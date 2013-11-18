//
//  WMManUserCell.h
//  WEIMI
//
//  Created by King on 3/14/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "NKTableViewCell.h"
#import "WMDataService.h"

@interface WMManUserCell : NKTableViewCell

@property (nonatomic, assign) NKKVOImageView *avatar;

@property (nonatomic, assign) UILabel        *name;
@property (nonatomic, assign) UILabel        *detail;

@property (nonatomic, assign) UIImageView    *relation;

@property (nonatomic, assign) UILabel        *score;
@property (nonatomic, assign) UIImageView    *lock;

@end
