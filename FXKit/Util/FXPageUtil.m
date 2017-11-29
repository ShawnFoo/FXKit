//
//  FXPageUtil.m
//  FXKit
//
//  Created by ShawnFoo on 3/29/16.
//  Copyright © 2016年 ShawnFoo. All rights reserved.
//

#import "FXPageUtil.h"
#import <objc/runtime.h>

#pragma mark - NSMutableArray + FXPageNoDuplication Interface
@interface NSMutableArray (FXPageNoDuplication)
- (void)fx_removeDuplicationInPageObjects;
@end


#pragma mark - FXPageUtil
@interface FXPageUtil () {
    NSMutableArray *_objects;
}
@property (nonatomic, assign) BOOL uniqueObject;

@end

@implementation FXPageUtil

static dispatch_queue_t sPageSerialQueue;
static NSUInteger sDefaultOnePageSize;
/** 页码偏移 */
static NSUInteger sPageNumberOffset;
/** 序号偏移 */
static NSUInteger sPageStartIndexOffset;

#pragma mark LifeCycle
+ (void)initialize {
    if (self == [FXPageUtil class]) {
        sPageSerialQueue = dispatch_queue_create("com.ShawnFoo.FXKit.Util.pageUtil.serialQueue", NULL);
        sDefaultOnePageSize = 10;
        sPageNumberOffset = 1;
        sPageStartIndexOffset = 0;
    }
}

#pragma mark Search
- (id)objectAtIndex:(NSUInteger)index {
    __block id bObject = nil;
    dispatch_sync(sPageSerialQueue, ^{
        if (index < self->_objects.count) {
            bObject = self->_objects[index];
        }
    });
    return bObject;
}

- (NSInteger)indexOfObject:(id)object {
    __block NSInteger bIndex = NSNotFound;
    if (object) {
        dispatch_sync(sPageSerialQueue, ^{
            bIndex = [self->_objects indexOfObject:object];
        });
    }
    return bIndex;
}

- (BOOL)containsObject:(id)object {
    __block BOOL bContained = NO;
    if (object) {
        dispatch_sync(sPageSerialQueue, ^{
            bContained = [self->_objects containsObject:object];
        });
    }
    return bContained;
}

#pragma mark Add & Insert
- (void)insertObjectToStart:(id)object {
    if (object) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(sPageSerialQueue, ^{
            typeof(self) self = weakSelf;
            [self lazyLoadingObjectsWithCapacity:1];
            if ([self shouldAddObject:object]) {
                [self->_objects insertObject:object atIndex:0];
            }
        });
    }
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {
    if (object) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(sPageSerialQueue, ^{
            typeof(self) self = weakSelf;
            [self lazyLoadingObjectsWithCapacity:1];
            if ([self shouldAddObject:object]) {
                [self->_objects insertObject:object atIndex:index];
            }
        });
    }
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    if (objects.count) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(sPageSerialQueue, ^{
            typeof(self) self = weakSelf;
            [self lazyLoadingObjectsWithCapacity:objects.count];
            [self->_objects insertObjects:objects atIndexes:indexes];
            [self removeDuplicatedObjectsIfNeeded];
        });
    }
}

- (void)addObject:(id)object {
    if (object) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(sPageSerialQueue, ^{
            typeof(self) self = weakSelf;
            [self lazyLoadingObjectsWithCapacity:1];
            if ([self shouldAddObject:object]) {
                [self->_objects addObject:object];
            }
        });
    }
}

- (void)addObjects:(NSArray *)objects {
    if (objects.count > 0) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(sPageSerialQueue, ^{
            typeof(self) self = weakSelf;
            [self lazyLoadingObjectsWithCapacity:objects.count];
            [self->_objects addObjectsFromArray:objects];
            [self removeDuplicatedObjectsIfNeeded];
        });
    }
}

- (void)lazyLoadingObjectsWithCapacity:(NSInteger)capacity {
    if (!self->_objects) {
        self->_objects = [NSMutableArray arrayWithCapacity:capacity];
    }
}

- (void)removeDuplicatedObjectsIfNeeded {
    if (self.uniqueObject) {
        [self->_objects fx_removeDuplicationInPageObjects];
    }
}

- (BOOL)shouldAddObject:(id)object {
    return self.uniqueObject ? ![self->_objects containsObject:object] : YES;
}

#pragma mark Replace
- (void)replaceObject:(id)object atIndex:(NSUInteger)index {
    if (object) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(sPageSerialQueue, ^{
            typeof(self) self = weakSelf;
            if (self.uniqueObject) {
                [self->_objects removeObject:object];
            }
            [self->_objects replaceObjectAtIndex:index withObject:object];
        });
    }
}

#pragma mark Remove
- (void)removeObject:(id)object {
    if (object) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(sPageSerialQueue, ^{
            typeof(self) self = weakSelf;
            [self->_objects removeObject:object];
        });
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    __weak typeof(self) weakSelf = self;
    dispatch_async(sPageSerialQueue, ^{
        typeof(self) self = weakSelf;
        if (index < self->_objects.count) {
            [self->_objects removeObjectAtIndex:index];
        }
    });
}

- (void)removeLastObject {
    __weak typeof(self) weakSelf = self;
    dispatch_async(sPageSerialQueue, ^{
        typeof(self) self = weakSelf;
        [self->_objects removeLastObject];
    });
}

- (void)removeAllObjects {
    __weak typeof(self) weakSelf = self;
    dispatch_async(sPageSerialQueue, ^{
        typeof(self) self = weakSelf;
        [self->_objects removeAllObjects];
    });
}

