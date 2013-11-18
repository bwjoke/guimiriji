//
//  WMPersonTagView.m
//  WEIMI
//
//  Created by mzj on 13-2-26.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMPersonTagView.h"

@interface WMPersonTagView()

- (void)customInit;

@end

@implementation WMPersonTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (void)dealloc {
    [_backgroundImageView release];
    _backgroundImageView = nil;
    
    [_infoImageView release];
    _infoImageView = nil;
    
    [_notifyImageView release];
    _notifyImageView = nil;
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -- Private Functions

- (void)customInit {
    static NSString *backgroundImageName = @"personTagBackgroundImage";
    static NSString *notifyImageName = @"PersonTagNotify";
    
    self.backgroundColor = [UIColor clearColor];
    
    self.backgroundImageView = [[[UIImageView alloc]
                                 initWithImage:[UIImage imageNamed:backgroundImageName]] autorelease];
    self.backgroundImageView.frame = self.bounds;
    [self addSubview:self.backgroundImageView];
    
    CGRect infoImageViewBound = CGRectMake(0, 0, 50, 48);
    self.infoImageView = [[[NKKVOImageView alloc] initWithFrame:infoImageViewBound] autorelease];
    self.infoImageView.center = self.backgroundImageView.center;
    [self addSubview:self.infoImageView];
    
    UIImage *notifyImage = [UIImage imageNamed:notifyImageName];
    self.notifyImageView = [[[UIImageView alloc] initWithImage:notifyImage] autorelease];
    self.notifyImageView.center = CGPointMake(CGRectGetMaxX(self.bounds) - notifyImage.size.width * 0.4,
                                              CGRectGetMinY(self.bounds) + notifyImage.size.height * 0.4);
    [self addSubview:self.notifyImageView];
    self.notifyImageView.hidden = YES;
}

@end
