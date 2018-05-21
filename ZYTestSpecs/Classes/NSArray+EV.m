//
//  NSArray+EV.m
//  EVClub
//
//  Created by LiJieming on 15/3/10.
//  Copyright (c) 2015年 BitRice. All rights reserved.
//

#import "NSArray+EV.h"

@implementation NSArray (EV)

- (id)ev_safeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (id)ev_objectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    NSUInteger index = [self indexOfObjectPassingTest:predicate];
    
    return [self ev_safeObjectAtIndex:index];
}

- (NSArray *)ev_objectArrayPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:predicate];
    
    return [self objectsAtIndexes:indexes];
}

- (NSArray *)ev_safeSubarrayWithRange:(NSRange)range {
    if (range.location >= self.count) {
        return @[];
    }
    else {
        range.length = MIN(range.length, self.count - range.location);
        return [self subarrayWithRange:range];
    }
}

- (id)randomObject {
    if (self.count == 0) {
        return nil;
    }
    
    NSUInteger randomIndex = arc4random() % self.count;
    return [self ev_safeObjectAtIndex:randomIndex];
}

- (NSArray *)ev_reverseArray {
    return self.reverseObjectEnumerator.allObjects;
}

- (NSArray *)ev_objectClassArray {
    NSMutableArray *classArray = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [classArray addObject:[obj class]];
    }];
    
    return [classArray copy];
}

@end

@implementation NSMutableArray (EV)

- (void)ev_safeAddObject:(id)anObject {
    if (anObject != nil) {
        [self addObject:anObject];
    }
}

- (void)ev_safeInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject != nil) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)ev_safeRemoveObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

- (void)ev_removeObjectsPassingTest:(BOOL (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    [self removeObjectsAtIndexes:[self indexesOfObjectsPassingTest:predicate]];
}

@end
@implementation NSDictionary(EVMutableConvert)
-(id)ev_deepCopy
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}
-(NSMutableDictionary*)ev_mutableConvert
{
    NSMutableDictionary *r = [self mutableCopy];
    for(NSInteger i=self.allKeys.count-1;i>=0;i--)
    {
        NSString *key = self.allKeys[i];
        NSObject *obj = [self objectForKey:key];
        if([obj.class isSubclassOfClass: [NSDictionary class]])
        {
            NSMutableDictionary *newObj = [(NSDictionary*)obj ev_mutableConvert];
            [r removeObjectForKey:key];
            [r setObject:newObj forKey:key];
        }
        else if([obj.class isSubclassOfClass: [NSArray class]])
        {
            NSMutableArray *newObj = [(NSArray*)obj ev_mutableConvert];
            [r removeObjectForKey:key];
            [r setObject:newObj forKey:key];
        }
    }
    return r;
}

@end

@implementation NSArray(mutableConvert)
-(id)ev_deepCopy
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}
-(NSMutableArray*)ev_mutableConvert
{
    NSMutableArray *r = [self mutableCopy];
    for(NSInteger i=self.count-1;i>=0;i--)
    {
        NSObject *obj = self[i];
        if([obj.class isSubclassOfClass: [NSArray class]])
        {
            NSMutableArray *newObj = [(NSArray*)obj ev_mutableConvert];
            [r replaceObjectAtIndex:i withObject:newObj];
        }
        else if([obj.class isSubclassOfClass: [NSDictionary class]])
        {
            NSMutableDictionary *newObj = [(NSDictionary*)obj ev_mutableConvert];
            [r replaceObjectAtIndex:i withObject:newObj];
        }
    }
    return r;
}

@end


@implementation NSMutableArray (EVAddOrReplaceObject)

- (void)ev_addOrReplaceObject:(id)anObject withIdentifier:(NSString*)identifierKey {
    BOOL replaced = NO;
    if (identifierKey != nil) {
        for (NSUInteger index = 0; index < [self count]; index++) {
            id originObject = self[index];
            id originIdentifier = [originObject valueForKey:identifierKey];
            id newIdentifier = [anObject valueForKey:identifierKey];
            if (anObject != nil && originIdentifier != nil && newIdentifier != nil &&
                ([newIdentifier isEqual:originObject] || ([newIdentifier isKindOfClass:[NSString class]] && [originIdentifier isKindOfClass:[NSString class]] && [originIdentifier isEqualToString:newIdentifier]))) {
                [self replaceObjectAtIndex:index withObject:anObject];
                replaced = YES;
                break;
            }
        }
    }
    
    if (!replaced) {
        [self addObject:anObject];
    }
}

- (void)ev_addOrReplaceObjectsFromArray:(NSArray *)otherArray withIdentifier:(NSString*)identifierKey {
    for (id anObject in otherArray) {
        [self ev_addOrReplaceObject:anObject withIdentifier:identifierKey];
    }
}

@end
