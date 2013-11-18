//
//  WMChatCell.m
//  WEIMI
//
//  Created by steve on 13-9-11.
//  Copyright (c) 2013年 ZUO.COM. All rights reserved.
//

#import "WMChatCell.h"

static NSTimeInterval MaxSecondsGap = 2 * 60.0f;
static CGFloat TimeOffsetHeight = 30.0f;

@implementation WMChatCell {
    BOOL _hasMoveUp;
}

@synthesize avatar;
@synthesize time;
@synthesize content;
@synthesize backPop;
@synthesize picture;

@synthesize sendState;

@synthesize contentEmojo;

@synthesize player;

-(void)dealloc{
    sendState.target = nil;
    picture.target = nil;
    [super dealloc];
}

+ (BOOL)shouldShowTime:(WMMessage *)message allMessages:(NSArray *)messages {
    NSInteger index = [messages indexOfObject:message];
    
    if (index < [messages count] - 1) {
        WMMessage *prevMessage = messages[index + 1];
        if ([[message createAt] timeIntervalSinceDate:[prevMessage createAt]] > MaxSecondsGap) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

+ (CGFloat)cellHeightForObject:(WMMessage *)message allMessages:(NSArray *)messages {
    CGFloat height = 0;
    switch ([message.type integerValue]) {
        case 1:{
            LWVMRichTextContent *postContent = [[[LWVMRichTextContent alloc] initWithContent:[[NSString alloc] initWithData:message.content encoding:NSUTF8StringEncoding]
                                                                                    withType:LWVMRichTextShowContentTypeChat] autorelease];
            
            [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
            
            height = postContent.height;
            break;
        }
        case 2: {
            height = 86;
            break;
        }
        case 3: {
            height = 30;
            break;
        }
        case 4: {
            LWVMRichTextContent *postContent = [[[LWVMRichTextContent alloc] initWithContent:[[NSString alloc] initWithData:message.content encoding:NSUTF8StringEncoding]
                                                                                    withType:LWVMRichTextShowContentTypeChat] autorelease];
            
            [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
            
            height = postContent.height;
            break;
        }
        default:
            break;
    }
    
    CGFloat totalHeight = 39 + 24 + 3 + height;
    
    if (![self shouldShowTime:message allMessages:messages]) {
        totalHeight -= TimeOffsetHeight;
    }
    
    return totalHeight;
}

-(void)showForObject:(WMMessage *)message allMessages:(NSArray *)messages {
    [super showForObject:message];
    
    showedObject = message;
    self.contentEmojo.hidden = YES;
    self.picture.hidden = YES;
    [self.player removeFromSuperview];
    self.player = nil;
    
    [avatar bindValueOfModel:message.sender forKeyPath:@"avatar"];
    time.text = [NKDateUtil intervalSinceNowWithDate:[message createAt]];
    CGFloat contentHeight = 0;
    CGFloat contentWidth = 0;
    switch ([message.type integerValue]) {
        case 1: {
            self.contentEmojo.hidden = NO;
            NSString *messageContentText = [message.contentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            LWVMRichTextContent *postContent = [[[LWVMRichTextContent alloc] initWithContent:messageContentText
                                                                                    withType:LWVMRichTextShowContentTypeChat] autorelease];
            
            [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
            
            CGRect contentFrame = contentEmojo.frame;
            contentFrame.size.height = postContent.height;
            contentEmojo.frame = contentFrame;
            contentEmojo.richTextContent = postContent;
            [contentEmojo setNeedsDisplay];
            contentHeight = postContent.height;
            contentWidth = postContent.width;
            break;
        }
        case 2:{
            self.picture.hidden = NO;
            contentHeight = 100;
            contentWidth = 100;
            break;
        }
        case 3: {
            self.player = [[WMAudioPlayer alloc] initWithURL:[NSURL URLWithString:message.audioUrl] length:[message.audioLength intValue]];
            contentHeight = 30;
            contentWidth = 100;
            break;
        }
        case 4: {
            self.contentEmojo.hidden = NO;
            NSString *messageContentText = [message.contentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            LWVMRichTextContent *postContent = [[[LWVMRichTextContent alloc] initWithContent:messageContentText
                                                                                    withType:LWVMRichTextShowContentTypeChat] autorelease];
            
            [postContent resetNodeFrameWithOriginX:0 withOriginY:0];
            
            CGRect contentFrame = contentEmojo.frame;
            contentFrame.size.height = postContent.height;
            contentEmojo.frame = contentFrame;
            contentEmojo.richTextContent = postContent;
            [contentEmojo setNeedsDisplay];
            contentHeight = postContent.height;
            contentWidth = postContent.width;
            break;
        }
        default:
            break;
    }
    
    
    CGRect avatarFrame = avatar.frame;
    CGRect avatarShadowFrame = avatarShadow.frame;
    
    //[messageContentText sizeWithFont:[UIFont systemFontOfSize:14] forWidth:174 lineBreakMode:NSLineBreakByCharWrapping].width;
    
    if (message.sender.mid == [[WMMUser me] mid]) {
        backPop.hidden = NO;
        backPop.image = [[UIImage imageNamed:@"chat_right_normal.png"] resizeImageWithCapInsets:UIEdgeInsetsMake(35, 30, 8, 30)];
        CGRect frame;
        switch ([message.type integerValue]) {
            case 1:{
                backPop.frame = CGRectMake(200-(contentWidth+28)+63, self.avatar.frame.origin.y, contentWidth+28, 24+contentHeight);
                frame = self.contentEmojo.frame;
                frame.origin.x = backPop.frame.origin.x+12;
                self.contentEmojo.frame = frame;
                
                break;
            }
            case 2:{
                backPop.frame = CGRectMake(200-(contentWidth+28)+70, self.avatar.frame.origin.y, contentWidth+19, 11+contentHeight);
                picture.frame = CGRectMake(200-(contentWidth+28)+77, self.avatar.frame.origin.y+4, contentWidth, contentHeight);
                picture.contentMode = UIViewContentModeScaleAspectFill;
                picture.clipsToBounds = YES;
                picture.layer.cornerRadius = 4.0f;
                picture.target = self;
                picture.renderMethod = @selector(renderPicture:);
                picture.singleTapped = @selector(preView:);
                [picture bindValueOfModel:message forKeyPath:@"image"];
                break;
            }
            case 3: {
                backPop.hidden = YES;
                //backPop.frame = CGRectMake(200-(contentWidth+28)+70, self.avatar.frame.origin.y, contentWidth+19, 11+contentHeight);
                CGRect frame = player.frame;
                frame.origin = CGPointMake(200-(contentWidth+28)+76, self.avatar.frame.origin.y+6);
                player.frame = frame;
                [self.contentView addSubview:player];
                break;
            }
            case 4:{
                backPop.frame = CGRectMake(200-(contentWidth+28)+63, self.avatar.frame.origin.y, contentWidth+28, 24+contentHeight);
                frame = self.contentEmojo.frame;
                frame.origin.x = backPop.frame.origin.x+12;
                self.contentEmojo.frame = frame;
                
                break;
            }
            default:
                break;
        }
        avatarFrame.origin.x = 265;
        frame = self.sendState.frame;
        frame.origin.x = backPop.frame.origin.x-50;
        self.sendState.frame = frame;
        
    }
    
    else{
        
        switch ([message.type integerValue]) {
            case 1: {
                backPop.image = [[UIImage imageNamed:@"chat_left_normal.png"] resizeImageWithCapInsets:UIEdgeInsetsMake(35, 30, 8, 30)];
                backPop.frame = CGRectMake(60, self.avatar.frame.origin.y, contentWidth+28, 24+contentHeight);
                CGRect frame = self.contentEmojo.frame;
                frame.origin.x = backPop.frame.origin.x+16;
                self.contentEmojo.frame = frame;
                avatarFrame.origin.x = 16;
                break;
            }
            case 2:{
                backPop.image = [[UIImage imageNamed:@"chat_left_normal.png"] resizeImageWithCapInsets:UIEdgeInsetsMake(35, 30, 8, 30)];
                backPop.frame = CGRectMake(60, self.avatar.frame.origin.y, contentWidth+19, 11+contentHeight);
                picture.frame = CGRectMake(70, self.avatar.frame.origin.y+4, contentWidth, contentHeight);
                picture.placeHolderImage = [UIImage imageNamed:@"feed_cell_pic_place"];
                picture.contentMode = UIViewContentModeScaleAspectFill;
                picture.clipsToBounds = YES;
                picture.layer.cornerRadius = 4.0f;
                picture.target = self;
                picture.renderMethod = @selector(renderPicture:);
                picture.singleTapped = @selector(preView:);
                [picture bindValueOfModel:message forKeyPath:@"image"];
                avatarFrame.origin.x = 16;
                break;
            }
            case 3: {
                backPop.image = [[UIImage imageNamed:@"chat_left_normal.png"] resizeImageWithCapInsets:UIEdgeInsetsMake(35, 30, 8, 30)];
                backPop.frame = CGRectMake(60, self.avatar.frame.origin.y, contentWidth+19, 11+contentHeight);
                CGRect frame = player.frame;
                frame.origin = CGPointMake(72, self.avatar.frame.origin.y+6);
                player.frame = frame;
                [self.contentView addSubview:player];
                avatarFrame.origin.x = 16;
                break;
            }
            case 4: {
                backPop.image = [[UIImage imageNamed:@"chat_left_normal.png"] resizeImageWithCapInsets:UIEdgeInsetsMake(35, 30, 8, 30)];
                backPop.frame = CGRectMake(60, self.avatar.frame.origin.y, contentWidth+28, 24+contentHeight);
                CGRect frame = self.contentEmojo.frame;
                frame.origin.x = backPop.frame.origin.x+16;
                self.contentEmojo.frame = frame;
                avatarFrame.origin.x = 16;
                break;
            }
            default:
                break;
        }
        
    }
    
    avatar.frame = avatarFrame;
    avatarShadowFrame.origin.x = avatarFrame.origin.x-2;
    avatarShadow.frame = avatarShadowFrame;
    
    [sendState bindValueOfModel:message forKeyPath:@"sendState"];
    
    self.time.hidden = ![[self class] shouldShowTime:message allMessages:messages];
    
    [self moveSubviews];
}

- (void)moveSubviews {
    if (self.time.hidden) {
        if (!_hasMoveUp) {
            _hasMoveUp = YES;
            for (UIView *subview in self.contentView.subviews) {
                CGRect frame = subview.frame;
                frame.origin.y -= TimeOffsetHeight;
                subview.frame = frame;
            }
        }
    } else {
        if (_hasMoveUp) {
            _hasMoveUp = NO;
            for (UIView *subview in self.contentView.subviews) {
                CGRect frame = subview.frame;
                frame.origin.y += TimeOffsetHeight;
                subview.frame = frame;
            }
        }
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [bottomLine removeFromSuperview];
        bottomLine = nil;
        
        CGFloat startY = 5;
        
        self.avatar = [[[NKKVOImageView alloc] initWithFrame:CGRectMake(16, 29+startY, 40, 40)] autorelease];
        self.avatar.layer.cornerRadius = 6.0f;
        [self.contentView addSubview:avatar];
//        avatarShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar40.png"]];
//        avatarShadow.frame = CGRectMake(avatar.frame.origin.x-2, avatar.frame.origin.y-1, 44, 44);
//        [self.contentView addSubview:avatarShadow];

        
        self.time = [[[UILabel alloc] initWithFrame:CGRectMake(0, startY, 320, 20)] autorelease];
        [self.contentView addSubview:time];
        time.textAlignment = UITextAlignmentCenter;
        time.backgroundColor = [UIColor clearColor];
        time.font = [UIFont systemFontOfSize:12];
        time.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
        
        self.backPop = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        [self.contentView addSubview:backPop];
        
        
        self.contentEmojo = [[LWRichTextContentView alloc] initWithFrame:CGRectMake(75, 40+startY, ChatCellchatWidth, 27) withFont:ChatCellchatFont withTextColor:[UIColor colorWithHexString:@"#333333"] withTextShadowColor:nil withTextShadowOffSet:CGSizeZero];
        [self.contentView addSubview:contentEmojo];
        [contentEmojo setBackgroundColor:[UIColor clearColor]];
        
        self.picture = [[NKKVOImageView alloc] initWithFrame:CGRectMake(75, 40+startY, 100, 100)];
        picture.placeHolderImage = [UIImage imageNamed:@"feed_cell_pic_place"];
        [self.contentView insertSubview:picture aboveSubview:backPop];
        
        self.sendState = [[[NKKVOLabel alloc] initWithFrame:CGRectMake(avatar.frame.origin.x, avatar.frame.origin.y, 40, 13)] autorelease];
        sendState.font = [UIFont systemFontOfSize:8];
        sendState.textAlignment = UITextAlignmentRight;
        sendState.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:sendState];
        sendState.target = self;
        sendState.renderMethod = @selector(renderText:);
        
        // Add long press gesture action
        
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)longPressHandler:(UILongPressGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    
    touchPoint = [backPop convertPoint:touchPoint fromView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (CGRectContainsPoint(backPop.bounds, touchPoint)) {
            if ([self.delegate respondsToSelector:@selector(messageDidLongPress:)]) {
                [self.delegate messageDidLongPress:self];
            }
        }
    }
}

-(NSString*)renderText:(NSString*)text{
    
    sendState.hidden = text?NO:YES;
    
    return text;
}

-(UIImage*)renderPicture:(UIImage*)image{
    
    UIImage *imageToRender = image?image:picture.placeHolderImage;
    
    // ZUOMAttachment *feedAtt = [self.showdFeed.attachments lastObject];
    WMMessage *message = showedObject;
    if ([[message type] isEqualToString:@"2"]) {
        if ([message.sender.mid isEqualToString:[[WMMUser me] mid]]) {
            CGRect pictureFrame = picture.frame;
            pictureFrame.size.width = MIN(imageToRender.size.width/imageToRender.size.height*pictureFrame.size.height, imageToRender==picture.placeHolderImage?110:100);
            pictureFrame.size.height = 100;
            pictureFrame.origin.x = 200-(pictureFrame.size.width+28)+76;
            picture.frame = pictureFrame;
            CGRect frame = backPop.frame;
            frame.size.height = 110;
            frame.size.width = picture.frame.size.width + 17;
            frame.origin.x = 200-(picture.frame.size.width+28)+70;
            backPop.frame = frame;
        }else {
            CGRect pictureFrame = picture.frame;
            pictureFrame.size.width = MIN(imageToRender.size.width/imageToRender.size.height*pictureFrame.size.height, imageToRender==picture.placeHolderImage?110:100);
            pictureFrame.size.height = 100;
            
            picture.frame = pictureFrame;
            CGRect frame = backPop.frame;
            frame.size.height = 110;
            frame.size.width = picture.frame.size.width + 15;
            backPop.frame = frame;
        }
    }
    
    
    return imageToRender;
}

-(void)preView:(id)sender{
    
    NKPictureViewer *viewer = [NKPictureViewer pictureViewerForView:picture];
    [viewer showPictureForObject:showedObject andKeyPath:@"image"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
