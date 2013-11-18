//
//  WMTagButton.h
//  WEIMI
//
//  Created by steve on 13-5-24.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

@protocol WMTagButtonDelegate <NSObject>

@optional
-(void)buttonTapAtIndex:(int)index;

@end

#import <UIKit/UIKit.h>

@interface WMTagButton : UIButton

+(CGFloat)widthOfButton:(NSString *)tag;

- (id)initWithFrame:(CGRect)frame tag:(NSString *)tag index:(int)index;

@property(nonatomic,assign)id<WMTagButtonDelegate>delegate;
@end
