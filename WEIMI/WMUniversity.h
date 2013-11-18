//
//  WMUniversity.h
//  WEIMI
//
//  Created by steve on 13-8-10.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMModel.h"

@interface WMUniversityManList : WMModel

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *desc;
@property(nonatomic,retain)NSString *bigImagePath;
@property(nonatomic,retain)UIImage *bigImage;
@property(nonatomic,retain)NSMutableArray *smallImages;

@end
