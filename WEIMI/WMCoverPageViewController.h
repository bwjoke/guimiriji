//
//  WMCoverPageViewController.h
//  WEIMI
//
//  Created by steve on 13-6-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKKVOImageView.h"

@interface WMCoverPageViewController : UIViewController
{
    int pageNumber;
    UIPageControl *pageControl;
}
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong) NKKVOImageView *photoView;
@property(nonatomic,strong)UIImageView *lastPageView;
@property(nonatomic)BOOL isLast;

- (id)initWithPageNumber:(int)page;

@end
