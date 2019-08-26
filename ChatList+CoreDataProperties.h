//
//  ChatList+CoreDataProperties.h
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/19.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//
//

#import "ChatList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChatList (CoreDataProperties)

+ (NSFetchRequest<ChatList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *band_url;
@property (nullable, nonatomic, copy) NSString *channel;
@property (nullable, nonatomic, copy) NSDate *chat_date;
@property (nullable, nonatomic, copy) NSString *company;
@property (nullable, nonatomic, copy) NSString *company_id;
@property (nullable, nonatomic, copy) NSString *email;
@property (nonatomic) int64_t is_business;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nonatomic) int64_t non_reading;
@property (nonatomic) int64_t rowId;

@end

NS_ASSUME_NONNULL_END
