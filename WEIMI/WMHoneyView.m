//
//  WMHoneyView.m
//  WEIMI
//
//  Created by steve on 13-4-15.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMHoneyView.h"
#import "NKKVOImageView.h"
#import "NKBadgeView.h"
#import "UIImage+NKImage.h"
#import "WMNotificationCenter.h"
#import "NKDataStore.h"

#import "WMAppDelegate.h"

@implementation WMHoneyView
{
    UIButton *addButton;
}

static WMHoneyView *_honeyView = nil;

-(void)dealloc
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"targetNil" object:nil];
}

+(WMHoneyView *)shareHoneyView:(CGRect)frame;
{
    
    
    if (_honeyView == nil) {
        _honeyView = [[WMHoneyView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    }else {
        //[_honeyView setCurrentIndex:0];
        [_honeyView listFriends];
    }
    
    return _honeyView;
}

+(void)clean
{
    _honeyView = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self listFriends];
        _currentIndex = 0;
        currentUser = [WMMUser me];
        self.dataSource = [[NKDataStore sharedDataStore] cachedArrayOf:@"honeyUsers" andClass:[WMMUser class]];
        if (![self.dataSource count]) {
            self.dataSource = [NSMutableArray array];
        }else {
            [self showFriends];
        }
    }
    return self;
}


-(void)listFriends{
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(listFriendsOK:) andFailedSelector:@selector(listFriendsFailed:)];
    [[WMUserService  sharedWMUserService] getRelatedUsersWithUID:nil andRequestDelegate:rd];
    
}

-(void)listFriendsOK:(NKRequest*)request{
    [self.dataSource removeAllObjects];
   // self.dataSource = [NSMutableArray arrayWithArray:request.results];
    [self.dataSource addObjectsFromArray:request.results];
    
    if ([WMMUser me]) {
        [self.dataSource insertObject:[WMMUser me] atIndex:0];
    }
    
    if (_isAddView && !_shouldReloadUserPage) {
        [self addFriend:nil];
        
    }else {
        [self showFriends];
        if (_shouldReloadUserPage) {
            //_currentIndex = [self.dataSource count]-1;
            [self reloadUserPage:currentUser];
            _shouldReloadUserPage = NO;
            _isAddView = NO;
            for (int i=0; i<[self.dataSource count]; i++) {
                WMMUser *user = [self.dataSource objectAtIndex:i];
                if ([user.mid floatValue] == [currentUser.mid floatValue]) {
                    _currentIndex = i;
                    break;
                }
            }
        }
        for (int i=0; i<[self.dataSource count]; i++) {
            UIView *hiddenView = [self viewWithTag:i+10000];
            hiddenView.alpha = 0.4;
            if (i==_currentIndex) {
                hiddenView.alpha = 1.0;
            }
        }
    }
    
    [[NKDataStore sharedDataStore] cacheArray:self.dataSource forCacheKey:@"honeyUsers"];
    
    
}

-(void)relaodData:(WMMUser *)reloadUser;
{
    currentUser = reloadUser;
//    for (int i=0; i<[self.dataSource count]; i++) {
//        WMMUser *tmpUser = [self.dataSource objectAtIndex:i];
//        if ([tmpUser.mid isEqualToString:currentUser.mid] ) {
//            _currentIndex = i;
//            break;
//        }else if ([self.dataSource count]>1) {
//            _currentIndex = [self.dataSource count]-1;
//        }
//    }
    [self listFriends];
    
}

-(void)reloadUserPage:(WMMUser *)user
{
    int reloadIndex = 0;
    
    for (int i=0; i<[self.dataSource count]; i++) {
        WMMUser *tmpUser = [self.dataSource objectAtIndex:i];
        if ([tmpUser.mid isEqualToString:user.mid] ) {
            reloadIndex = i;
            break;
        }else if ([self.dataSource count]>1) {
            reloadIndex = [self.dataSource count]-1;
        }
    }
    //[self showContentWithUser:[self.dataSource objectAtIndex:reloadIndex]];
    _currentIndex = reloadIndex;
    //[self tapped:nil];
    //[_delegate avatarTapedAtIndex:reloadIndex];
    _isAddView = NO;
    NKKVOImageView *view = (NKKVOImageView *)[self viewWithTag:_currentIndex];
    view.alpha = 1.0;
    //WMMUser *user = [view modelObject];
    //[self showContentWithUser:user];
    _currentIndex = view.tag;
    for (int i=0; i<[self.dataSource count]; i++) {
        UIView *hiddenView = [self viewWithTag:i+10000];
        hiddenView.alpha = 0.4;
        if (i==_currentIndex) {
            hiddenView.alpha = 1.0;
        }
    }
    //view.alpha = 1.0;
    if ([self.dataSource count]<5) {
        addButton.alpha = 0.4;
    }
    
    
    UIImageView *badageView = (UIImageView *)[self viewWithTag:1212+view.tag];//[[[self viewWithTag:10000+view.tag] subviews] lastObject];
    badageView.hidden = YES;
    [_delegate avatarTapedAtIndex:reloadIndex];
    
}

