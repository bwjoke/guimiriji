//
//  LWVMEmotion.h
//  Laiwang
//
//  Created by Levy's on 12-11-29.
//  Copyright (c) 2012年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// 来往表情的model
@interface LWVMEmotion : NSObject
{
    NSString *_description; // 表情的描述
    NSString *_filename;    // 表情的名称
}
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *filename;

- (id)initWithDescription:(NSString *)description filename:(NSString *)filename;

@end
