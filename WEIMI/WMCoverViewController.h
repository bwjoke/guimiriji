//
//  WMCoverViewController.h
//  WEIMI
//
//  Created by steve on 13-6-28.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMCoverViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    NSMutableArray *viewControllers;
    int kNumberOfPages;
    int currentPage;
    CGFloat position;
    UIPageControl *pageControl;
}
@property(nonatomic,assign)NSArray *dataSource;
@property(nonatomic)int kNumberOfPages;
@property(nonatomic)int currentPage;
//@property(nonatomic,assign)UIScrollView *scrollView;
//@property(nonatomic,assign)NSMutableArray *viewControllers;

-(void)reloadAllData;
-(void)scrolTo:(int)page;
@end
