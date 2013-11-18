//
//  WMManUserCell.m
//  WEIMI
//
//  Created by King on 3/14/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMManUserCell.h"

@implementation WMManUserCell

-(void)dealloc{
    
    
    [super dealloc];
}

+(CGFloat)cellHeightForObject:(id)object{
    
    return 55;
}

-(void)showForObject:(id)object{
    
    self.showedObject = object;
    
    WMMManUser *manUser = object;
    
    //[_avatar bindValueOfModel:[manUser.isAnonymous boolValue]?nil:manUser.user forKeyPath:@"avatar"];
    
    //_name.text = [manUser.isAnonymous boolValue]?@"匿名用户":manUser.user.name;
    [_avatar bindValueOfModel:manUser.user forKeyPath:@"avatar"];
    _name.text = manUser.user.name;
    
    _detail.text = [NSString stringWithFormat:@"打分项 %@  |  爆料 %@", manUser.scoreCount, manUser.baoliaoCount];
    
    CGRect relationFrame = _relation.frame;
    relationFrame.origin.x = _name.frame.origin.x+[_name.text sizeWithFont:_name.font].width + 10;
    _relation.frame = relationFrame;
    
    if ([manUser.relation isEqualToString:WMMManUserRelationSelf]) {
        _relation.image = [UIImage imageNamed:@"relation_self"];
    }
    else if ([manUser.relation isEqualToString:WMMManUserRelationGuimi]) {
        _relation.image = [UIImage imageNamed:@"relation_guimi"];
    }
    else if ([manUser.relation isEqualToString:WMMManUserRelationMoshen]) {
        _relation.image = [UIImage imageNamed:@"relation_moshen"];
    }

    
    _score.text = manUser.score?[NSString stringWithFormat:[manUser.score floatValue]>=10?@"%.0f":@"%.1f", [manUser.score floatValue]]:nil;
    
    _lock.hidden = [manUser.isAnonymous boolValue] || ![manUser.relation isEqualToString:WMMManUserRelationMoshen];
    
    _score.hidden = [manUser.scoreCount intValue]<=0 || !_lock.hidden;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
        self.bottomLine.image = nil;
        self.bottomLine.frame = CGRectMake(0, 54, 320, 1);
        
        self.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]] autorelease];
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFF4F4"];
        
        self.avatar = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(15, 10, 35, 35)] autorelease];
        [self.contentView addSubview:_avatar];
        _avatar.placeHolderImage = [UIImage imageNamed:@"default_portrait"];
        
        self.name = [[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 160, 13)] autorelease];
        _name.backgroundColor = [UIColor clearColor];
        _name.font = [UIFont boldSystemFontOfSize:12];
        _name.textColor = [UIColor colorWithHexString:@"#AC9B86"];
        [self.contentView addSubview:_name];
        
        self.detail = [[[UILabel alloc] initWithFrame:CGRectMake(60, 32, 260, 13)] autorelease];
        _detail.backgroundColor = [UIColor clearColor];
        _detail.font = [UIFont boldSystemFontOfSize:12];
        _detail.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self.contentView addSubview:_detail];
        
        self.relation = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"relation_self"]] autorelease];
        [self.contentView addSubview:_relation];
        CGRect relationFrame = _relation.frame;
        relationFrame.origin.x = 100;
        relationFrame.origin.y = 10;
        _relation.frame = relationFrame;
        
        self.lock = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man_lock"]] autorelease];
        [self.contentView addSubview:_lock];
        _lock.center = CGPointMake(273, 28);
        
        self.score = [[[UILabel alloc] initWithFrame:CGRectMake(240, 0, 45, 55)] autorelease];
        [self.contentView addSubview:_score];
        _score.textAlignment = NSTextAlignmentRight;
        _score.font = [UIFont systemFontOfSize:25];
        _score.textColor = [UIColor colorWithHexString:@"#EB6877"];
        _score.backgroundColor = [UIColor clearColor];
        
    }
    return self;
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
