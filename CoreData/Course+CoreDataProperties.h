//
//  Course+CoreDataProperties.h
//  CoreData
//
//  Created by WS on 16/7/26.
//  Copyright © 2016年 WS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSManagedObject *teacher;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *students;

@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(NSManagedObject *)value;
- (void)removeStudentsObject:(NSManagedObject *)value;
- (void)addStudents:(NSSet<NSManagedObject *> *)values;
- (void)removeStudents:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
