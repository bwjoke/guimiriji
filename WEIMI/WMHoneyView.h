//
//  WMHoneyView.h
//  WEIMI
//
//  Created by steve on 13-4-15.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//
@protocol WMHoneyViewDelegate <NSObject>

@optional
-(void)avatarTapedAtIndex:(NSInteger)index;
-(void)addFriend;
-(void)reloadFavPage;
@end

#import <UIKit/UIKit.h>
#import "WMUserService.h"

@interface WMHoneyView : UIView
{
    WMMUser *currentUser;
    UIImageView *feedBadge1,*feedBadge2,*feedBadge3,*feedBadge4;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic)int currentIndex;
@property (nonatomic)BOOL isAddView;
@property (nonatomic,unsafe_unretained) id<WMHoneyViewDelegate>delegate;
@property (nonatomic)BOOL shouldReloadUserPage;
@property(nonatomic)BOOL isMiyuPage;

+(WMHoneyView *)shareHoneyView:(CGRect)frame;

+(void)clean;
-(void)relaodData:(WMMUser *)reloadUser;

-(void)relaodBadge;
@end
