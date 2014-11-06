//
//  Device.m
//  StudentSalesAppII
//
//  Provides access to device-specific information
//
//  Created by Matt-MAC on 9/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import "Device.h"



@implementation Device

static Device *device = nil;


+(NSObject *)thisDevice
{
    if (device == nil) {
        device = [[super allocWithZone:NULL] init];
    }
    return device;
}



/*
 * Returns the string representation of this devices UUID
 */
+(NSString *)getDeviceIDString
{
    UIDevice *device = [UIDevice currentDevice]; //the current device
    NSUUID *uniqueIdentifier = [device identifierForVendor]; //get the unique identifier object
    NSString *pid = uniqueIdentifier.UUIDString; //get the UUID string
    return pid;
}




@end
