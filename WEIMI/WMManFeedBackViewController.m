// WMManFeedBackViewController.m
//
// Copyright (c) 2013 Tang Tianyong
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
// KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
// AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

#import "WMManFeedBackViewController.h"

@interface WMManFeedBackViewController ()

@end

@implementation WMManFeedBackViewController {
    UIImage *_oldAvatar;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _oldAvatar = self.man.avatar ? self.man.avatar : self.man.avatarBig;
    
    [self.nkRightButton removeFromSuperview];
    self.nkRightButton = nil;
    
    [self addRightButtonWithTitle:@"完成"];
}

-(void)addOtherInfor{
    [super addOtherInfor];
    
    [self.tags removeFromSuperview];
    self.tags = nil;
    
    CGFloat offsetY = 160.0f;
    
    CGRect frame = self.birthday.frame;
    frame.origin.y = offsetY + 51;
    
    self.birthday.frame = frame;
    
    frame.origin.y = offsetY + 51 + 51;
    
    self.school.frame = frame;
}

- (void)layoutSubViews {
    // Empty
}

- (void)rightButtonClick:(id)sender {
    // Avatar
    UIImage *avatar = self.man.avatar ? self.man.avatar : self.man.avatarBig;
    
    if (!avatar) {
        ProgressFailedWith(@"请设置他的头像");
        return;
    }
    
    if (!self.isManAvatarChanged) {
        avatar = nil;
    }
    
    // Name
    NSString *name = self.name.text;
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!name || name.length < 1) {
        ProgressFailedWith(@"请设置他的姓名");
        return;
    }
    
    // Weibo name
    NSString *weibo_name = self.weiboName.text;
    weibo_name = [weibo_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!weibo_name || weibo_name.length < 1) {
        ProgressFailedWith(@"请设置他的昵称");
        return;
    }
    
    
    
    // Birthday
    NSString *birthday = nil;
    NSDictionary *birth = [self validManBirth];
    
    if (birth) {
        birthday = [NSString stringWithFormat:@"%d-%d", [birth[@"month"] integerValue], [birth[@"day"] integerValue]];
    }
    
    // University
    NSString *univ_name = nil;
    
    if (self.man.university) {
        NSDictionary *university = self.man.university;
        if (university[@"name"] != nil) {
            univ_name = university[@"name"];
        }
    }
    
    progressView = [NKProgressView progressViewForView:self.view];
    progressView.labelText = @"正在载入";
    
    self.nkRightButton.enabled = NO;
    
    NKRequestDelegate *rd = [NKRequestDelegate requestDelegateWithTarget:self finishSelector:@selector(postOK:) andFailedSelector:@selector(postFailed:)];
    
    [[WMManService sharedWMManService] feedbackManWithID:self.man.mid
                                                    name:name
                                              weibo_name:weibo_name
                                                birthday:birthday
                                                  avatar:UIImageJPEGRepresentation(avatar, 0.5)
                                               univ_name:univ_name
                                      andRequestDelegate:rd];
}

-(void)postOK:(NKRequest*)request{
    ProgressHide;
    if (self.feedbackSuccessHandler) {
        self.feedbackSuccessHandler();
    }
    [NKNC popViewControllerAnimated:YES];
}

-(void)postFailed:(NKRequest*)request{
    //ProgressErrorDefault;
    UIAlertView *faildAlert = [[UIAlertView alloc] initWithTitle:nil message:request.errorDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [faildAlert show];
    self.nkRightButton.enabled = YES;
}

- (NSDictionary *)validManBirth {
    NSDictionary *birth = self.man.birth;
    
    if (birth && birth[@"month"] && birth[@"day"]) {
        if (![birth[@"month"] isKindOfClass:[NSNull class]] && ![birth[@"day"] isKindOfClass:[NSNull class]]) {
            return birth;
        }
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
