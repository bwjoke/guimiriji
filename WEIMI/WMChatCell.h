//
//  WMChatCell.h
//  WEIMI
//
//  Created by steve on 13-9-11.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "NKTableViewCell.h"
#import "LWRichTextContentView.h"
#import "NKKit.h"
#import "WMMessage.h"
#import "WMAudioPlayer.h"

#define ChatCellchatWidth 172
#define ChatCellchatFont [UIFont systemFontOfSize:14]

@class WMChatCell;

@protocol WMChatCellDelegate <NSObject>

@optional
-(void)changeSwitch:(NSString *)state;
-(void)messageDidLongPress:(WMChatCell *)cell;

@end

@interface WMChatCell : NKTableViewCell
{
    NKKVOImageView *avatar;
    UILabel       *time;
    
    UILabel       *content;
    UIImageView   *backPop;
    
    LWRichTextContentView *contentEmojo;
    
    NKKVOLabel   *sendState;
    UIImageView  *avatarShadow;
    
    NKKVOImageView *picture;
    
    WMAudioPlayer *player;
}

@property (nonatomic, assign) NKKVOImageView *avatar;
@property (nonatomic, assign) NKKVOImageView *picture;
@property (nonatomic, assign) UILabel       *time;

@property (nonatomic, assign) UILabel       *content;
@property (nonatomic, assign) UIImageView   *backPop;

@property (nonatomic, assign) LWRichTextContentView *contentEmojo;

@property (nonatomic, assign) NKKVOLabel   *sendState;

@property (nonatomic, assign) WMAudioPlayer *player;

@property (nonatomic, unsafe_unretained) id<WMChatCellDelegate>delegate;

+ (CGFloat)cellHeightForObject:(WMMessage *)message allMessages:(NSArray *)messages;
- (void)showForObject:(WMMessage *)message allMessages:(NSArray *)messages;

@end
