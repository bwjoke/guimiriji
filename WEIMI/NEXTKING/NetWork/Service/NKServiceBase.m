//
//  NKServiceBase.m
//  NEXTKING
//
//  Created by King on 10/24/12.
//  Copyright (c) 2012 NK.COM. All rights reserved.
//

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#ifdef __IPHONE_6_0
#import <AdSupport/AdSupport.h>
#endif

#import "NKServiceBase.h"
#import "NKSDK.h"
#import <commoncrypto/CommonDigest.h>
#import "NKConfig.h"

#import "MCSMKeychainItem.h"

@implementation NKServiceBase


@synthesize serviceName;

-(void)dealloc{
    
    [serviceName release];
    [super dealloc];
    
}

+(NSString *)macaddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

-(NSString*)makeMD5:(NSString*)str{
    
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}


-(void)addRequest:(NKRequest*)request{
    
    if ([[NKConfig sharedConfig] needLocation]) {
        
        CLLocation *location = [[NKLocationService sharedNKLocationService] currentLocation];
        if (location) {
            [request addRequestHeader:@"nklatitude" value:[NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:location.coordinate.latitude]]];
            [request addRequestHeader:@"nklongitude" value:[NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:location.coordinate.longitude]]];
        }
    }
    
    [request addRequestHeader:@"device" value:@"ios"];
    [request addRequestHeader:@"version" value:[NSString stringWithFormat:@"iPhone %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    
    // Note: Use MCSMKeychainItem replace MAC
    // More infomation at https://github.com/ObjColumnist/MCSMKeychainItem
    
    NSString *UUID = [MCSMApplicationUUIDKeychainItem applicationUUID];
    
    [request addRequestHeader:@"nkmac" value:UUID];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        [request addRequestHeader:@"IDFA" value:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
    }
    [[NKSDK sharedSDK] addRequest:request];
    
#ifdef DEBUG
    NSLog(@"%@, %@, %@", request.url, [request requestCookies], [request requestHeaders]);
#endif
    // Start
    [request.requestDelegate delegateStartWithRequest:request];
}


-(NSString *)serviceBaseURL{
    if (self.serviceName) {
        return [[[NKConfig sharedConfig] domainURL] stringByAppendingFormat:@"/%@",self.serviceName];
    }
    return [[NKConfig sharedConfig] domainURL];
    
}
@end
