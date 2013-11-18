//
//  WMMenCell.m
//  WEIMI
//
//  Created by King on 11/21/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import "WMMenCell.h"
#import "WMDataService.h"
#import "WMNotificationCenter.h"

@implementation WMMenCell


+(CGFloat)cellHeightForObject:(id)object{
    
    return 85;
}


-(void)showForObject:(id)object{
    
    self.showedObject = object;
    
    if (![self.showedObject isKindOfClass:[WMMMan class]]) {
        return;
    }
    
    WMMMan *man = object;
    self.name.text = man.name?man.name:man.weiboName;
    self.count.text = [NSString stringWithFormat:@"交往过%@人 | %d条点评, 浏览%@次", [man.gfCount stringValue], [man.baoliaoCount intValue]+[man.scoreCount intValue], man.viewCount];
    
    if (_tagBg) {
        for (UIView *view in [_tagBg subviews]) {
            [view removeFromSuperview];
            view = nil;
        }
    }
    
    [_avatar bindValueOfModel:man forKeyPath:@"avatar"];
    
//    CGRect scoreFrame = _score.frame;
//    scoreFrame.size.width = _score.image.size.width * (([man.score floatValue]+10)/20);
//    _score.frame = scoreFrame;
    
    
    
    if (man.mid) {
        self.accessoryView = nil;
        self.count.hidden = NO;
        //_tags.hidden = NO;
        self.score.hidden = NO;
        self.scoreB.hidden = NO;
        self.scoreLabel.hidden = NO;
        
        CGRect nameFrame = _name.frame;
        nameFrame.origin.y = 12;
        _name.frame = nameFrame;
        
        NSString *scoreTextColorHex = nil;
        
        if ([man.score floatValue] <= 2) {
            _score.image = [UIImage imageNamed:@"man_score_two_small"];
            CGRect scoreFrame = _score.frame;
            if ([man.score floatValue] <=0) {
                scoreFrame.size.width = _score.image.size.width/5.0 * 0.44;
            }else {
                scoreFrame.size.width = _score.image.size.width/5.0 * 0.44+_score.image.size.width/13.0 * ([man.score floatValue]/2.0);
            }
            _score.frame = scoreFrame;
            scoreTextColorHex = @"#beca6f";
        } else if ([man.score floatValue]<=4) {
            _score.image = [UIImage imageNamed:@"man_score_one_small"];
            CGRect scoreFrame = _score.frame;
            scoreFrame.size.width =  _score.image.size.width * ([man.score floatValue])/10.0;
            _score.frame = scoreFrame;
            scoreTextColorHex = @"#dbe2b0";
        } else if ([man.score floatValue]<=6) {
            _score.image = [UIImage imageNamed:@"man_score_three_small"];
            CGRect scoreFrame = _score.frame;
            scoreFrame.size.width =  _score.image.size.width * ([man.score floatValue])/10.0;
            _score.frame = scoreFrame;
            scoreTextColorHex = @"#f5b4b6";
        } else if ([man.score floatValue]<=8) {
            _score.image = [UIImage imageNamed:@"man_score_four_small"];
            CGRect scoreFrame = _score.frame;
            scoreFrame.size.width =  _score.image.size.width * ([man.score floatValue])/10.0;
            _score.frame = scoreFrame;
            scoreTextColorHex = @"#f29396";
        } else if ([man.score floatValue]<=10) {
            _score.image = [UIImage imageNamed:@"man_score_five_small"];
            CGRect scoreFrame = _score.frame;
            scoreFrame.size.width =  _score.image.size.width * ([man.score floatValue])/10.0;
            _score.frame = scoreFrame;
            scoreTextColorHex = @"#eb6877";
        }
        
        self.scoreLabel.text = [man scoreDescription];
        self.scoreLabel.textColor = [UIColor colorWithHexString:scoreTextColorHex];
    }
    else{
        self.count.hidden = YES;
        //_tags.hidden = YES;
        self.score.hidden = YES;
        self.scoreB.hidden = YES;
        self.scoreLabel.hidden = YES;
        
        CGRect nameFrame = _name.frame;
        nameFrame.origin.y = 35;
        _name.frame = nameFrame;
        
        
        UIButton *dianpinButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 30)] autorelease];
        self.accessoryView = dianpinButton;
        
        [dianpinButton setBackgroundImage:[UIImage imageNamed:@"dianpin_normal"] forState:UIControlStateNormal];
        [dianpinButton setBackgroundImage:[UIImage imageNamed:@"dianpin_click"] forState:UIControlStateHighlighted];
                dianpinButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
                dianpinButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                [dianpinButton setTitleShadowColor:[UIColor colorWithHexString:@"#e32d3c"] forState:UIControlStateNormal];
        //        [dianpinButton setTitleColor:[UIColor colorWithHexString:@"#A6937C"] forState:UIControlStateNormal];
                [dianpinButton setTitle:@"+点评" forState:UIControlStateNormal];
        dianpinButton.userInteractionEnabled = NO;
        
        
    }
    
    if (_shouldShowBadge) {
        //NSDictionary *dic = [[[WMNotificationCenter sharedNKNotificationCenter] manDic] objectOrNilForKey:[[WMMUser me] mid]];
        NSDictionary *dic = [[WMNotificationCenter sharedNKNotificationCenter] manDic];
        NSArray *arr = [dic allValues];
        for (int i=0;i<[arr count]; i++) {
            if (![dic isKindOfClass:[NSNull class]]) {
                NSDictionary *dics = [arr objectAtIndex:i];
                for (NSNumber *numbers in [dics allKeys]) {
                     NSNumber *number = [dics objectOrNilForKey:man.mid];
                    self.feedBadge.hidden = ![number boolValue];
                    break;
                }
            }
            if (!self.feedBadge.isHidden) {
                break;
            }
            
        }
    }
    
    NSArray *colors = [NSArray arrayWithObjects:[UIImage imageNamed:@"tag_bg_1"],[UIImage imageNamed:@"tag_bg_2"],[UIImage imageNamed:@"tag_bg_3"],[UIImage imageNamed:@"tag_bg_4"], nil];
    
    if ([man.tags count]) {
        CGFloat totalWidth = 0;
        for (int i=0; i<[man.tags count]; i++) {
            NSString *manTag = @"";
            NSString *lastManTag = @"";
            manTag = [NSString stringWithFormat:@"%@(%@)", [[man.tags objectAtIndex:i] name], [[man.tags objectAtIndex:i] supportCount]];
            if (i>0) {
                lastManTag = [NSString stringWithFormat:@"%@(%@)", [[man.tags objectAtIndex:i-1] name], [[man.tags objectAtIndex:i-1] supportCount]];
            }
            
            CGFloat x = i==0?0:[WMTagLabel widthOfLabel:lastManTag type:0]+1;
            totalWidth += x;
            if (totalWidth + [WMTagLabel widthOfLabel:manTag type:0] <=222) {
                _tags = [[[WMTagLabel alloc] initWithFrame:CGRectMake(totalWidth, 0, [WMTagLabel widthOfLabel:manTag type:0], 18.5) tag:manTag color:[colors objectAtIndex:i>3?3:i] type:0] autorelease];
                [_tagBg addSubview:_tags];
                _tags.backgroundColor = [UIColor clearColor];
            }else if (222-totalWidth>20){
                _tags = [[[WMTagLabel alloc] initWithFrame:CGRectMake(totalWidth, 0, 222-totalWidth, 18.5) tag:manTag color:[colors objectAtIndex:i>3?3:i] type:0] autorelease];
                [_tagBg addSubview:_tags];
                _tags.backgroundColor = [UIColor clearColor];
                return;
                
            }
            
            //[_tagBg insertSubview:_tags atIndex:0];
            
        }
        
    }
    //self.tags.backgroundColor = [UIColor colorWithHexString:@"#EB6877"];
    //self.tags.text = manTags;
    //self.tags.textColor = [UIColor whiteColor];
    
    
    
}

