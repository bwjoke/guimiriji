// WMManInterestCell.m
//
// Copyright (c) 2013 Tang Tianyong
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
// KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
// AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

#import "WMManInterestCell.h"
#import "WMCustomLabel.h"
#import "UIColor+HexString.h"
#import "WMMMan.h"
#import "TTTAttributedLabel.h"

static CGRect ReasonLabelInitFrame = (CGRect){15.0f, 50.0f, 290.0f, 0.0f};

@implementation WMManInterestCell {
    WMCustomLabel *addLabel,*interestLabel;
    UIImageView *sepLine;
    TTTAttributedLabel *_reasonLabel;
    UIImageView *_supportedView;
}

+ (TTTAttributedLabel *)reasonLabel {
    TTTAttributedLabel *reasonLabel = [[TTTAttributedLabel alloc] initWithFrame:ReasonLabelInitFrame];
    //[reasonLabel setAdjustsFontSizeToFitWidth:YES];
    reasonLabel.font = [UIFont systemFontOfSize:14.0f];
    reasonLabel.textColor = [UIColor colorWithHexString:@"#7E6B5A"];
    reasonLabel.numberOfLines = 0;
    
    return reasonLabel;
}

+ (NSString *)reasonString:(WMManInterest *)interest {
    NSMutableArray *reasons = [[NSMutableArray alloc] init];
    
    for (WMMRelation *relation in interest.relations) {
        [reasons addObject:[NSString stringWithFormat:@"%@: %@", relation.name, relation.desc]];
    }
    
    return [reasons componentsJoinedByString:@"\n"];
}

+ (CGFloat)cellHeightForObject:(WMManInterest *)interest {
    static TTTAttributedLabel *label = nil;
    
    if (label == nil) {
        label = [self reasonLabel];
    }
    
    CGFloat height = 55.0f;
    
    NSString *reasonString = [self reasonString:interest];
    
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
        
        interestLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(15, 18, 245, 20) font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithHexString:@"#A6937C"]];
        [interestLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:interestLabel];
        
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
    _reasonLabel.hidden = YES;
    
    if ([object isKindOfClass:[NSString class]]) {
        addLabel.hidden = NO;
        interestLabel.hidden = YES;
        addLabel.text = object;
        sepLine.hidden = YES;
        return;
    }
    WMManInterest *interest = object;
    addLabel.hidden = YES;
    interestLabel.hidden = NO;
    sepLine.hidden = NO;
    
    interestLabel.text = [NSString stringWithFormat:@"%@ (%@人赞同)",interest.name,[interest.count stringValue]];
    [interestLabel setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, [interest.name length])];
    
    // Reason label
    
    if (interest.relations.count) {
        _reasonLabel.hidden = NO;
        _reasonLabel.text = [[self class] reasonString:interest];
        CGSize size = [_reasonLabel sizeThatFits:CGSizeMake(ReasonLabelInitFrame.size.width, CGFLOAT_MAX)];
        _reasonLabel.frame = (CGRect){ReasonLabelInitFrame.origin, size};
    }
    
    // Seperate line
    CGRect sepFrame = sepLine.frame;
    sepFrame.origin.y = [[self class] cellHeightForObject:interest] - 1;
    sepLine.frame = sepFrame;
    
    // Support image
    _supportedView.image = [UIImage imageNamed:[interest.voted boolValue] ? @"man_tag_supported" : @"man_tag_support"];
}

@end
