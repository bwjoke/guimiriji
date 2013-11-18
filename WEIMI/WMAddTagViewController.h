//
//  WMAddTagViewController.h
//  WEIMI
//
//  Created by King on 4/9/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMTagButton.h"

@interface WMAddTagViewController : WMTableViewController <UIGestureRecognizerDelegate,UITextViewDelegate,WMTagButtonDelegate>

@property (nonatomic, retain) WMMMan *man;
@property (nonatomic, assign) NKInputView *inputView;

@property (nonatomic, assign) id father;

@end
