//
//  WMHelpView.h
//  WEIMI
//
//  Created by steve on 13-5-15.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMHelpView : UIView
{
    UIImageView *imageView;
}

@property (nonatomic, copy) void(^helpDidRemoved)(void);

-(void)setImage:(UIImage *)image;
@end
