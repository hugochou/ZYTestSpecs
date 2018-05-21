//
//  NSArray+EV.h
//  EVClub
//
//  Created by LiJieming on 15/3/10.
//  Copyright (c) 2015年 BitRice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (EV)

@property (nonatomic, readonly) id randomObject;

- (ObjectType)ev_safeObjectAtIndex:(NSUInteger)index;
- (ObjectType)ev_objectPassingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray<ObjectType> *)ev_objectArrayPassingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray<ObjectType> *)ev_safeSubarrayWithRange:(NSRange)range;

- (NSArray *)ev_reverseArray;
- (NSArray *)ev_objectClassArray;

@end


@interface NSMutableArray <ObjectType> (EV)

- (void)ev_safeAddObject:(ObjectType)anObject;
- (void)ev_safeInsertObject:(ObjectType)anObject atIndex:(NSUInteger)index;
- (void)ev_safeRemoveObjectAtIndex:(NSUInteger)index;

- (void)ev_removeObjectsPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

@end


@interface NSArray(EVMutableConvert)

-(id)ev_deepCopy;
-(NSMutableArray*)ev_mutableConvert;

@end


@interface NSDictionary(mutableConvert)

-(NSMutableDictionary*)ev_mutableConvert;
-(id)ev_deepCopy;

@end


@interface NSMutableArray (EVAddOrReplaceObject)

- (void)ev_addOrReplaceObject:(id)anObject withIdentifier:(NSString*)identifierKey;
- (void)ev_addOrReplaceObjectsFromArray:(NSArray *)otherArray withIdentifier:(NSString*)identifierKey;

@end