-(void)showFriends{
    
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat startX = 20;
    CGFloat startY = 15;
    CGFloat avatarDistance = 20;
    CGFloat avatarWidth = 40;
    
    UIView *avatarBgView = nil;
    
    NKKVOImageView *avatar = nil; 

    for (int i=0;i<[self.dataSource count];i++) {
        WMMUser *user = [self.dataSource objectAtIndex:i];
        avatarBgView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, avatarWidth, avatarWidth)];
        avatarBgView.tag = 11200+i;
        [self addSubview:avatarBgView];
        
        avatar = [[NKKVOImageView alloc] initWithFrame:CGRectMake(0, 0, avatarWidth, avatarWidth)];
        avatar.tag = i;
        
        avatar.layer.cornerRadius = 6.0;
        //avatar.placeHolderImage = [UIImage imageNamed:@"miyu_avatar_wating"];
        [avatar bindValueOfModel:user forKeyPath:@"avatar"];
        
        [avatarBgView addSubview:avatar];

        
        if ([user.relation isEqualToString:NKRelationFollowing]) {
            //avatar.placeHolderImage = [UIImage imageNamed:@"miyu_avatar_wating"];
        }
        
        avatar.target = self;
        avatar.singleTapped = @selector(tapped:);
        
        UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"miyu_avatar_shadow_normal"]];
        //[avatarBgView addSubview:shadow];
        avatarBgView.tag = i+10000;
        //avatar.clipsToBounds = NO;
        if (i==_currentIndex) {
            avatarBgView.alpha = 1.0;
        }else {
            avatarBgView.alpha = 0.4;
        }
        
        shadow.frame = CGRectMake(-1, -1, shadow.frame.size.width, shadow.frame.size.height);
        startX += avatarDistance+avatarWidth;
        
        
        UIImageView *feedBadge = [[UIImageView alloc] initWithFrame:CGRectMake(55+60*i, 10, 14, 14)];
        feedBadge.image = [UIImage imageNamed:@"xiaohongdian"];
        feedBadge.hidden = YES;
        feedBadge.tag = 1212+i;
        [self addSubview:feedBadge];
        
        switch (i) {
            case 0:{
                feedBadge1 = [[UIImageView alloc] initWithFrame:CGRectMake(55+60*(i+1), 10, 14, 14)];
                feedBadge1.image = [UIImage imageNamed:@"xiaohongdian"];
                feedBadge1.hidden = YES;
                feedBadge1.tag = 1213+i;
                [self addSubview:feedBadge1];
                break;
            }
            case 1:{
                feedBadge2 = [[UIImageView alloc] initWithFrame:CGRectMake(55+60*(i+1), 10, 14, 14)];
                feedBadge2.image = [UIImage imageNamed:@"xiaohongdian"];
                feedBadge2.hidden = YES;
                feedBadge2.tag = 1213+i;
                [self addSubview:feedBadge2];
                break;
            }
            case 2:{
                feedBadge3 = [[UIImageView alloc] initWithFrame:CGRectMake(55+60*(i+1), 10, 14, 14)];
                feedBadge3.image = [UIImage imageNamed:@"xiaohongdian"];
                feedBadge3.hidden = YES;
                feedBadge3.tag = 1213+i;
                [self addSubview:feedBadge3];
                break;
            }
            case 3:{
                feedBadge4 = [[UIImageView alloc] initWithFrame:CGRectMake(55+60*(i+1), 10, 14, 14)];
                feedBadge4.image = [UIImage imageNamed:@"xiaohongdian"];
                feedBadge4.hidden = YES;
                feedBadge4.tag = 1213+i;
                [self addSubview:feedBadge4];
                break;
            }
            default:
                break;
        }
    }
    
    if ([self.dataSource count]<5) {
        addButton = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, avatarWidth, avatarWidth)];
        addButton.alpha = 0.4;
        [addButton setImage:[UIImage imageNamed:@"miyu_avatar_add"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"miyu_avatar_add"] forState:UIControlStateHighlighted];
        [addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        //addButton.layer.cornerRadius = 6.0;
        [self addSubview:addButton];
        
        UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"miyu_avatar_shadow_normal"]] ;
        [addButton addSubview:shadow];
        
        shadow.frame = CGRectMake(-1, -1, shadow.frame.size.width, shadow.frame.size.height);
    }

    
    
    [self relaodBadge];
}

