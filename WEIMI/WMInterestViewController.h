//
//  WMCharacterViewController.h
//  WEIMI
//
//  Created by Tang Tianyong on 8/22/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMTableViewController.h"
#import "WMPopView.h"

@protocol WMCharacterViewControllerDelegate <NSObject>

@optional
-(void)shouldGetManInfo;

@end


@interface WMInterestViewController : WMTableViewController<WMPopViewDelegate>

@property(nonatomic,strong)WMMMan *man;
@property(nonatomic,unsafe_unretained)id<WMCharacterViewControllerDelegate>delegate;

@end
