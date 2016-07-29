//
//  CollegeManager.m
//  CoreData
//
//  Created by WS on 16/7/26.
//  Copyright © 2016年 WS. All rights reserved.
//

#import "CollegeManager.h"
#import "MyClass.h"
#import "Course.h"
#import "Student.h"
#import "Teacher.h"

static CollegeManager * _sharedManager = nil;

@implementation CollegeManager{
    AppDelegate * appDelegate;
    NSManagedObjectContext * appContext;
}

+ (CollegeManager *)shareManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedManager = [CollegeManager new];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        appDelegate = [UIApplication sharedApplication].delegate;
        appContext = appDelegate.managedObjectContext;
    }
    return self;
}

- (void)save {
    [appDelegate saveContext];
}

- (void)deleteEntity:(NSManagedObject *)obj {
    [appContext deleteObject:obj];
    [self save];
}

#pragma mark - MMM
- (void)initlizeData {
    NSMutableArray * arr_myclasses = [NSMutableArray new];
    NSArray * arr_myclasses_name = @[@"99级1班", @"99级2班", @"99级3班"];
    for (NSString * class_name in arr_myclasses_name) {
        MyClass * new_myclass = [NSEntityDescription insertNewObjectForEntityForName:@"MyClass" inManagedObjectContext:appContext];
        new_myclass.name = class_name;
        [arr_myclasses addObject:new_myclass];
    }
    
    NSMutableArray * arr_students = [NSMutableArray new];
    NSArray * arr_students_info = @[@{@"name": @"李斌", @"age": @(20)},
                                    @{@"name": @"李鹏", @"age": @(19)},
                                    @{@"name": @"朱文", @"age": @(21)},
                                    @{@"name": @"李强", @"age": @(21)},
                                    @{@"name": @"高崇", @"age": @(18)},
                                    @{@"name": @"薛大", @"age": @(19)},
                                    @{@"name": @"裘千仞", @"age": @(21)},
                                    @{@"name": @"王波", @"age": @(18)},
                                    @{@"name": @"王鹏", @"age": @(19)}];
    for (id info in arr_students_info) {
        NSString * name = [info objectForKey:@"name"];
        NSNumber * age = [info objectForKey:@"age"];
        
        Student * student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:appContext];
        student.name = name;
        student.age = age;
        [arr_students addObject:student];
    }
    
    
    NSMutableArray * arr_teachers = [NSMutableArray new];
    NSArray * arr_teachers_name = @[@"王刚",@"谢力",@"徐开义",@"许宏权"];
    for (NSString * name in arr_teachers_name) {
        Teacher * teacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:appContext];
        teacher.name = name;
        [arr_teachers addObject:teacher];
    }
    
    
    NSMutableArray * arr_courses = [NSMutableArray new];
    NSArray * arr_courses_name = @[@"CAD",@"软件工程",@"线性代数",@"微积分",@"大学物理"];
    for (NSString * name in arr_courses_name) {
        Course * course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:appContext];
        course.name = name;
        [arr_courses addObject:course];
    }
    
    MyClass * class_one = [arr_myclasses objectAtIndex:0];
    [class_one addStudentsObject:[arr_students objectAtIndex:0]];
    [class_one addStudentsObject:arr_students[1]];
    [arr_students[2] setMyclass:class_one];
    
    MyClass * class_two = arr_myclasses[1];
    [class_two addStudents:[NSSet setWithArray:[arr_students subarrayWithRange:NSMakeRange(3, 3)]]];
    
    MyClass * class_three = arr_myclasses[2];
    [class_three setStudents:[NSSet setWithArray:[arr_students subarrayWithRange:NSMakeRange(6, 3)]]];
    
    Teacher * wanggang = arr_teachers[0];
    Teacher * xieli = arr_teachers[1];
    Teacher * xukaiyi = arr_teachers[2];
    Teacher * xuhongquan = arr_teachers[3];
    
    [class_one setTeacher:wanggang];
    class_two.teacher = xieli;
    [xukaiyi setMyclass:class_three];
    
    
    Course * cad = arr_courses[0];
    Course * software = arr_courses[1];
    Course * linear = arr_courses[2];
    Course * calculus = arr_courses[3];
    Course * physics = arr_courses[4];
    [wanggang setCourses:[NSSet setWithObjects:cad, software, nil]];
    [linear setTeacher:xieli];
    [calculus setTeacher:xuhongquan];
    [physics setTeacher:xukaiyi];
    
    
    [arr_students[0] setCourses:[NSSet setWithObjects:cad, software, nil]];
    [arr_students[1] setCourses:[NSSet setWithObjects:cad, linear, nil]];
    [arr_students[2] setCourses:[NSSet setWithObjects:linear, physics, nil]];
    [arr_students[3] setCourses:[NSSet setWithObjects:linear, physics, nil]];
    [arr_students[4] setCourses:[NSSet setWithObjects:calculus, physics, nil]];
    [arr_students[5] setCourses:[NSSet setWithObjects:software, linear, nil]];
    [arr_students[6] setCourses:[NSSet setWithObjects:software, physics, nil]];
    [arr_students[7] setCourses:[NSSet setWithObjects:linear, software, nil]];
    [arr_students[8] setCourses:[NSSet setWithObjects:calculus, software, linear, nil]];
    
    NSError * error;
    [appContext save:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

- (void)fetchTest {
    NSEntityDescription * entity_des = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:appContext];
    NSFetchRequest * request = [NSFetchRequest new];
    [request setEntity:entity_des];
    
    NSSortDescriptor * sorting = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    [request setSortDescriptors:@[sorting]];
    
    NSPredicate * filter = [NSPredicate predicateWithFormat:@"SUBQUERY(courses, $course, $course.name == '大学物理').@count > 0"];
    [request setPredicate:filter];
    
//    [request setFetchOffset:3];
//    [request setFetchLimit:3];
    
    NSError * error = nil;
    NSArray * arr_students = [appContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", error);
    } else {
        for (Student * stu in arr_students) {
            NSLog(@"%@ (%@岁)", stu.name, stu.age);
        }
    }
}

