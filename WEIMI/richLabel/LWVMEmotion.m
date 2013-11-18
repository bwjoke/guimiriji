//
//  LWVMEmotion.m
//  Laiwang
//
//  Created by Levy's on 12-11-29.
//  Copyright (c) 2012年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#import "LWVMEmotion.h"

#define kVMEmotionDesKey @"vmEmotionDes"
#define kVMEmotionNameKey @"vmEmotionName"

@implementation LWVMEmotion
@synthesize description = _description;
@synthesize filename = _filename;

- (void)dealloc
{
    [_description release];
    [_filename release];
    
    [super dealloc];
}

- (id)initWithDescription:(NSString *)description filename:(NSString *)filename
{
	if (self = [super init]) {
        self.description = description;
        self.filename = filename;
	}
	return self;
}

#pragma mark -
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_description forKey:kVMEmotionDesKey];
    [encoder encodeObject:_filename forKey:kVMEmotionNameKey];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.description = [decoder decodeObjectForKey:kVMEmotionDesKey];
        self.filename = [decoder decodeObjectForKey:kVMEmotionNameKey];
    }
    
    return self;
}

#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    LWVMEmotion *copy = [[[self class] allocWithZone:zone] init];
    copy.description = [[self.description copyWithZone:zone] autorelease];
    copy.filename = [[self.filename copyWithZone:zone] autorelease];
    
    return copy;
}


@end
