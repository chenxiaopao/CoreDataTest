//
//  TBShareDevice.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/14.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBShareDevice : NSObject

@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *mail;

+ (instancetype)deviceWithChannel:(NSString *)channel avatarUrl:(NSString *)avatarUrl companyName:(NSString *)companyName nickName:(NSString *)nickName mail:(NSString *)mail;

@end

NS_ASSUME_NONNULL_END
