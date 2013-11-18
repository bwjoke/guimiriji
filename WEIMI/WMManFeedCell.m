//
//  WMManFeedCell.m
//  WEIMI
//
//  Created by steve on 13-5-6.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMManFeedCell.h"
#import "UIImage+NKImage.h"
#import "WMMFeed.h"
#import "UIColor+HexString.h"
#import "NKPictureViewer.h"
#import "NKDateUtil.h"
#import "NKRequestDelegate.h"
#import "WMFeedService.h"
#import "NKProgressView.h"
#import "WMManDetailViewController.h"

#define WMFeedContentFont [UIFont systemFontOfSize:14]
#define Yoffset 15
@implementation WMManFeedCell
{

}
+(CGFloat)cellHeightForObject:(id)object
{
    if (![object isKindOfClass:[WMMFeed class]]) {
        return 55;
    }
    WMMFeed *feed = object;
    if (![feed.purview isEqualToString:@"open"]) {
        return 193;
    }
    if ([feed.type isEqualToString:@"baoliao"]) {
        CGFloat totalHeight = 0.0;
        totalHeight += 58;
        if ([feed.attachments count]) {
            totalHeight += 90;
        }
        if ([feed.audioURLString length]>0) {
            totalHeight += 33;
        }
        CGFloat height = [feed.content sizeWithFont:WMFeedContentFont constrainedToSize:CGSizeMake(290, 50) lineBreakMode:NSLineBreakByWordWrapping].height;
        if (height>50) {
            height = 50;
        }
        totalHeight += height;
        totalHeight += 40;
        
        return totalHeight;
    }else if ([feed.type isEqualToString:@"score"]) {
        return 170;
    }
    
    return 55;
}

