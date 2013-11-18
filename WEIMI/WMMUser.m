//
//  WMMUser.m
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMMUser.h"

@implementation WMMUser

-(void)dealloc{
    [_createTime release];
    [_virtual_user release];
    [super dealloc];
}

-(void)bindValuesForDic:(NSDictionary*)dic{
    
    [super bindValuesForDic:dic];
    
    NKBindValueWithKeyForParameterFromDic(@"name", self.name, dic);
    NKBindValueWithKeyForParameterFromDic(@"relationship", self.relation, dic);
    NKBindValueWithKeyForParameterFromDic(@"virtual", self.virtual_user, dic);
    
    
    
    self.createTime = [NSDate dateWithTimeIntervalSince1970:[[dic objectOrNilForKey:@"created_at"] longLongValue]];
    if ([dic valueForKey:@"nosms"]) {
        self.noSMS = YES;
    }else {
        self.noSMS = NO;
    }
    
}

@end
