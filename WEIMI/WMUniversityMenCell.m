//
//  WMUniversityMenCell.m
//  WEIMI
//
//  Created by steve on 13-8-10.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMUniversityMenCell.h"


@implementation WMUniversityMenCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        titleLabel = [[[WMCustomLabel alloc] initWithFrame:CGRectMake(15, 10, 225, 16) font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor colorWithHexString:@"#7E6B5A"]] autorelease];
        [self.contentView  addSubview:titleLabel];
        
        UIImageView *sep = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 84, 320, 1)] autorelease];
        sep.backgroundColor = [UIColor colorWithHexString:@"#EAE0D1"];
        UIImageView *relationArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]] autorelease];
        [self.contentView  addSubview:relationArrow];
        relationArrow.center = CGPointMake(305, 43);
        [self.contentView  addSubview:sep];
        
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFF4F4"];
    }
    
    return self;
}

-(void)showForObject:(id)object
{
    id universityMan = object;
    if ([universityMan isKindOfClass:[WMUniversityManList class]]) {
        universityMan = (WMUniversityManList *)universityMan;
        [self showUniversityMan:universityMan];
    }else {
        universityMan = (WMManList *)universityMan;
        [self showMan:universityMan];
    }
    
}

-(void)showMan:(WMManList *)universityMan
{
    titleLabel.text = universityMan.name;
    
    if (_bigImageview) {
        [_bigImageview removeFromSuperview];
        _bigImageview = nil;
    }
    
    [avatarCover removeFromSuperview];
    avatarCover = nil;
    [smallImageListView removeFromSuperview];
    smallImageListView = nil;
    [moreSmallImageListView removeFromSuperview];
    moreSmallImageListView = nil;
    
    if ([universityMan.bigAvatarPath length] && [universityMan.smallImages count]>0) {
        //大图小图都有
        _bigImageview = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)] autorelease];
        _bigImageview.layer.cornerRadius = 4.0;
        _bigImageview.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
        [_bigImageview bindValueOfModel:universityMan forKeyPath:@"avatarImage"];
        
        [self.contentView insertSubview:_bigImageview atIndex:0];
        
        
        avatarCover = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)] autorelease];
        avatarCover.image = [UIImage imageNamed:@"photo_cover"];
        [self.contentView  insertSubview:avatarCover aboveSubview:_bigImageview];
        
        smallImageListView = [[[UIView alloc] initWithFrame:CGRectMake(85, 35, 202, 36)] autorelease];
        [self.contentView  addSubview:smallImageListView];
        
        CGRect frame = titleLabel.frame;
        frame.origin.x = 85;
        frame.origin.y = 12;
        frame.size.width = 155;
        titleLabel.frame = frame;
        for (int i=0; i<[universityMan.smallImages count]; i++) {
            if (i>4) {
                return;
            }
            WMSmallImageView *smallImageView = [[[WMSmallImageView alloc] initWithFrame:CGRectMake(i*41, 0, 36, 36) url:[universityMan.smallImages objectAtIndex:i]] autorelease];
            smallImageView.layer.cornerRadius = 6.0;
            [smallImageListView addSubview:smallImageView];
        }
    }else if ([universityMan.bigAvatarPath length] && [universityMan.smallImages count]==0) {
        //只有大图
        _bigImageview = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)] autorelease];
        _bigImageview.layer.cornerRadius = 4.0;
        _bigImageview.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
        [_bigImageview bindValueOfModel:universityMan forKeyPath:@"avatarImage"];
        
        [self.contentView  addSubview:_bigImageview];
        
        avatarCover = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)] autorelease];
        avatarCover.image = [UIImage imageNamed:@"photo_cover"];
        [self.contentView  insertSubview:avatarCover aboveSubview:_bigImageview];
        
        CGRect frame = titleLabel.frame;
        frame.origin.y = 35;
        frame.origin.x = 85;
        frame.size.width = 155;
        titleLabel.frame = frame;
    }else if (![universityMan.bigAvatarPath length] && [universityMan.smallImages count]>0) {
        //只有小图
        moreSmallImageListView = [[[UIView alloc] initWithFrame:CGRectMake(15, 35, 226, 36)] autorelease];
        [self.contentView  addSubview:moreSmallImageListView];
        
        CGRect frame = titleLabel.frame;
        frame.origin.x = 15;
        frame.origin.y = 12;
        frame.size.width = 155;
        titleLabel.frame = frame;
        for (int i=0; i<[universityMan.smallImages count]; i++) {
            WMSmallImageView *smallImageView = [[[WMSmallImageView alloc] initWithFrame:CGRectMake(i*41, 0, 36, 36) url:[universityMan.smallImages objectAtIndex:i]] autorelease];
            [moreSmallImageListView addSubview:smallImageView];
        }
    }else {
        //没有图
        CGRect frame = titleLabel.frame;
        frame.origin.x = 15;
        frame.origin.y = 35;
        titleLabel.frame = frame;
    }
}

