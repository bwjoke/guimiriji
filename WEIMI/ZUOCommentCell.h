//
//  ZUOCommentCell.h
//  ZUO
//
//  Created by King on 9/28/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKKit.h"
#import "NKSDK.h"
#import "LWRichTextContentView.h"

#define CommentCellcontentFont [UIFont boldSystemFontOfSize:12]
#define CommentCellcontentWidth 248

@interface ZUOCommentCell : NKTableViewCell{
    
    NKKVOImageView *avatar;
    
    UILabel        *name;
    UILabel        *time;
    UILabel        *content;
    
    LWRichTextContentView *contentEmojo;
    
    CGFloat cellHeight;
}

@property (nonatomic, assign) NKKVOImageView *avatar;

@property (nonatomic, assign) UILabel        *name;
@property (nonatomic, assign) UILabel        *time;
@property (nonatomic, assign) UILabel        *content;

@property (nonatomic, assign) LWRichTextContentView *contentEmojo;


@end
