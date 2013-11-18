//
//  UIImage+Adaptive.h
//  WEIMI
//
//  Created by Tang Tianyong on 10/11/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Adaptive)

+ (BOOL)isIPhone5;

+ (UIImage *)adaptiveImageWithName:(NSString *)name;

@end
