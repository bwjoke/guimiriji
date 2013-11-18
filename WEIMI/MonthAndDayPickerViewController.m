//
//  MonthAndDayPicker.m
//  WEIMI
//
//  Created by Tang Tianyong on 7/30/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "MonthAndDayPickerViewController.h"

@interface MonthAndDayPickerViewController ()

@property (nonatomic, strong) NSArray *numDaysOfMonth;

@end

@implementation MonthAndDayPickerViewController

- (void)loadView {
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    self.view = picker;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.numDaysOfMonth = @[@31, @29, @31, @30, @31, @30, @31, @30, @31, @30, @31, @30];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger num = 0;
    
    if (component == 0) {
        num = self.numDaysOfMonth.count;
    } else if (component == 1) {
        num = [self.numDaysOfMonth[[pickerView selectedRowInComponent:0]] integerValue];
    }
    
    return num;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *title = nil;
    
    if (component == 0) {
        title = [NSString stringWithFormat:@"%d月", row + 1];
    } else if (component == 1) {
        title = [NSString stringWithFormat:@"%d日", row + 1];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:24.0f];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView reloadComponent:1];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(monthAndDayPickerViewController:didChangeToMonth:andDay:)]) {
        NSInteger month = [pickerView selectedRowInComponent:0] + 1;
        NSInteger day = [pickerView selectedRowInComponent:1] + 1;
        [self.delegate monthAndDayPickerViewController:self didChangeToMonth:month andDay:day];
    }
}

- (NSDictionary *)monthAndDay {
    UIPickerView *picker = (UIPickerView *)self.view;
    
    NSInteger month = [picker selectedRowInComponent:0];
    NSInteger day = [picker selectedRowInComponent:1];
    
    return @{@"month": @(month + 1), @"day": @(day + 1)};
}

- (void)setMonth:(NSInteger)month andDay:(NSInteger)day {
    UIPickerView *picker = (UIPickerView *)self.view;
    
//    NSAssert(month > 0 && month < 13, @"Invalid month");
    
    if (month < 1 || month > 12) {
        month = 1;
    }
    
    [picker selectRow:month - 1 inComponent:0 animated:NO];
    
    NSInteger numDay = self.numDaysOfMonth[month - 1];
    
//    NSAssert(day > 0 && day <= numDay, @"Invalid day");
    
    if (day < 1 && day > numDay) {
        day = 1;
    }
    
    [picker selectRow:day - 1 inComponent:1 animated:NO];
}

@end
