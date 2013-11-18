//
//  WMSmallImageView.m
//  WEIMI
//
//  Created by steve on 13-8-14.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMSmallImageView.h"

@implementation WMSmallImageView

-(void)dealloc
{
    [self.avatarRequest clearDelegatesAndCancel];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame url:(NSString *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.layer.cornerRadius = 6.0;
        imageUrl = url;
        imageView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        //imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        CALayer *l = [imageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:3.0];
        imageView.image = [UIImage imageNamed:@"default_portrait"];
        [self addSubview:imageView];
        [self downLoadImage];
    }
    return self;
}

-(void)downLoadImage{
    
    if (downloadingImage) {
        return;
    }
    downloadingImage = YES;

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithImageURL:[NSURL URLWithString:imageUrl]];
    request.delegate = self;
    self.avatarRequest = request;
    [request setDidFinishSelector:@selector(downLoadAvatarFinish:)];
    [request setDidFailSelector:@selector(downLoadAvatarFailed:)];
    
    //[[NKSDK sharedSDK] addTicket:(NKTicket*)request];
    [request startAsynchronous];
    
}

-(void)downLoadAvatarFinish:(ASIHTTPRequest*)request{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        UIImage *avatarImage = [UIImage imageWithContentsOfFile:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request]];
        if (avatarImage) {
            imageView.image = avatarImage;
            
            downloadingImage = NO;
        }
        
        self.avatarRequest = nil;
    });
    
}

-(void)downLoadAvatarFailed:(ASIHTTPRequest*)request
{
    downloadingImage = NO;
    //imageView.image = [UIImage imageNamed:@"default_portrait"];
    self.avatarRequest = nil;
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
