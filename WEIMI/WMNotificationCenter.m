//
//  WMNotificationCenter.m
//  WEIMI
//
//  Created by King on 4/25/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMNotificationCenter.h"
#import "WMUserService.h"
#import "WMHoneyView.h"

@implementation WMNotificationCenter
{
    int numOfNotics;
}
@synthesize numOfNotics;

-(void)dealloc{
    
    [_hasNewFeed release];
    [_hasRequest release];
    [_hasNotification release];
    [_hasNewMan release];
    
    [_feedDic release];
    [_manDic release];
    [_imDic release];
    numOfNotics = 0;
    [super dealloc];
}


-(void)appBecomeActive{
    
    if ([WMMUser me]) {
        [self getNotificationsCount];
    }

}

-(void)getNotificationsCountDelay{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getNotificationsCount) object:nil];
    [self performSelector:@selector(getNotificationsCount) withObject:nil afterDelay:2];
    
}

-(void)getNotificationsCount{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getNotificationsCount) object:nil];
    
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(getNotificationsCountOK:) andFailedSelector:nil];
    
    [[WMUserService sharedWMUserService] getNotificationCountWithRequestDelegate:rd];
    
    [self performSelector:@selector(getNotificationsCount) withObject:nil afterDelay:15.0];
    
}

-(void)getNotificationsCountOK:(NKRequest*)request{
    
    numOfNotics = 0;
    NSDictionary *counts = [request.originDic objectOrNilForKey:@"data"];
    
    
    self.feedDic = [counts objectOrNilForKey:@"feeds"];
    self.manDic = [counts objectOrNilForKey:@"men"];
    self.imDic = [counts objectOrNilForKey:@"im"];
    
    self.hasRequest = [counts objectOrNilForKey:@"requests"];
    self.hasNotification = [counts objectOrNilForKey:@"notification"];
    //self.hasRequest = [NSNumber numberWithBool:YES];
    
    BOOL hasFeed = NO;
    
    for (NSNumber *number in [self.feedDic allValues]) {
       
        if ([number boolValue]) {
            numOfNotics +=1;
            hasFeed = YES;
        }
    }
    
    BOOL hasMen = NO;
    if ([self.manDic isKindOfClass:[NSDictionary class]] && ![self.manDic isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dic in [self.manDic allValues]) {
            if (![dic isKindOfClass:[NSNull class]]) {
                for (NSNumber *number in [dic allValues]) {
                    //NSLog(@"*&&&&&&&&&&*： :%@",number);
                    if ([number boolValue]) {
                        //numOfNotics +=1;
                        hasMen = YES;
                        break;
                    }
                }
            }
            
        }
    }
    
    BOOL hasMessage = NO;
    if ([self.imDic isKindOfClass:[NSDictionary class]] && ![self.imDic isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dic in [self.imDic allValues]) {
            if (![dic isKindOfClass:[NSNull class]]) {
                if ([[dic valueForKey:@"unread"] boolValue]) {
                    numOfNotics += 1;
                    hasMessage = YES;
                }
            }
        }
    }
    
    self.hasNewFeed = [NSNumber numberWithBool:hasFeed];
    self.hasNewMan = [NSNumber numberWithBool:hasMen];
    self.hasNewMessage = [NSNumber numberWithBool:hasMessage];
    
    [[WMHoneyView shareHoneyView:CGRectZero] relaodBadge];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numOfNotics];
}

@end
