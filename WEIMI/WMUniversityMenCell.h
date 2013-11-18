//
//  WMUniversityMenCell.h
//  WEIMI
//
//  Created by steve on 13-8-10.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "NKTableViewCell.h"
#import "WMCustomLabel.h"
#import "UIColor+HexString.h"
#import "WMUniversity.h"
#import "WMSmallImageView.h"
#import "WMMMan.h"

@interface WMUniversityMenCell : NKTableViewCell
{
    WMCustomLabel *titleLabel;
    NKKVOImageView *_bigImageview;
    UIView *smallImageListView;
    UIView *moreSmallImageListView;
    UIImageView *avatarCover;
}
//@property(nonatomic,assign)UIImageView *bigImageview;
-(void)showForObject:(id)object;
@end