-(void)relaodBadge;
{
    for (int i=0;i<[self.dataSource count];i++) {
        WMMUser *user = [self.dataSource objectAtIndex:i];
        UIImageView *badageView = (UIImageView *)[self viewWithTag:1212+i];//[[[self viewWithTag:10000+i] subviews] lastObject];
        UIImageView *badageView2 = (UIImageView *)[self viewWithTag:1213+i];
        if (_isMiyuPage) {
            //badageView.hidden = ![[[[WMNotificationCenter sharedNKNotificationCenter] feedDic] objectOrNilForKey:user.mid] boolValue];
            if ([[[WMNotificationCenter sharedNKNotificationCenter] imDic] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = [[[WMNotificationCenter sharedNKNotificationCenter] imDic] objectOrNilForKey:user.mid];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    if ([[dic valueForKey:@"unread"] integerValue]>0) {
                        switch (i-1) {
                            case 0:
                                feedBadge1.hidden = NO;
                                break;
                            case 1:
                                feedBadge2.hidden = NO;
                                break;
                            case 2:
                                feedBadge3.hidden = NO;
                                break;
                            case 3:
                                feedBadge4.hidden = NO;
                                break;
                            default:
                                break;
                        }
                    }
                    //                    for (NSNumber *number in [[[[WMNotificationCenter sharedNKNotificationCenter] imDic] objectOrNilForKey:user.mid] allValues]) {
                    //                        badageView2.hidden = ![number boolValue];
                    //                        if ([number boolValue]) {
                    //
                    //                            break;
                    //                        }
                    //                    }
                }
            }
        }else {
            if ([[[WMNotificationCenter sharedNKNotificationCenter] manDic] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = [[[WMNotificationCenter sharedNKNotificationCenter] manDic] objectOrNilForKey:user.mid];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    for (NSNumber *number in [[[[WMNotificationCenter sharedNKNotificationCenter] manDic] objectOrNilForKey:user.mid] allValues]) {
                        badageView.hidden = ![number boolValue];
                        if ([number boolValue]) {
                            break;
                        }
                    }
                }
                
            }
            
            if ([[[WMNotificationCenter sharedNKNotificationCenter] imDic] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = [[[WMNotificationCenter sharedNKNotificationCenter] imDic] objectOrNilForKey:user.mid];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    if ([[dic valueForKey:@"unread"] integerValue]>0) {
                        badageView2.hidden = NO;
                    }
//                    for (NSNumber *number in [[[[WMNotificationCenter sharedNKNotificationCenter] imDic] objectOrNilForKey:user.mid] allValues]) {
//                        badageView2.hidden = ![number boolValue];
//                        if ([number boolValue]) {
//                            
//                            break;
//                        }
//                    }
                }
            }
            
        }
    
    }
}

-(void)addFriend:(id)sender
{
    //[self avatarAnimate:sender animated:YES];
    _isAddView = YES;

    for (int i=0; i<[self.dataSource count]; i++) {
        UIView *hiddenView = [self viewWithTag:i+10000];
        hiddenView.alpha = 0.4;
    }
    addButton.alpha = 1.0;
    if (_delegate) {
        [_delegate addFriend];
    }

}

-(void)tapped:(UITapGestureRecognizer*)gesture
{
    _isAddView = NO;
    NKKVOImageView *view = (NKKVOImageView *)[gesture view];
    view.alpha = 1.0;
    //WMMUser *user = [view modelObject];
    //[self showContentWithUser:user];
    _currentIndex = view.tag;
    for (int i=0; i<[self.dataSource count]; i++) {
        UIView *hiddenView = [self viewWithTag:i+10000];
        hiddenView.alpha = 0.4;
        if (i==_currentIndex) {
            hiddenView.alpha = 1.0;
        }
    }
    //view.alpha = 1.0;
    if ([self.dataSource count]<5) {
        addButton.alpha = 0.4;
    }
    
    
    UIImageView *badageView = (UIImageView *)[self viewWithTag:1212+view.tag];//[[[self viewWithTag:10000+view.tag] subviews] lastObject];
    badageView.hidden = YES;
    [_delegate avatarTapedAtIndex:_currentIndex];
    
    [[WMNotificationCenter sharedNKNotificationCenter] getNotificationsCountDelay];
//    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(reloadFriendsOK:) andFailedSelector:@selector(reloadFriendsFailed:)];
//    [[WMUserService  sharedWMUserService] getRelatedUsersWithUID:nil andRequestDelegate:rd];

    
}

-(void)reloadFriendsOK:(NKRequest *)request
{
    
    
}

-(void)showContentWithUser:(WMMUser*)user{
    
    [self showContentWithUser:user animated:YES];
    
    
}

-(void)showContentWithUser:(WMMUser*)user animated:(BOOL)animated{
    for (id subview in [self subviews]) {
        
        if ([subview isKindOfClass:[UIView class]] && [[[subview subviews] objectAtIndex:0] isKindOfClass:[NKKVOImageView class]] && [[[subview subviews] objectAtIndex:0] modelObject] == user) {
            
            //[self avatarAnimate:subview animated:animated];
        }
        
    }
    
}

-(void)avatarAnimate:(UIView*)view animated:(BOOL)animated{
    
    [UIView animateWithDuration:animated?0.2:0 animations:^{
        
        for (UIView *subview in [self subviews]) {
            
            CGRect subviewFrame = subview.frame;
            
            subviewFrame.origin.y = (subview==view)?7:12;
            
            subview.frame = subviewFrame;
            
        }
        
    }];
    
}

-(void)listFriendsFailed:(NKRequest*)request{
    
    
}



@end