-(void)showForObject:(id)object
{
    if (![object isKindOfClass:[WMMFeed class]]) {
        return;
    }
    self.showedObject = object;
    WMMFeed *feed = object;
    [self.dateLabel removeFromSuperview];
    self.dateLabel = nil;
    [_picture removeFromSuperview];
    _picture = nil;
    [_pictureBack removeFromSuperview];
    _pictureBack = nil;
    [self.relation removeFromSuperview];
    self.relation = nil;
    [self.avatar removeFromSuperview];
    self.avatar = nil;
    [self.name removeFromSuperview];
    self.name = nil;
    [_scoreView removeFromSuperview];
    _scoreView = nil;
    [self.rateButton removeFromSuperview];
    self.rateButton = nil;
    [self.moreButton removeFromSuperview];
    self.moreButton = nil;
    [self.commentIcon removeFromSuperview];
    self.commentIcon = nil;
    [self.commentLabel removeFromSuperview];
    self.commentLabel = nil;
    [self.contentLabel removeFromSuperview];
    self.contentLabel = nil;
    [self.noneView removeFromSuperview];
    self.noneView = nil;
    [self.noViewLabel removeFromSuperview];
    self.noViewLabel = nil;
    
    [self.player removeFromSuperview];
    self.player = nil;
    
    [self.manAvatar removeFromSuperview];
    self.manAvatar = nil;
    
    [self.arrowImageView removeFromSuperview];
    self.arrowImageView = nil;
    
    [self.manName removeFromSuperview];
    self.manName = nil;
    [self.distanceLabel removeFromSuperview];
    self.distanceLabel = nil;
    
    
    
    self.distanceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(175, 38, 125, 12)] autorelease];
    self.distanceLabel.backgroundColor = [UIColor clearColor];
    self.distanceLabel.font = [UIFont systemFontOfSize:10];
    self.distanceLabel.textAlignment = UITextAlignmentRight;
    self.distanceLabel.textColor = [UIColor colorWithHexString:@"#AC9B86"];
    [self.contentView addSubview:self.distanceLabel];
    if (!feed.distance) {
        self.distanceLabel.text = feed.dist;
        self.relation = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"relation_self"]] autorelease];
        [self.contentView addSubview:_relation];
        CGRect relationFrame = _relation.frame;
        relationFrame.origin.x = 60;
        relationFrame.origin.y = 36;
        _relation.frame = relationFrame;
        self.avatar = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 16, 35, 35)] autorelease];
        self.avatar.layer.cornerRadius = 6.0f;
        [self.contentView addSubview:_avatar];
        _avatar.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
        
        self.name = [[[UILabel alloc] initWithFrame:CGRectMake(60, 16, 160, 13)] autorelease];
        _name.backgroundColor = [UIColor clearColor];
        _name.font = [UIFont boldSystemFontOfSize:12];
        _name.textColor = [UIColor colorWithHexString:@"#AC9B86"];
        [self.contentView addSubview:_name];
        
        if ([feed.sender.relation isEqualToString:@"自己"]) {
            _relation.image = [UIImage imageNamed:@"relation_self"];
        }
        else if ([feed.sender.relation isEqualToString:@"闺蜜"]) {
            _relation.image = [UIImage imageNamed:@"relation_guimi"];
        }
        else if ([feed.sender.relation isEqualToString:@"陌生人"]) {
            _relation.image = [UIImage imageNamed:@"relation_moshen"];
        }
    }else {        
        
        self.distanceLabel.text = feed.distance;
        
        self.relation = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"relation_self"]] autorelease];
        [self.contentView addSubview:_relation];
        CGRect relationFrame = _relation.frame;
        relationFrame.origin.x = 169;
        relationFrame.origin.y = 36;
        _relation.frame = relationFrame;
        self.avatar = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(128, 16, 35, 35)] autorelease];
        self.avatar.layer.cornerRadius = 6.0f;
        [self.contentView addSubview:_avatar];
        _avatar.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
        
        self.name = [[[UILabel alloc] initWithFrame:CGRectMake(169, 16, 90, 13)] autorelease];
        _name.backgroundColor = [UIColor clearColor];
        _name.font = [UIFont boldSystemFontOfSize:12];
        _name.textColor = [UIColor colorWithHexString:@"#AC9B86"];
        [self.contentView addSubview:_name];
        
        if ([feed.sender.relation isEqualToString:@"自己"]) {
            _relation.image = [UIImage imageNamed:@"relation_self"];
        }
        else if ([feed.sender.relation isEqualToString:@"闺蜜"]) {
            _relation.image = [UIImage imageNamed:@"relation_guimi"];
        }
        else if ([feed.sender.relation isEqualToString:@"陌生人"]) {
            _relation.image = [UIImage imageNamed:@"relation_moshen"];
        }
        
        if (![[[[NSUserDefaults standardUserDefaults] valueForKey:@"sysFunction"] valueForKey:@"tab"] boolValue]) {
            CGRect frame = _avatar.frame;
            frame.origin.x = 15;
            _avatar.frame = frame;
            frame = _name.frame;
            frame.origin.x = 60;
            _name.frame = frame;
            frame = _relation.frame;
            frame.origin.x = 60;
            frame.origin.y = 36;
            _relation.frame = frame;
        }else {
            self.manAvatar = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 16, 35, 35)] autorelease];
            //self.manAvatar.layer.cornerRadius = 6.0f;
            [self.contentView addSubview:_manAvatar];
            _manAvatar.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
            
            [_manAvatar addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAvatar:)] autorelease]];
            _manAvatar.userInteractionEnabled = YES;
            
            self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 24, 9, 15)];
            self.arrowImageView.image = [UIImage imageNamed:@"arrow_left"];
            [self.contentView addSubview:self.arrowImageView];
            self.manName = [[[UILabel alloc] initWithFrame:CGRectMake(55, 16, 50, 30)] autorelease];
            self.manName.numberOfLines = 0;
            _manName.backgroundColor = [UIColor clearColor];
            _manName.font = [UIFont boldSystemFontOfSize:12];
            _manName.textColor = [UIColor colorWithHexString:@"#AC9B86"];
            [self.contentView addSubview:_manName];
            
            _manName.text = feed.man.name;
            [_manAvatar bindValueOfModel:feed.man forKeyPath:@"avatar"];
        }
        
    }
    CGFloat rateBtnWidth = 30+20+[[feed.praise stringValue] sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(100, 10) lineBreakMode:NSLineBreakByWordWrapping].width;
    self.rateButton = [[[UIButton alloc] initWithFrame:CGRectMake(8, 138,rateBtnWidth , 20)] autorelease];
    if ([feed.praised boolValue]) {
        [self.rateButton setImage:[[UIImage imageNamed:@"man_rate_btn_click"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
        [self.rateButton setImage:[[UIImage imageNamed:@"man_rate_btn_click"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateHighlighted];
        [self.rateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        [self.rateButton setImage:[[UIImage imageNamed:@"man_rate_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
        [self.rateButton setImage:[[UIImage imageNamed:@"man_rate_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateHighlighted];
        [self.rateButton setTitleColor:[UIColor colorWithHexString:@"#a6937c"] forState:UIControlStateNormal];
    }
    [self.rateButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    self.rateButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.rateButton setTitle:[feed.praise stringValue] forState:UIControlStateNormal];
    //[self.rateButton setTitleColor:[UIColor colorWithHexString:@"#D1C0A5"] forState:UIControlStateNormal];
    [self.rateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [self.rateButton addTarget:self action:@selector(addRate:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rateButton];
    
    self.moreButton = [[[UIButton alloc] initWithFrame:CGRectMake(10+rateBtnWidth, 138, 40, 20)] autorelease];
    self.moreButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.moreButton setTitleColor:[UIColor colorWithHexString:@"#a6937c"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"btn_more_normal"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"btn_more_click"]  forState:UIControlStateHighlighted];
    //[self.moreButton setTitle:@"..." forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.moreButton];
    
    CGFloat width = [[feed.commentCount stringValue] sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(100, 11) lineBreakMode:NSLineBreakByWordWrapping].width;
    self.commentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(300-width, 142, width, 11)] autorelease];
    self.commentLabel.backgroundColor = [UIColor clearColor];
    self.commentLabel.text = [feed.commentCount stringValue];
    self.commentLabel.font = [UIFont systemFontOfSize:10];
    self.commentLabel.textColor = [UIColor colorWithHexString:@"#a6937c"];
    [self.contentView addSubview:self.commentLabel];
    
    self.commentIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(300-width-16, 144, 10, 10)] autorelease];
    self.commentIcon.image = [UIImage imageNamed:@"man_comment_icon"];
    [self.contentView addSubview:self.commentIcon];
    
    if (![feed.purview isEqualToString:@"open"]) {
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"man_cell_bg_click"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]] autorelease];
        self.noneView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 60, 290, 91)] autorelease];
        self.noneView.image = [UIImage imageNamed:@"wuquanxian_bg"];
        [self.contentView addSubview:self.noneView];
        
        self.noViewLabel = [[[UILabel alloc] initWithFrame:CGRectMake(25, 30, 240, 20)] autorelease];
        self.noViewLabel.backgroundColor = [UIColor clearColor];
        self.noViewLabel.text = @"私密内容仅对部分用户可见";
        self.noViewLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
        self.noViewLabel.font = [UIFont boldSystemFontOfSize:19];
        [self.noneView addSubview:self.noViewLabel];
        CGRect frame = self.rateButton.frame;
        frame.origin.y = 160;
        self.rateButton.frame = frame;
        frame.origin.x = 10+rateBtnWidth;
        frame.size.width = 40;
        frame.size.height = 20;
        self.moreButton.frame = frame;
        frame = self.commentIcon.frame;
        frame.origin.y = 164;
        self.commentIcon.frame = frame;
        frame = self.commentLabel.frame;
        frame.origin.y = 162;
        self.commentLabel.frame = frame;
        
    }else {
        
        if ([feed.type isEqualToString:@"baoliao"]) {
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"man_cell_bg_click"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]] autorelease];
            CGFloat totalHeight = 58;
            
            CGFloat height = [feed.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, 50) lineBreakMode:NSLineBreakByWordWrapping].height;
            self.contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 58, 290,height>50?50:height)] autorelease];
            self.contentLabel.text = feed.content;
            self.contentLabel.backgroundColor = [UIColor clearColor];
            self.contentLabel.font = [UIFont systemFontOfSize:14];
            self.contentLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
            self.contentLabel.numberOfLines = 0;
            [self.contentView addSubview:self.contentLabel];
            totalHeight += height>50?50:height;
            if ([feed.attachments count]) {
                _pictureBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_cell_picture"]] autorelease];
                [self.contentView addSubview:_pictureBack];
                _pictureBack.frame = CGRectMake(11, totalHeight+4,89,89 /*_pictureBack.frame.size.width, _pictureBack.frame.size.height*/);
                _picture = [[NKKVOImageView alloc] initWithFrame:CGRectMake(18, totalHeight+10, 75, 75)];
                [self.contentView addSubview:_picture];
                [_picture release];
                _picture.target = self;
                _picture.singleTapped = @selector(pictureTapped:);
                [_picture bindValueOfModel:[feed.attachments lastObject] forKeyPath:@"picture"];
                
                totalHeight += 90;
            }
            
            if ([feed.audioURLString length]>0) {
                totalHeight += 33.0f;
                NSURL *URL = [NSURL URLWithString:feed.audioURLString];
                int seconds = [feed.audioSecond intValue];
                self.player = [[WMAudioPlayer alloc] initWithURL:URL length:seconds];
                
                CGRect frame = self.player.frame;
                frame.origin = CGPointMake(13.0f, totalHeight - 28.0f);
                self.player.frame = frame;
                
                [self addSubview:self.player];
            }
            
            CGRect frame = self.rateButton.frame;
            frame.origin.y = totalHeight + 8;
            self.rateButton.frame = frame;
            frame.origin.x = 10+rateBtnWidth;
            frame.size.width = 40;
            frame.size.height = 20;
            self.moreButton.frame = frame;
            
            frame = self.commentIcon.frame;
            frame.origin.y = totalHeight + 14;
            self.commentIcon.frame = frame;
    
            frame = self.commentLabel.frame;
            frame.origin.y = totalHeight + 12;
            self.commentLabel.frame = frame;
            self.commentLabel.text = [feed.commentCount stringValue];
    
    
        }else if ([feed.type isEqualToString:@"score"]) {
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"man_cell_new_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]] autorelease];
            [self.scoreView removeFromSuperview];
            self.scoreView = nil;
            self.scoreView = [[[UIView alloc] initWithFrame:CGRectMake(7, 62, 306,67)] autorelease];
            self.scoreView.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
            [self.contentView addSubview:self.scoreView];
            NSArray *scores = [feed.score objectOrNilForKey:@"scores"];
            CGFloat startX = 15;
            CGFloat startY = 11;;
            UIImageView *scoreCard = nil;
            UILabel *scoreLabel = nil;
            UILabel *scoreName = nil;
            NSDictionary *scoreDic = nil;
            
            for (int i=0; i<[scores count]; i++) {
                
                scoreDic = scores[i];
                
                scoreCard = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"score_card"]] autorelease];
                CGRect scoreCardFrame = scoreCard.frame;
                scoreCardFrame.origin.x = startX;
                scoreCardFrame.origin.y =  startY;
                scoreCard.frame = scoreCardFrame;
                [_scoreView addSubview:scoreCard];
                
                scoreLabel = [[[UILabel alloc] initWithFrame:scoreCard.bounds] autorelease];
                [scoreCard addSubview:scoreLabel];
                scoreLabel.textColor = [UIColor colorWithHexString:@"#ED8387"];
                scoreLabel.textAlignment = NSTextAlignmentCenter;
                if ([[scoreDic objectOrNilForKey:@"score"] floatValue]<0) {
                    scoreLabel.text = @"负";
                }else {
                    scoreLabel.text = [NSString stringWithFormat:@"%.0f", [[scoreDic objectOrNilForKey:@"score"] floatValue]];
                }
                scoreLabel.backgroundColor = [UIColor clearColor];
                scoreLabel.font = [UIFont boldSystemFontOfSize:18];
                
                
                scoreName = [[[UILabel alloc] initWithFrame:CGRectMake(0, scoreCardFrame.size.height, scoreCardFrame.size.width, 22)] autorelease];
                [scoreCard addSubview:scoreName];
                scoreName.textColor = [UIColor colorWithHexString:@"#A6937C"];
                scoreName.textAlignment = NSTextAlignmentCenter;
                scoreName.text = [scoreDic objectOrNilForKey:@"name"];
                scoreName.backgroundColor = [UIColor clearColor];
                scoreName.font = [UIFont boldSystemFontOfSize:10];
                
                
                
                startX += 50;
                if (startX>300) {
                    UIView *coverView = [[[UIView alloc] initWithFrame:CGRectMake(295, 0, 11, 67)] autorelease];
                    coverView.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];;
                    [_scoreView addSubview:coverView];
                }
                
        
            }
        }
        
    }
    
    _name.text = feed.sender.name;
    [_avatar bindValueOfModel:feed.sender forKeyPath:@"avatar"];
    
    
    
    self.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(175, 16, 125, 12)] autorelease];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textAlignment = UITextAlignmentRight;
    self.dateLabel.textColor = [UIColor colorWithHexString:@"#AC9B86"];
    [self.contentView addSubview:self.dateLabel];
    self.dateLabel.text = [NKDateUtil intervalSinceNowWithDate:feed.createTime];
    
    
    
}

