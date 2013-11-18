//
//  WMFeedCell2.h
//  WEIMI
//
//  Created by King on 11/20/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

@protocol WMFeedCell2Delegate <NSObject>

@optional
-(void)createFeed;

@end

#import "NKTableViewCell.h"
#import "WMDataService.h"

#import "LWRichTextContentView.h"

@interface WMFeedCell2 : NKTableViewCell{
    
}

@property (nonatomic, unsafe_unretained) UIImageView    *pictureBack;
@property (nonatomic, unsafe_unretained) NKKVOImageView *picture;

@property (nonatomic, unsafe_unretained) UILabel *day;
@property (nonatomic, unsafe_unretained) UILabel *month;
@property (nonatomic, unsafe_unretained) UILabel *time;


@property (nonatomic, unsafe_unretained) UIButton *createButton;


@property (nonatomic, unsafe_unretained) LWRichTextContentView  *content;

@property (nonatomic, unsafe_unretained) UIButton *commentButton;
@property (nonatomic, strong) UILabel  *commentCount;

@property (nonatomic, unsafe_unretained) UIView   *commentContainer;

@property (nonatomic, unsafe_unretained) UIView *scoreView;

@property (nonatomic, unsafe_unretained) UIImageView *contentSep;

@property (nonatomic,unsafe_unretained)id<WMFeedCell2Delegate>delegate;

@property (nonatomic, unsafe_unretained) UIImageView *feedback;


-(void)showDate:(BOOL)shoulShowDay dateFormatter:(NSDateFormatter*)dateFormatter;

-(void)showForIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource;

@end
