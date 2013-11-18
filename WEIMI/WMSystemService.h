//
//  WMSystemService.h
//  WEIMI
//
//  Created by King on 3/7/13.
//  Copyright (c) 2013 ZUO.COM. All rights reserved.
//

#import "WMServiceBase.h"

@interface WMSystemService : WMServiceBase

dshared(WMSystemService);


-(NKRequest*)bindDeviceWithUDID:(NSString*)udid andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)setNoDisturb:(NSString*)switchOption andRequestDelegate:(NKRequestDelegate*)rd;

-(NKRequest*)getQuestionList:(NKRequestDelegate*)rd;

-(NKRequest*)getHotTagList:(NKRequestDelegate*)rd;

-(NKRequest*)getFunction:(NKRequestDelegate*)rd;

-(NKRequest*)getSchoolList:(NKRequestDelegate*)rd;

-(NKRequest*)getMirrorList:(NKRequestDelegate*)rd;

-(void)showSlide;


@end