-(void)pictureTapped:(UITapGestureRecognizer*)gesture{
    
    WMMMan *man = self.showedObject;
    if (man.avatar) {
        NKPictureViewer *viewer = [NKPictureViewer pictureViewerForView:self.avatar];
        [viewer showPictureForObject:man andKeyPath:@"avatarBig"];
    }

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    
        [self.bottomLine removeFromSuperview];
        self.bottomLine = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 84, 320, 1)] autorelease];
        self.bottomLine.image = [UIImage imageNamed:@"men_cell_sep"];
        [self addSubview:self.bottomLine];
        //self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
        
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFF4F4"];
        
        self.avatar = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)] autorelease];
        _avatar.target = self;
        _avatar.layer.cornerRadius = 4.0f;
//        _avatar.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        _avatar.layer.shadowOffset = CGSizeMake(0, 0);
//        _avatar.layer.shadowOpacity = 0.5;
        //_avatar.singleTapped = @selector(pictureTapped:);
        [self.contentView addSubview:_avatar];
        _avatar.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
        
        UIImageView *avatarCover = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)] autorelease];
        avatarCover.image = [UIImage imageNamed:@"photo_cover"];
        [self.contentView addSubview:avatarCover];
        
        self.feedBadge = [[[NKBadgeView alloc] initWithFrame:CGRectMake(65, 6, 14, 14)] autorelease];
        self.feedBadge.numberLabel.hidden = YES;
        self.feedBadge.placeHolderImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        self.feedBadge.highlightedImage = [[UIImage imageNamed:@"xiaohongdian"] resizeImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        self.feedBadge.hidden = YES;
        [self.contentView addSubview:self.feedBadge];
        
        self.name = [[[UILabel alloc] initWithFrame:CGRectMake(85, 12, 120, 16)] autorelease];
        [self.contentView addSubview:_name];
        _name.backgroundColor = [UIColor clearColor];
        _name.font = [UIFont boldSystemFontOfSize:15];
        _name.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
        
        self.count = [[[UILabel alloc] initWithFrame:CGRectMake(85, 34, 215, 13)] autorelease];
        [self.contentView addSubview:_count];
        _count.backgroundColor = [UIColor clearColor];
        _count.font = [UIFont systemFontOfSize:12];
        _count.textColor = [UIColor colorWithHexString:@"#A6937C"];
        
        self.tagBg = [[[UIView alloc] initWithFrame:CGRectMake(85, 53, 215, 13)] autorelease];
        [self.contentView addSubview:_tagBg];
        _tagBg.backgroundColor = [UIColor clearColor];
        

        UIImageView *scoreBack = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_tini"]] autorelease];
        [self.contentView addSubview:scoreBack];
        CGRect scoreBackFrame = scoreBack.frame;
        scoreBackFrame.origin.x = 218;
        scoreBackFrame.origin.y = 16;
//        scoreBackFrame.size.width = 140;
//        scoreBackFrame.size.height = 17;
        scoreBack.frame = scoreBackFrame;
        self.scoreB = scoreBack;
        
        self.score = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_score_two_small"]] autorelease];
//        CGRect scoreFrame = self.score.frame;
//        scoreFrame.size.width = 140;
//        scoreFrame.size.height = 17;
//        self.score.frame = scoreFrame;
        [scoreBack addSubview:_score];
        _score.contentMode = UIViewContentModeLeft;
        _score.clipsToBounds = YES;
        
        UILabel *scoreLabel = [[[UILabel alloc] initWithFrame:CGRectMake(280, 10, 30, 20)] autorelease];
        [scoreLabel adjustsFontSizeToFitWidth];
        scoreLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:14];
        scoreLabel.textColor = [UIColor colorWithHexString:@"#EB6877"];
        scoreLabel.textAlignment = UITextAlignmentCenter;
        scoreLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:scoreLabel];
        _scoreLabel = scoreLabel;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.feedBadge.hidden = YES;
    }
    // Configure the view for the selected state
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
