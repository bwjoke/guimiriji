//
//  WMFeedCell.h
//  WEIMI
//
//  Created by King on 11/20/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//

@protocol WMFeedCellDelegate <NSObject>

@optional
-(void)createFeed;

@end

#import "NKTableViewCell.h"
#import "WMDataService.h"

#import "LWRichTextContentView.h"

@interface WMFeedCell : NKTableViewCell{
    
}

@property (nonatomic, assign) UIImageView    *pictureBack;
@property (nonatomic, assign) NKKVOImageView *picture;

@property (nonatomic, assign) UILabel *day;
@property (nonatomic, assign) UILabel *month;
@property (nonatomic, assign) UILabel *time;


@property (nonatomic, assign) UIButton *createButton;


@property (nonatomic, assign) UILabel  *content;

@property (nonatomic, assign) UIButton *commentButton;
@property (nonatomic, retain) UILabel  *commentCount;

@property (nonatomic, assign) UIView   *commentContainer;

@property (nonatomic, assign) UIView *scoreView;

@property (nonatomic, assign) UIImageView *contentSep;

@property (nonatomic,assign)id<WMFeedCellDelegate>delegate;

@property (nonatomic, assign) UIImageView *feedback;


-(void)showDate:(BOOL)shoulShowDay dateFormatter:(NSDateFormatter*)dateFormatter;

+(CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource;

-(void)showForIndexPath:(NSIndexPath *)indexPath dataSource:(NSArray *)dataSource;

@end
