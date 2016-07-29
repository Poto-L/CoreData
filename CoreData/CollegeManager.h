//
//  CollegeManager.h
//  CoreData
//
//  Created by WS on 16/7/26.
//  Copyright © 2016年 WS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@class Course;
@interface CollegeManager : NSObject

+ (CollegeManager *)shareManager;

- (void)save;

- (void)deleteEntity:(NSManagedObject *)obj;

- (void)initlizeData;

- (void)fetchTest;

- (void)fetchMyClasses;

- (BOOL)insertCourses:(NSArray *)courses;

- (BOOL)deleteCourses:(NSArray *)courses;

- (BOOL)updateCourse;

- (NSFetchedResultsController *)allCourses;

- (BOOL)cleanAllCourses;

@end
