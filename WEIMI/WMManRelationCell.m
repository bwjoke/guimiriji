//
//  WMManRelationCell.m
//  WEIMI
//
//  Created by steve on 13-8-1.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMManRelationCell.h"
#import "WMCustomLabel.h"
#import "WMMMan.h"
#import "UIColor+HexString.h"
#import "TTTAttributedLabel.h"

static CGRect ReasonLabelInitFrame = (CGRect){15.0f, 50.0f, 290.0f, 0.0f};

@interface WMManRelationCell ()

+ (NSString *)reasonString:(WMManGrilFriend *)girlFriend;

@end

@implementation WMManRelationCell
{
    WMCustomLabel *addLabel,*grilLabel;
    UIImageView *sepLine;
    TTTAttributedLabel *_reasonLabel;
    UIImageView *_supportedView;
}

+ (TTTAttributedLabel *)reasonLabel {
    TTTAttributedLabel *reasonLabel = [[TTTAttributedLabel alloc] initWithFrame:ReasonLabelInitFrame];
    
    reasonLabel.font = [UIFont systemFontOfSize:14.0f];
    reasonLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    reasonLabel.numberOfLines = 0;
    
    return reasonLabel;
}

+ (NSString *)reasonString:(WMManGrilFriend *)girlFriend {
    NSMutableArray *reasons = [[NSMutableArray alloc] init];
    
    for (WMMRelation *relation in girlFriend.relations) {
        [reasons addObject:[NSString stringWithFormat:@"%@: %@", relation.name, relation.desc]];
    }
    
    return [reasons componentsJoinedByString:@"\n"];
}

+ (CGFloat)cellHeightForObject:(WMManGrilFriend *)girlFriend {
    static TTTAttributedLabel *label = nil;
    
    if (label == nil) {
        label = [self reasonLabel];
    }
    
    CGFloat height = 55.0f;
    
    NSString *reasonString = [self reasonString:girlFriend];
    
    if ([reasonString length] > 0) {
        
        [label setText:reasonString];
        
        CGSize size = [label sizeThatFits:CGSizeMake(ReasonLabelInitFrame.size.width, CGFLOAT_MAX)];
        
        height += size.height;
        
        height += 10.0f;
    }
    
    return height;
}

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
        addLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(0, 18, 320, 15) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"#A6937C"]];
        addLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview: addLabel];
        
        grilLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(15, 18, 245, 20) font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithHexString:@"#A6937C"]];
        [self addSubview:grilLabel];
        
        sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54, 320, 1)];
        sepLine.backgroundColor = [UIColor colorWithHexString:@"#F1ECE4"];
        [self addSubview:sepLine];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFF4F4"];
        
        _reasonLabel = [[self class] reasonLabel];
        [self addSubview:_reasonLabel];
        
        _supportedView = [[UIImageView alloc] init];
        _supportedView.center = CGPointMake(290.0f, 30.0f);
        _supportedView.bounds = (CGRect){CGPointZero, 30.0f, 30.0f};
        [self addSubview:_supportedView];
    }
    return self;
}

-(void)showForObject:(id)object
{
    addLabel.hidden = YES;
    grilLabel.hidden = NO;
    sepLine.hidden = NO;
    _reasonLabel.hidden = YES;
    _supportedView.hidden = NO;
    
    if (!object) {
        addLabel.hidden = NO;
        grilLabel.hidden = YES;
        sepLine.hidden = YES;
        _supportedView.hidden = YES;
        addLabel.text = @"+添加交往对象姓名";
        return;
    }
    
    WMManGrilFriend *gril = object;
    
    grilLabel.text = [NSString stringWithFormat:@"%@ (%@人赞同)",gril.name,[gril.count stringValue]];
    [grilLabel setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, [gril.name length])];
    
    // Reason label
    
    if (gril.relations.count) {
        _reasonLabel.hidden = NO;
        _reasonLabel.text = [[self class] reasonString:gril];
        CGSize size = [_reasonLabel sizeThatFits:CGSizeMake(ReasonLabelInitFrame.size.width, CGFLOAT_MAX)];
        _reasonLabel.frame = (CGRect){ReasonLabelInitFrame.origin, size};
    }
    
    // Seperate line
    CGRect sepFrame = sepLine.frame;
    sepFrame.origin.y = [[self class] cellHeightForObject:gril] - 1;
    sepLine.frame = sepFrame;
    
    // Support image
    _supportedView.image = [UIImage imageNamed:[gril.isSupport boolValue] ? @"man_tag_supported" : @"man_tag_support"];
}

@end
