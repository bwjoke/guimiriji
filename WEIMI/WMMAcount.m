//
//  WMAcount.m
//  WEIMI
//
//  Created by steve on 13-4-25.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMAcount.h"

@implementation WMMAcount

static WMMAcount *_shareAcount = nil;


-(void)dealloc{
    
    [_loginNmae release];
    [_password release];
    [_loginEmail release];
    [_accessToken release];
    [_headeUrl release];
    [_phoneNumber release];
    [_oauthId release];
    [_type release];
    [_socialID release];
    
    
    [super dealloc];
}


+(id)shareAcount
{
    if (!_shareAcount) {
        _shareAcount = [[WMMAcount alloc] init];
    }
    
    return _shareAcount;
}

+(id)clean{
    
    [_shareAcount release];
    _shareAcount = nil;
    
    return nil;
    
}

@end
