//
//  ChatList+CoreDataProperties.m
//  CoreData_Obj
//
//  Created by TB-mac-120 on 2019/8/19.
//  Copyright © 2019 TB-mac-120. All rights reserved.
//
//

#import "ChatList+CoreDataProperties.h"

@implementation ChatList (CoreDataProperties)

+ (NSFetchRequest<ChatList *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ChatList"];
}

@dynamic band_url;
@dynamic channel;
@dynamic chat_date;
@dynamic company;
@dynamic company_id;
@dynamic email;
@dynamic is_business;
@dynamic nickname;
@dynamic non_reading;
@dynamic rowId;

@end
