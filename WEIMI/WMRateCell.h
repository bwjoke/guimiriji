//
//  WMRateCell.h
//  WEIMI
//
//  Created by King on 11/21/12.
//  Copyright (c) 2012 ZUO.COM. All rights reserved.
//
@protocol WMRateCellDelegate <NSObject>

@optional
-(void)reloadTotalScore;
-(void)deleteDataSourceItem:(int)index;

@end

#import "NKTableViewCell.h"
#import "TVCalibratedSlider.h"

@interface WMRateCell : NKTableViewCell <TVCalibratedSliderDelegate,UIAlertViewDelegate>
{
    TVCalibratedSlider *_programmaticallyCreatedSlider;
}
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, assign) UILabel *nameLabel;
@property (nonatomic, assign) UIButton *deleteButton;
@property (nonatomic)int index;
@property (nonatomic, assign) id<WMRateCellDelegate>delegate;

@end