- (void)tappedAvatar:(id)sender {
    WMManDetailViewController *manDetailViewController = [[[WMManDetailViewController alloc] init] autorelease];
    manDetailViewController.man = [self.showedObject man];
    manDetailViewController.shouldGetNotification = YES;
    [NKNC pushViewController:manDetailViewController animated:YES];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        self.backgroundView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"man_cell_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]] autorelease];
        
    }
    
    return self;
}

-(void)showMore:(id)sender
{
    WMMFeed *feed = self.showedObject;
    [_delegate showMoreView:feed];
}

-(void)addRate:(id)sender
{
    WMMFeed *feed = self.showedObject;
    if ([feed.praised boolValue]) {
        feed.praise = [NSNumber numberWithInt:[feed.praise intValue]-1];
        feed.praised = [NSNumber numberWithInt:0];
        [self.rateButton setImage:[[UIImage imageNamed:@"man_rate_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
        [self.rateButton setImage:[[UIImage imageNamed:@"man_rate_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateHighlighted];
        [self.rateButton setTitleColor:[UIColor colorWithHexString:@"#a6937c"] forState:UIControlStateNormal];
        [self.rateButton setTitle:[feed.praise stringValue] forState:UIControlStateNormal];
        CGRect frame = self.rateButton.frame;
        frame.size.width = 30+20+[[feed.praise stringValue] sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(100, 10) lineBreakMode:NSLineBreakByWordWrapping].width;
        self.rateButton.frame = frame;
    }else {
        feed.praise = [NSNumber numberWithInt:[feed.praise intValue]+1];
        feed.praised = [NSNumber numberWithInt:1];
        [self.rateButton setImage:[[UIImage imageNamed:@"man_rate_btn_click"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
        [self.rateButton setImage:[[UIImage imageNamed:@"man_rate_btn_click"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateHighlighted];
        [self.rateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rateButton setTitle:[feed.praise stringValue] forState:UIControlStateNormal];
        CGRect frame = self.rateButton.frame;
        frame.size.width = 30+20+[[feed.praise stringValue] sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(100, 10) lineBreakMode:NSLineBreakByWordWrapping].width;
        self.rateButton.frame = frame;
    }
    [_delegate setRate:_index feed:feed];
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(rateSuccess:) andFailedSelector:@selector(rateFaild:)];
    [[WMFeedService sharedWMFeedService] praiseFeedWithFID:feed.mid andRequestDelegate:rd];
}

-(void)rateSuccess:(NKRequest *)request
{
    WMMFeed *feed = [request.results lastObject];
    
    if (![feed.praised boolValue]) {
        
    }else {
        
    }
}

-(void)rateFaild:(NKRequest *)request
{
    
}

-(void)pictureTapped:(UITapGestureRecognizer*)gesture{
    
    NKPictureViewer *viewer = [NKPictureViewer pictureViewerForView:[gesture view]];
    [viewer showPictureForObject:[[self.showedObject attachments] lastObject] andKeyPath:@"picture"];
    
}
@end