- (void)removeDuplicatedObjects {
    __weak typeof(self) weakSelf = self;
    dispatch_async(sPageSerialQueue, ^{
        typeof(self) self = weakSelf;
        [self->_objects fx_removeDuplicationInPageObjects];
    });
}

#pragma mark Sort
- (void)sortArray:(NSComparisonResult (^)(id obj1, id obj2))compareBlock {
    __weak typeof(self) weakSelf = self;
    dispatch_async(sPageSerialQueue, ^{
        typeof(self) self = weakSelf;
        [self->_objects sortUsingComparator:compareBlock];
    });
}

#pragma mark Equal
- (BOOL)pageObjectsAreEqualToObjects:(NSArray *)objects {
    __block BOOL bIsEqual = NO;
    dispatch_sync(sPageSerialQueue, ^{
        bIsEqual = [objects isEqualToArray:_objects];
    });
    return bIsEqual;
}

#pragma mark Accessor
- (void)setObjects:(NSArray *)objects {
    __weak typeof(self) weakSelf = self;
    dispatch_async(sPageSerialQueue, ^{
        typeof(self) self = weakSelf;
        if (objects) {
            self->_objects = [objects mutableCopy];
        }
        else {
            [self->_objects removeAllObjects];
        }
    });
}

- (NSArray *)objects {
    __block NSArray *bObjects = nil;
    dispatch_sync(sPageSerialQueue, ^{
        bObjects = [self->_objects copy];
    });
    return bObjects;
}

- (id)firstObject {
    __block id bFirstObject = nil;
    dispatch_sync(sPageSerialQueue, ^{
        bFirstObject = self->_objects.firstObject;
    });
    return bFirstObject;
}

- (id)lastObject {
    __block id bLastObject = nil;
    dispatch_sync(sPageSerialQueue, ^{
        bLastObject = self->_objects.lastObject;
    });
    return bLastObject;
}

- (NSUInteger)onePageSize {
    return !_onePageSize ? sDefaultOnePageSize : _onePageSize;
}

- (NSUInteger)count {
    __block NSUInteger bCount;
    dispatch_sync(sPageSerialQueue, ^{
        bCount = self->_objects.count;
    });
    return bCount;
}

@end


#pragma mark - FXPageUtil + PageNumber
@implementation FXPageUtil (PageNumber)

- (NSInteger)nextPageNumber {
    __block NSInteger nextPageNumber = 0;
    dispatch_sync(sPageSerialQueue, ^{
        nextPageNumber = self->_objects.count / self.onePageSize;
    });
    return nextPageNumber + sPageNumberOffset;
}

- (NSInteger)pagesCount {
    __block NSInteger pagesCount = 0;
    dispatch_sync(sPageSerialQueue, ^{
        pagesCount = ceil(1.0 * self->_objects.count / self.onePageSize);
    });
    return pagesCount;
}

- (NSInteger)firstPageNumber {
    return sPageNumberOffset;
}

@end


#pragma mark - FXPageUtil + PageIndex
@implementation FXPageUtil (PageIndex)

- (NSInteger)nextPageStartIndex {
    return self.count + sPageStartIndexOffset;
}

@end


#pragma mark - FXPageUtil + Extension
@implementation FXPageUtil (Extension)

- (void)setCurrentPageNumber:(NSInteger)currentPageNumber {
    objc_setAssociatedObject(self,
                             @selector(currentPageNumber),
                             @(currentPageNumber),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)currentPageNumber {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setLastPage:(BOOL)lastPage {
    objc_setAssociatedObject(self,
                             @selector(isLastPage),
                             @(lastPage),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLastPage {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTotolCount:(NSInteger)totolCount {
    objc_setAssociatedObject(self,
                             @selector(totolCount),
                             @(totolCount),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)totolCount {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setFirstRequest:(BOOL)firstRequest {
    objc_setAssociatedObject(self,
                             @selector(isFirstRequest),
                             @(firstRequest),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isFirstRequest {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end



#pragma mark - FXPageUtil + PageCreation
@implementation FXPageUtil (PageCreation)

+ (instancetype)pageUtil {
    return [[FXPageUtil alloc] init];
}

+ (instancetype)pageUtilWithObjects:(NSArray *)objects {
    FXPageUtil *page = [self pageUtil];
    [page addObjects:objects];
    return page;
}

+ (instancetype)pageUtilWithEachObject:(id)firstObject, ... {
    FXPageUtil *page = [self pageUtil];
    [page addObject:firstObject];
    va_list objects;
    va_start(objects, firstObject);
    id object = nil;
    while ((object = va_arg(objects, id))) {
        [page addObject:object];
    }
    va_end(objects);
    return page;
}

+ (instancetype)uniqueObjectPageUtil {
    FXPageUtil *page = [self pageUtil];
    page.uniqueObject = YES;
    return page;
}

+ (instancetype)uniqueObjectPageUtilWithObjects:(NSArray *)objects {
    FXPageUtil *page = [self pageUtilWithObjects:objects];
    page.uniqueObject = YES;
    return page;
}

+ (instancetype)uniqueObjectPageUtilWithEachObject:(id)firstObject, ... {
    FXPageUtil *page = [self pageUtil];
    [page addObject:firstObject];
    va_list objects;
    va_start(objects, firstObject);
    id object = nil;
    while ((object = va_arg(objects, id))) {
        [page addObject:object];
    }
    va_end(objects);
    page.uniqueObject = YES;
    return page;
}

@end


#pragma mark - NSMutableArray + FXPageNoDuplication IMP
@implementation NSMutableArray (FXPageNoDuplication)

- (void)fx_removeDuplicationInPageObjects {
    NSOrderedSet *objectsOrderedSet = [NSOrderedSet orderedSetWithArray:[self copy]];
    [self setArray:objectsOrderedSet.array];
}

@end

