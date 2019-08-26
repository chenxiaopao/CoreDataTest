//
//  TBShareDevice.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/14.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import "TBShareDevice.h"

@implementation TBShareDevice


+ (instancetype)deviceWithChannel:(NSString *)channel avatarUrl:(NSString *)avatarUrl companyName:(NSString *)companyName nickName:(NSString *)nickName mail:(NSString *)mail{
    TBShareDevice *device = [[TBShareDevice alloc]init];
    device.channelId = channel;
    device.avatarUrl = avatarUrl;
    device.companyName = companyName;
    device.nickname = nickName;
    device.mail = mail;
    return device;
}
@end
