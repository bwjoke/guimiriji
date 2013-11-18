//
//  WMCreateTagViewController.m
//  WEIMI
//
//  Created by King on 4/18/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMCreateTagViewController.h"
#import "WMCreateManViewController.h"

@interface WMCreateTagViewController ()

@end

@implementation WMCreateTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)goBack:(id)sender{
    
    [self.father setUIForData];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = @"特点标签";

}

-(void)addTag:(NSString*)content{
    
    if (self.dataSource.count >= 5) {
        ProgressFailedWith(@"最多只能添加5个标签");
        return;
    }
    
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (content.length > 14) {
        ProgressFailedWith(@"标签不能大于14个字");
        return;
    }
    
    
    for (WMMTag *tag in self.dataSource) {
        if ([tag.name isEqualToString:content]) {
            ProgressFailedWith(@"不能插入重复标签");
            return;
        }
    }
    
    [self.dataSource insertObject:[WMMTag modelFromDic:@{@"name":content, @"support_count":@1, @"supported":@1}] atIndex:0];
    [showTableView reloadData];
    [self setPullBackFrame];

    [self.inputView.textView setText:@""];
    [self.inputView.textView resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [showTableView reloadData];
    [self.inputView hide];
    
    
}


@end
