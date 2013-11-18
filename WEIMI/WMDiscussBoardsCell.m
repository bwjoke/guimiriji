//
//  WMDiscussBoardsCell.m
//  WEIMI
//
//  Created by steve on 13-6-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMDiscussBoardsCell.h"
#import "WMMTopic.h"
#import "UIColor+HexString.h"

@implementation WMDiscussBoardsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        iconView = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(17.5, 10, 60, 60)] autorelease];
        iconView.layer.cornerRadius = 3.0f;
        [self insertSubview:iconView atIndex:0];
        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topic_board_normal"]] autorelease];
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topic_board_click"]] autorelease];
        
        badgeView = [[[NKBadgeView alloc] initWithFrame:CGRectMake(270, 0, 24, 24)] autorelease];
        badgeView.numberLabel.hidden = NO;
        //badgeView.numberLabel.font = [UIFont systemFontOfSize:12];
        [badgeView.numberLabel adjustsFontSizeToFitWidth];
        badgeView.placeHolderImage = [[UIImage imageNamed:@"topic_badge"] resizeImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
        badgeView.highlightedImage = [[UIImage imageNamed:@"topic_badge"] resizeImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
        [self addSubview:badgeView];
        
        titleLabel = [[[WMCustomLabel alloc] initWithFrame:CGRectMake(87, 10, 199, 17) font:[UIFont systemFontOfSize:17] textColor:[UIColor colorWithHexString:@"#7E6B5A"]] autorelease];
        titleLabel = [[[WMCustomLabel alloc] initWithFrame:CGRectMake(87, 10, 199, 17) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithHexString:@"#7E6B5A"]] autorelease];
        [self addSubview:titleLabel];
        
        tLabelOne = [[[WMCustomLabel alloc] initWithFrame:CGRectMake(87, 37, 199, 13) font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"#7E6B5A"]] autorelease];
        [self addSubview:tLabelOne];
        
        tLabelTwo = [[[WMCustomLabel alloc] initWithFrame:CGRectMake(87, 58, 199, 13) font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"#7E6B5A"]] autorelease];
        [self addSubview:tLabelTwo];
    }
    
    return self;
}

-(void)showForObject:(id)object
{
    WMMTopicBoard *topic = object;
    [iconView bindValueOfModel:topic forKeyPath:@"icon"];
    titleLabel.text = topic.name;
    
    if ([topic.count integerValue]>0) {
        if ([topic.count integerValue]>999) {
            badgeView.numberLabel.text = @"999+";//[topic.count stringValue];
        }else {
            badgeView.numberLabel.text = [topic.count stringValue];
        }
        
        CGRect frame = badgeView.frame;
        frame.size.width = [badgeView.numberLabel.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(200, 10) lineBreakMode:NSLineBreakByCharWrapping].width+18;
        frame.origin.x = 313-frame.size.width;
        badgeView.frame = frame;
        frame = badgeView.bounds;
        frame.origin.y = -1;
        frame.origin.x = -1;
        badgeView.numberLabel.frame = frame;
        badgeView.hidden = NO;
    }else {
        badgeView.hidden = YES;
    }
    
    if ([topic.titles count]>0) {
        tLabelOne.text = [topic.titles objectAtIndex:0];
    }
    
    if ([topic.titles count]>1) {
        tLabelTwo.text = [topic.titles objectAtIndex:1];
    }
}

@end
