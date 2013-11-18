//
//  WMSmallImageView.h
//  WEIMI
//
//  Created by steve on 13-8-14.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKSDK.h"

@interface WMSmallImageView : UIView<ASIHTTPRequestDelegate>
{
    UIImageView *imageView;
    NSString *imageUrl;
    BOOL downloadingImage;
}
@property (nonatomic, assign) ASIHTTPRequest *avatarRequest;
-(id)initWithFrame:(CGRect)frame url:(NSString *)url;
@end