-(void)showUniversityMan:(WMUniversityManList *)universityMan
{
    titleLabel.text = universityMan.name;
    
    if (_bigImageview) {
        [_bigImageview removeFromSuperview];
        _bigImageview = nil;
    }
    
    [avatarCover removeFromSuperview];
    avatarCover = nil;
    [smallImageListView removeFromSuperview];
    smallImageListView = nil;
    [moreSmallImageListView removeFromSuperview];
    moreSmallImageListView = nil;
    
    if ([universityMan.bigImagePath length] && [universityMan.smallImages count]>0) {
        //大图小图都有
        _bigImageview = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)] autorelease];
        _bigImageview.layer.cornerRadius = 4.0;
        _bigImageview.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
        [_bigImageview bindValueOfModel:universityMan forKeyPath:@"bigImage"];
        [self.contentView insertSubview:_bigImageview atIndex:0];
        
        
        avatarCover = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)] autorelease];
        avatarCover.image = [UIImage imageNamed:@"photo_cover"];
        [self.contentView  insertSubview:avatarCover aboveSubview:_bigImageview];
        
        smallImageListView = [[[UIView alloc] initWithFrame:CGRectMake(85, 35, 202, 36)] autorelease];
        [self.contentView  addSubview:smallImageListView];
        
        CGRect frame = titleLabel.frame;
        frame.origin.x = 85;
        frame.origin.y = 12;
        frame.size.width = 155;
        titleLabel.frame = frame;
        for (int i=0; i<[universityMan.smallImages count]; i++) {
            if (i>4) {
                return;
            }
            WMSmallImageView *smallImageView = [[[WMSmallImageView alloc] initWithFrame:CGRectMake(i*41, 0, 36, 36) url:[universityMan.smallImages objectAtIndex:i]] autorelease];
            smallImageView.layer.cornerRadius = 6.0;
            [smallImageListView addSubview:smallImageView];
        }
    }else if ([universityMan.bigImagePath length] && [universityMan.smallImages count]==0) {
        //只有大图
        _bigImageview = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)] autorelease];
        _bigImageview.layer.cornerRadius = 4.0;
        _bigImageview.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
        [_bigImageview bindValueOfModel:universityMan forKeyPath:@"bigImage"];
        [self.contentView  addSubview:_bigImageview];
        
        avatarCover = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)] autorelease];
        avatarCover.image = [UIImage imageNamed:@"photo_cover"];
        [self.contentView  insertSubview:avatarCover aboveSubview:_bigImageview];
        
        CGRect frame = titleLabel.frame;
        frame.origin.y = 35;
        frame.origin.x = 85;
        frame.size.width = 155;
        titleLabel.frame = frame;
    }else if (![universityMan.bigImagePath length] && [universityMan.smallImages count]>0) {
        //只有小图
        moreSmallImageListView = [[[UIView alloc] initWithFrame:CGRectMake(15, 35, 226, 36)] autorelease];
        [self.contentView  addSubview:moreSmallImageListView];
        
        CGRect frame = titleLabel.frame;
        frame.origin.x = 15;
        frame.origin.y = 12;
        frame.size.width = 155;
        titleLabel.frame = frame;
        for (int i=0; i<[universityMan.smallImages count]; i++) {
            WMSmallImageView *smallImageView = [[[WMSmallImageView alloc] initWithFrame:CGRectMake(i*41, 0, 36, 36) url:[universityMan.smallImages objectAtIndex:i]] autorelease];
            [moreSmallImageListView addSubview:smallImageView];
        }
    }else {
        //没有图
        CGRect frame = titleLabel.frame;
        frame.origin.x = 15;
        frame.origin.y = 35;
        titleLabel.frame = frame;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
