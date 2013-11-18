//
//  WMTopicContentView.h
//  WEIMI
//
//  Created by steve on 13-7-5.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMMTopic.h"
#import "WMCustomLabel.h"
#import "NKKVOImageView.h"
#import "LWRichTextContentView.h"

@interface WMTopicContentView : UIView
{
    WMMTopicCotent *showContent;
    WMCustomLabel *contentLabel;
    NKKVOImageView *picture;
    LWRichTextContentView *contentEmojo;
}
@property (nonatomic, strong) LWRichTextContentView *contentEmojo;

+(CGFloat)heightForContent:(WMMTopicCotent *)content supportEmojo:(BOOL)supportEmojo;

-(id)initWithContent:(WMMTopicCotent *)content supportEmojo:(BOOL)supportEmojo;
@end
