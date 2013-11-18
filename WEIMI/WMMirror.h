//
//  WMMirror.h
//  WEIMI
//
//  Created by SteveMa on 13-11-4.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMModel.h"

@interface WMMirror : WMModel
{
    NSString *title,*url,*iconUrl,*red;
    UIImage *icon;
}

@property(nonatomic,strong)NSString *title,*url,*iconUrl,*red;
@property(nonatomic,strong)UIImage *icon;
@end
