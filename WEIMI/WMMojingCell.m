//
//  WMMojingCell.m
//  WEIMI
//
//  Created by SteveMa on 13-10-25.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMMojingCell.h"
#import "UIColor+HexString.h"
#import "WMMirror.h"

@implementation WMMojingCell

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
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        titileLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 230, 15)];
        titileLabel.backgroundColor = [UIColor clearColor];
        titileLabel.font = [UIFont systemFontOfSize:14.0];
        titileLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self.contentView addSubview:titileLabel];
        
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 13, 152, 15)];
        countLabel.textAlignment = NSTextAlignmentRight;
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.font = [UIFont systemFontOfSize:14.0];
        countLabel.textColor = [UIColor colorWithHexString:@"#A6937C"];
        [self.contentView addSubview:countLabel];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(255, 13, 9, 15)];
        icon.image = [UIImage imageNamed:@"arrow"];
        [self addSubview:icon];
        
        topicBadge = [[UIImageView alloc] initWithFrame:CGRectMake(48, 10, 14, 14)];
        topicBadge.image = [UIImage imageNamed:@"xiaohongdian"];
        topicBadge.hidden = YES;
        [self.contentView addSubview:topicBadge];
    
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_normal"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_cell_click"]];
    }
    return self;
}

-(void)showIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource hasNotification:(BOOL)hasNotification
{
    [iconView removeFromSuperview];
    iconView = nil;
    countLabel.text = nil;
    topicBadge.hidden = YES;
    CGRect frame = CGRectMake(20, 13, 230, 15);
    titileLabel.frame = frame;
    topicBadge.frame = CGRectMake(48, 10, 14, 14);
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0: {
                    titileLabel.text = @"夫妻相大测试";
                    CGRect frame = titileLabel.frame;
                    frame.origin.x = frame.origin.x + 58;
                    titileLabel.frame = frame;
                    if (!iconView) {
                        iconView = [[NKKVOImageView alloc] initWithFrame:CGRectMake(20, 8, 54, 25)];
                        iconView.image = [UIImage imageNamed:@"couple_icon"];
                        [self.contentView addSubview:iconView];
                    }
                    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"showCoupleTest"] boolValue]) {
                        topicBadge.hidden = NO;
                        CGRect frame = topicBadge.frame;
                        frame.origin.x = 164;
                        frame.origin.y = 8;
                        topicBadge.frame = frame;
                    }
                
                    break;
                }
                default:{
                    
                    break;
                }
            }
            
            
            break;
        }
        default: {
            WMMirror *mirror = [dataSource objectAtIndex:(indexPath.section-1)];
            titileLabel.text = mirror.title;
            topicBadge.hidden = [mirror.red boolValue];
            if (!iconView && [mirror.iconUrl length]) {
                iconView = [[NKKVOImageView alloc] initWithFrame:CGRectMake(20, 8, 25, 25)];
                iconView.image = [UIImage imageNamed:@"couple_icon"];
                [iconView bindValueOfModel:mirror forKeyPath:@"icon"];
                iconView.contentMode = UIViewContentModeScaleAspectFill;
                iconView.clipsToBounds = YES;
                iconView.layer.cornerRadius = 4.0f;
                iconView.target = self;
                iconView.renderMethod = @selector(renderPicture:);
                [self.contentView addSubview:iconView];
            }else if([mirror.red boolValue]){
                CGFloat width = [mirror.title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(230, 15) lineBreakMode:NSLineBreakByCharWrapping].width;
                CGRect frame = topicBadge.frame;
                frame.origin.x = titileLabel.frame.origin.x + width +4;
                topicBadge.frame = frame;
            }
            
            break;
        }
    }
}

-(UIImage*)renderPicture:(UIImage*)image{
    
    UIImage *imageToRender = image?image:nil;
    CGRect frame = iconView.frame;
    frame.size.width = MIN(imageToRender.size.width/imageToRender.size.height*frame.size.height, imageToRender==iconView.placeHolderImage?25:25);
    frame.size.height = 25;
    //pictureFrame.origin.x = 200-(pictureFrame.size.width+28)+76;
    iconView.frame = frame;
    
    frame = titileLabel.frame;
    frame.origin.x = iconView.frame.origin.x + iconView.frame.size.width +10;
    titileLabel.frame = frame;
    
    CGFloat width = [titileLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(230, 15) lineBreakMode:NSLineBreakByCharWrapping].width;
    frame = topicBadge.frame;
    frame.origin.x = titileLabel.frame.origin.x + width +4;
    topicBadge.frame = frame;
    
    
    
    
    
    return imageToRender;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        topicBadge.hidden = YES;
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
