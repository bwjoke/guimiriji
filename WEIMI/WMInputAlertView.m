//
//  WMInputAlertView.m
//  WEIMI
//
//  Created by steve on 13-8-2.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMInputAlertView.h"

@implementation WMInputAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (buttonIndex == 0) {
        [super dismissWithClickedButtonIndex:0 animated:YES];
    }else {
        
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
