//
//  CoreDataStack.h
//  ToDoList
//
//  Created by Kevin Remigio on 5/13/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ToDoList.h"

@interface CoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(CoreDataStack*) coreDataStack;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(NSArray*)getAllItems;
-(void)addItem:(NSString*)item;
-(void)updateItemTo:(NSString*)newName forItem:(ToDoList*)item;

@end
