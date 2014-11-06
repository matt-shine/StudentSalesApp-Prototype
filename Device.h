//
//  Device.h
//  StudentSalesAppII
//
//  Created by Matt-MAC on 9/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

/*
 * Enables easier access to device-specific information (UUID's etc)
 *
 * This is a singleton - only one instance will exist, access via the thisDevice method
 * To access use: [[Device thisDevice] <Method name>];
 */


#import <Foundation/Foundation.h>

@interface Device : NSObject

+(NSObject *)thisDevice; //class method to return the singleton object

+(NSString *)getDeviceIDString;

@end
