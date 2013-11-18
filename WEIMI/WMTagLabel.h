//
//  WMTagLabel.h
//  WEIMI
//
//  Created by steve on 13-5-21.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMTagLabel : UIImageView

@property(nonatomic,assign)UILabel *textLabel;
+(CGFloat)widthOfLabel:(NSString *)tag type:(int)type;
- (id)initWithFrame:(CGRect)frame tag:(NSString *)tag color:(UIImage *)image type:(int)type;
@end
