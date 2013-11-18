//
//  HTAutocompleteManager.m
//  HotelTonight
//
//  Created by Jonathan Sibley on 12/6/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "WMAutocompleteManager.h"

static WMAutocompleteManager *sharedManager;

@interface WMAutocompleteManager ()

@property (nonatomic, retain) NSArray *autocompleteArray;

@end

@implementation WMAutocompleteManager

- (void)dealloc {
    self.autocompleteArray = nil;
    
    [super dealloc];
}

+ (WMAutocompleteManager *)sharedManager
{
	static dispatch_once_t done;
	dispatch_once(&done, ^{ sharedManager = [[WMAutocompleteManager alloc] init]; });
	return sharedManager;
}

- (id)init {
    if ((self = [super init]) != nil) {
        self.autocompleteArray = @[
           @"163.com",
           @"sina.cn",
           @"qq.com",
           @"126.com",
           @"gmail.com",
           @"hotmail.com",
           @"sohu.com",
           @"139.com",
           @"wo.com.cn",
           @"189.cn",
           @"21cn.com",
           @"msn.com",
           @"263.com",
           @"yeah.net",
           @"mail.com",
           @"yahoo.com.cn",
           @"eyou.com",
           @"56.com",
           @"chinaren.com",
           @"sogou.com",
           @"citiz.com",
           @"tom.com",
           @"outlook.com",
           @"foxmail.com",
           
           @"yahoo.com",
           @"aol.com",
           @"comcast.net",
           @"me.com",
           @"live.com",
           @"sbcglobal.net",
           @"ymail.com",
           @"att.net",
           @"mac.com",
           @"cox.net",
           @"verizon.net",
           @"hotmail.co.uk",
           @"bellsouth.net",
           @"rocketmail.com",
           @"aim.com",
           @"yahoo.co.uk",
           @"earthlink.net",
           @"charter.net",
           @"optonline.net",
           @"shaw.ca",
           @"yahoo.ca",
           @"googlemail.com",
           @"mail.com",
           @"btinternet.com",
           @"mail.ru",
           @"live.co.uk",
           @"naver.com",
           @"rogers.com",
           @"juno.com",
           @"yahoo.com.tw",
           @"live.ca",
           @"walla.com",
           @"roadrunner.com",
           @"telus.net",
           @"embarqmail.com",
           @"hotmail.fr",
           @"pacbell.net",
           @"sky.com",
           @"sympatico.ca",
           @"cfl.rr.com",
           @"tampabay.rr.com",
           @"q.com",
           @"yahoo.co.in",
           @"yahoo.fr",
           @"hotmail.ca",
           @"windstream.net",
           @"hotmail.it",
           @"asu.edu",
           @"gmx.de",
           @"gmx.com",
           @"insightbb.com",
           @"netscape.net",
           @"icloud.com",
           @"frontier.com",
           @"hanmail.net",
           @"suddenlink.net",
           @"netzero.net",
           @"mindspring.com",
           @"ail.com",
           @"windowslive.com",
           @"netzero.com",
           @"yahoo.com.hk",
           @"yandex.ru",
           @"mchsi.com",
           @"cableone.net",
           @"yahoo.es",
           @"yahoo.com.br",
           @"cornell.edu",
           @"ucla.edu",
           @"us.army.mil",
           @"excite.com",
           @"ntlworld.com",
           @"usc.edu",
           @"nate.com",
           @"nc.rr.com",
           @"prodigy.net",
           @"videotron.ca",
           @"yahoo.it",
           @"yahoo.com.au",
           @"umich.edu",
           @"ameritech.net",
           @"libero.it",
           @"yahoo.de",
           @"rochester.rr.com",
           @"cs.com",
           @"frontiernet.net",
           @"swbell.net",
           @"msu.edu",
           @"ptd.net",
           @"proxymail.facebook.com",
           @"hotmail.es",
           @"austin.rr.com",
           @"nyu.edu",
           @"centurytel.net",
           @"usa.net",
           @"nycap.rr.com",
           @"uci.edu",
           @"hotmail.de",
           @"yahoo.com.sg",
           @"email.arizona.edu",
           @"yahoo.com.mx",
           @"ufl.edu",
           @"bigpond.com",
           @"unlv.nevada.edu",
           @"yahoo.cn",
           @"ca.rr.com",
           @"google.com",
           @"yahoo.co.id",
           @"inbox.com",
           @"fuse.net",
           @"hawaii.rr.com",
           @"talktalk.net",
           @"gmx.net",
           @"walla.co.il",
           @"ucdavis.edu",
           @"carolina.rr.com",
           @"comcast.com",
           @"live.fr",
           @"blueyonder.co.uk",
           @"live.cn",
           @"cogeco.ca",
           @"abv.bg",
           @"tds.net",
           @"centurylink.net",
           @"yahoo.com.vn",
           @"uol.com.br",
           @"osu.edu",
           @"san.rr.com",
           @"rcn.com",
           @"umn.edu",
           @"live.nl",
           @"live.com.au",
           @"tx.rr.com",
           @"eircom.net",
           @"sasktel.net",
           @"post.harvard.edu",
           @"snet.net",
           @"wowway.com",
           @"live.it",
           @"hoteltonight.com",
           @"att.com",
           @"vt.edu",
           @"rambler.ru",
           @"temple.edu",
           @"cinci.rr.com"
        ];
    }
    
    return self;
}

#pragma mark - HTAutocompleteTextFieldDelegate

- (NSString *)textField:(WMAutocompleteTextField *)textField
    completionForPrefix:(NSString *)prefix
             ignoreCase:(BOOL)ignoreCase
{
    if (textField.autocompleteType == WMAutocompleteTypeEmail)
    {
        // Check that text field contains an @
        NSRange atSignRange = [prefix rangeOfString:@"@"];
        if (atSignRange.location == NSNotFound)
        {
            return @"";
        }

        // Stop autocomplete if user types dot after domain
        NSString *domainAndTLD = [prefix substringFromIndex:atSignRange.location];
        NSRange rangeOfDot = [domainAndTLD rangeOfString:@"."];
        if (rangeOfDot.location != NSNotFound)
        {
            return @"";
        }

        // Check that there aren't two @-signs
        NSArray *textComponents = [prefix componentsSeparatedByString:@"@"];
        if ([textComponents count] > 2)
        {
            return @"";
        }

        if ([textComponents count] > 1)
        {
            // If no domain is entered, use the first domain in the list
            if ([(NSString *)textComponents[1] length] == 0)
            {
                //NSLog(@"***********: %@",self.autocompleteArray);
                //return [autocompleteArray objectAtIndex:0];
            }

            NSString *textAfterAtSign = textComponents[1];

            NSString *stringToLookFor;
            if (ignoreCase)
            {
                stringToLookFor = [textAfterAtSign lowercaseString];
            }
            else
            {
                stringToLookFor = textAfterAtSign;
            }

            for (NSString *stringFromReference in self.autocompleteArray)
            {
                NSString *stringToCompare;
                if (ignoreCase)
                {
                    stringToCompare = [stringFromReference lowercaseString];
                }
                else
                {
                    stringToCompare = stringFromReference;
                }

                if ([stringToCompare hasPrefix:stringToLookFor])
                {
                    return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
                }

            }
        }
    }
    

    return @"";
}

@end
