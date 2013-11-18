//
//  MonthAndDayPicker.h
//  WEIMI
//
//  Created by Tang Tianyong on 7/30/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonthAndDayPickerViewController;

@protocol MonthAndDayPickerViewDelegate <NSObject>

@optional

- (void)monthAndDayPickerViewController:(MonthAndDayPickerViewController *)viewController
                       didChangeToMonth:(NSInteger)month
                                 andDay:(NSInteger)day;

@end

@interface MonthAndDayPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, readonly) NSDictionary *monthAndDay;
@property (nonatomic, assign) id<MonthAndDayPickerViewDelegate> delegate;

- (void)setMonth:(NSInteger)month andDay:(NSInteger)day;

@end
