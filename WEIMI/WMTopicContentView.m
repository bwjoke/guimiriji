//
//  WMTopicContentView.m
//  WEIMI
//
//  Created by steve on 13-7-5.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMTopicContentView.h"
#import "UIColor+HexString.h"
#import "NKPictureViewer.h"

@implementation WMTopicContentView

@synthesize contentEmojo;

-(void)dealloc
{
    picture.target = nil;
    [super dealloc];
}

+(CGFloat)heightForContent:(WMMTopicCotent *)content supportEmojo:(BOOL)supportEmojo
{
    CGFloat totalHeight = 0;
    
    if ([content.type isEqualToString:@"text"]) {
        if (supportEmojo) {
            LWVMRichTextContent *postContent = [[LWVMRichTextContent alloc] initWithContent:content.value
                                                                                   withType:LWVMRichTextShowContentTypeFeedDetail];
            
            [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
            totalHeight = postContent.height;
        }else {
            totalHeight = [content.value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
        }
    }else if ([content.type isEqualToString:@"pic"]) {
        totalHeight = 180;
    }
    
    return totalHeight;
}

-(id)initWithContent:(WMMTopicCotent *)content supportEmojo:(BOOL)supportEmojo
{
    showContent = content;
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [WMTopicContentView heightForContent:content supportEmojo:supportEmojo])];
    if (self) {
        if ([showContent.type isEqualToString:@"text"]) {
            if (supportEmojo) {
                self.contentEmojo = [[[LWRichTextContentView alloc] initWithFrame:CGRectMake(13, 0, 294, self.frame.size.height) withFont:[UIFont systemFontOfSize:14] withTextColor:[UIColor colorWithHexString:@"#7E6B5A"] withTextShadowColor:nil withTextShadowOffSet:CGSizeZero] autorelease];
                [self addSubview:contentEmojo];
                [contentEmojo setBackgroundColor:[UIColor clearColor]];
                LWVMRichTextContent *postContent = [[LWVMRichTextContent alloc] initWithContent:showContent.value
                                                                                        withType:LWVMRichTextShowContentTypeFeedDetail];
                
                [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
                
                CGRect contentsFrame = contentEmojo.frame;
                contentsFrame.size.height = postContent.height;
                contentEmojo.frame = contentsFrame;
                contentEmojo.richTextContent = postContent;
                [contentEmojo setNeedsDisplay];
            }else {
                contentLabel = [[WMCustomLabel alloc] initWithFrame:CGRectMake(13, 0, 294, self.frame.size.height) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"#7E6B5A"]];
                [contentLabel setText:showContent.value];
                //[contentLabel setTextColor:[UIColor redColor] range:NSMakeRange(2, 5)];
                contentLabel.numberOfLines = 0;
                [self addSubview:contentLabel];
            }
            
        }else if ([showContent.type isEqualToString:@"pic"]) {
            picture = [[NKKVOImageView alloc] initWithFrame:CGRectMake(13, 0, 294, 180)];
            picture.placeHolderImage = [UIImage imageNamed:@"feed_cell_pic_place"];
            picture.contentMode = UIViewContentModeScaleAspectFill;
            picture.clipsToBounds = YES;
            picture.target = self;
            picture.renderMethod = @selector(renderPicture:);
            picture.singleTapped = @selector(preView:);
            [picture bindValueOfModel:showContent forKeyPath:@"image"];
            [self addSubview:picture];
        }
    }
    return self;
}

-(UIImage*)renderPicture:(UIImage*)image{
    
    UIImage *imageToRender = image?image:picture.placeHolderImage;
    
   // ZUOMAttachment *feedAtt = [self.showdFeed.attachments lastObject];
    
    if ([[showContent type] isEqualToString:@"pic"]) {
        
        CGRect pictureFrame = picture.frame;
        pictureFrame.size.width = MIN(imageToRender.size.width/imageToRender.size.height*pictureFrame.size.height, imageToRender==picture.placeHolderImage?110:224);
        pictureFrame.size.height = 180;
        picture.frame = pictureFrame;
        
    }

    
    return imageToRender;
}

-(void)preView:(id)sender{
    
    NKPictureViewer *viewer = [NKPictureViewer pictureViewerForView:picture];
    [viewer showPictureForObject:showContent andKeyPath:@"image"];
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
