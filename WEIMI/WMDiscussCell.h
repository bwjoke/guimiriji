//
//  WMDiscussCell.h
//  WEIMI
//
//  Created by steve on 13-7-1.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "NKTableViewCell.h"
#import "WMMTopic.h"
#import "WMCustomLabel.h"
#import "LWRichTextContentView.h"

@interface WMDiscussCell : NKTableViewCell
{
    WMCustomLabel *_titleLabel,*_fromLabel,*_contentLabel,*_dateLabel,*_commentNumLabel;
    UIImageView *_topIcon,*_commentIcon,*_sepLine,*_picIcon,*_voiceIcon;
     LWRichTextContentView *contentEmojo;
}


@end