- (void)fetchMyClasses {
    NSEntityDescription * entity_des = [NSEntityDescription entityForName:@"MyClass" inManagedObjectContext:appContext];
    NSFetchRequest * request = [NSFetchRequest new];
    request.entity = entity_des;
    
    [request setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"students", nil]];
    
    NSError * error = nil;
    NSArray * arr_myclasses = [appContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", error);
    } else {
        for (MyClass * myclass in arr_myclasses) {
            NSLog(@"%@", myclass.name);
            for (Student * stu in myclass.students) {
                NSLog(@"     %@", stu.name);
            }
        }
    }
}

- (void)updateTest {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    
    NSPredicate * filter = [NSPredicate predicateWithFormat:@"name = '许宏权'"];
    [request setPredicate:filter];
    
    NSError * error = nil;
    NSArray * arr_result = [appContext executeFetchRequest:request error:&error];
    Teacher * xuhongquan = arr_result[0];
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    filter = [NSPredicate predicateWithFormat:@"name = [cd]'cad'"];
    request.predicate = filter;
    
    arr_result = [appContext executeFetchRequest:request error:&error];
    
    Course * cad = arr_result[0];
    
    cad.name = @"CAD设计";
    cad.teacher = xuhongquan;
    
    [self save];
}

- (void)deleteTest {
    NSFetchRequest * requset = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    NSPredicate * filter = [NSPredicate predicateWithFormat:@"name = '王波'"];
    requset.predicate = filter;
    
    NSError * error = nil;
    NSArray * arr_result = [appContext executeFetchRequest:requset error:&error];
    
    if (arr_result.count) {
        Student * wangbo = arr_result[0];
        [self deleteEntity:wangbo];
        [self save];
    }

    requset = [NSFetchRequest fetchRequestWithEntityName:@"MyClass"];
    filter = [NSPredicate predicateWithFormat:@"name = '99级2班'"];
    requset.predicate = filter;
    arr_result = [appContext executeFetchRequest:requset error:&error];
    
    if (arr_result.count) {
        MyClass * class_two = arr_result[0];
        [self deleteEntity:class_two];
        [self save];
    }
    
    requset = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    filter = [NSPredicate predicateWithFormat:@"name = '徐开义'"];
    requset.predicate = filter;
    arr_result = [appContext executeFetchRequest:requset error:&error];
    
    if (arr_result.count) {
        Teacher * xukaiyi = arr_result[0];
        [self deleteEntity:xukaiyi];
        [self save];
    }
}

- (void)countTest {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    [request setResultType:NSCountResultType];
    
    NSError * error = nil;
    id result = [appContext executeFetchRequest:request error:&error];
    NSLog(@"%@", result[0]);
}

- (void)maxTest {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.resultType = NSDictionaryResultType;
    
    NSExpression * the_max_expression = [NSExpression expressionForFunction:@"max:" arguments:@[[NSExpression expressionForKeyPath:@"age"]]];
    NSExpressionDescription * expression_des = [NSExpressionDescription new];
    expression_des.name = @"maxAge";
    expression_des.expression = the_max_expression;
    expression_des.expressionResultType = NSInteger32AttributeType;
    
    request.propertiesToFetch = @[expression_des];
    
    NSError * error = nil;
    id result = [appContext executeFetchRequest:request error:&error];
    NSLog(@"the max age is : %@", result[0][@"maxAge"]);
}

- (void)studentNumGroupByAge {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.resultType = NSDictionaryResultType;
    
    NSExpression * the_count_expression = [NSExpression expressionForFunction:@"count:" arguments:@[[NSExpression expressionForKeyPath:@"name"]]];
    NSExpressionDescription * expression_des = [NSExpressionDescription new];
    expression_des.name = @"num";
    expression_des.expression = the_count_expression;
    expression_des.expressionResultType = NSInteger32AttributeType;
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:appContext];
    NSAttributeDescription * adult_num_group_by = [entity.attributesByName objectForKey:@"age"];
    request.propertiesToGroupBy = @[adult_num_group_by];
    request.propertiesToFetch = @[@"age", expression_des];
    
    NSError * error = nil;
    id result = [appContext executeFetchRequest:request error:&error];
    for (id item in result) {
        NSLog(@"Age:%@ Student Num:%@", item[@"age"], item[@"num"]);
    }
}

- (BOOL)insertCourses:(NSArray *)courses {
    for (NSString * a_course in courses) {
        Course * course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:appContext];
        course.name = a_course;
    }
    [self save];
    return YES;
}

- (BOOL)deleteCourses:(NSArray *)courses {
    for (Course * a_course in courses) {
        [self deleteEntity:a_course];
    }
    return YES;
}

- (BOOL)updateCourse {
    [self save];
    return YES;
}

- (BOOL)cleanAllCourses {
    
    return YES;
}

- (NSFetchedResultsController *)allCourses {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sort];
    
    NSFetchedResultsController * controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:appContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError * error = nil;
    [controller performFetch:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    } else {
        return controller;
    }
}

@end
