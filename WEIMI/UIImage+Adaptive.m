//
//  UIImage+Adaptive.m
//  WEIMI
//
//  Created by Tang Tianyong on 10/11/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "UIImage+Adaptive.h"

static CGFloat __screenHeight = 480.0f;

@implementation UIImage (Adaptive)

+ (void)initialize {
    __screenHeight = [[UIScreen mainScreen] bounds].size.height;
}

+ (BOOL)isIPhone5 {
    return __screenHeight == 568.0f;
}

+ (UIImage *)adaptiveImageWithName:(NSString *)name {
    if (__screenHeight == 568.0f) {
        name = [NSString stringWithFormat:@"%@-568h", name];
    }
    
    return [UIImage imageNamed:name];
}

@end
