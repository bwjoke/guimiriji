//
//  WMIMInputView.h
//  WEIMI
//
//  Created by Tang Tianyong on 10/25/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//
@protocol WMIMInputViewDelegate <NSObject>

@optional
-(void)showImageSheet;

@end

#import "NKInputView.h"

@interface WMIMInputView : NKInputView

@property(nonatomic,unsafe_unretained)id<WMIMInputViewDelegate>delegate;
@property (nonatomic, assign) SEL recordSendAction;

@end
