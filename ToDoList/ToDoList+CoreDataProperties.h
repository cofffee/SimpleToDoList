//
//  ToDoList+CoreDataProperties.h
//  ToDoList
//
//  Created by Kevin Remigio on 5/13/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoList.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDoList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSDate *date;

@end

NS_ASSUME_NONNULL_END
