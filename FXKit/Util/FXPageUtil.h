//
//  FXPageUtil.h
//  FXKit
//
//  Created by ShawnFoo on 3/29/16.
//  Copyright © 2016年 ShawnFoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  分页Model的管理工具, 提供下一页页码、下一页数据起始Index的快捷访问等, 所有方法线程安全.
 */
@interface FXPageUtil<__covariant ObjectType> : NSObject

/** 模型数组 */
@property (nullable, nonatomic, copy) NSArray<ObjectType> *objects;
/** 首个对象 */
@property (nullable, nonatomic, readonly) ObjectType firstObject;
/** 最后一个对象 */
@property (nullable, nonatomic, readonly) ObjectType lastObject;
/** 单页大小, 默认:10 */
@property (nonatomic, assign) NSUInteger onePageSize;
/** pageUtil中包含的数据总数 */
@property (nonatomic, readonly) NSUInteger count;
/** 是否开启了去重(默认: NO, 元素需自行实现isEqual:和hash:方法) */
@property (nonatomic, readonly) BOOL uniqueObject;

- (nullable ObjectType)objectAtIndex:(NSUInteger)index;
- (NSInteger)indexOfObject:(ObjectType)object;
- (BOOL)containsObject:(ObjectType)object;

- (void)insertObjectToStart:(ObjectType)object;
- (void)insertObject:(ObjectType)object atIndex:(NSUInteger)index;
- (void)insertObjects:(NSArray<ObjectType> *)objects atIndexes:(NSIndexSet *)indexes;

- (void)addObject:(ObjectType)object;
- (void)addObjects:(NSArray<ObjectType> *)objects;

- (void)replaceObject:(ObjectType)object atIndex:(NSUInteger)index;

- (void)removeObject:(ObjectType)object;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeAllObjects;
- (void)removeDuplicatedObjects;

- (void)sortArray:(NSComparisonResult (^)(ObjectType obj1, ObjectType obj2))compareBlock;

- (BOOL)pageObjectsAreEqualToObjects:(NSArray<ObjectType> *)objects;

@end


/**
 页码访问类别
 */
@interface FXPageUtil (PageNumber)

/** 下一页的页码(用于接口请求) */
@property (nonatomic, readonly) NSInteger nextPageNumber;
/** 目前页码总数 */
@property (nonatomic, readonly) NSInteger pagesCount;
/** 首页页码 */
@property (nonatomic, readonly) NSInteger firstPageNumber;

@end


/**
 序号访问类别
 */
@interface FXPageUtil (PageIndex)

/** 下一页内容的起始Index. 用于后台数据库分页语句如 select * from tableName limit startIndex on count  */
@property (nonatomic, readonly) NSInteger nextPageStartIndex;

@end


/**
 拓展方法, 调用者自行管理这些属性状态!
 */
@interface FXPageUtil (Extension)

/** 当前页码, 调用者自行管理该属性状态! */
@property (nonatomic, assign) NSInteger currentPageNumber;
/** 是否最后一页, 调用者自行管理该属性状态! */
@property (nonatomic, assign, getter=isLastPage) BOOL lastPage;
/** 后台告知的数据总数, 调用者自行管理该属性状态! 注: PageUtil.count才是工具类所持有的Model数量 */
@property (nonatomic, assign) NSInteger totolCount;
/** 是否为首次请求, 调用者自行管理该属性状态! */
@property (nonatomic, assign, getter=isFirstRequest) BOOL firstRequest;

@end


/**
 FXPage创建方法类别. uniqueObject开头的方法创建出的Page会对添加的Model自动去重.
 */
@interface FXPageUtil<__covariant ObjectType> (PageCreation)

+ (instancetype)pageUtil;
+ (instancetype)pageUtilWithObjects:(NSArray<ObjectType> *)objects;
+ (instancetype)pageUtilWithEachObject:(ObjectType)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

/** 无重复内容元素的PageUtil */
+ (instancetype)uniqueObjectPageUtil;
+ (instancetype)uniqueObjectPageUtilWithObjects:(NSArray<ObjectType> *)objects;
+ (instancetype)uniqueObjectPageUtilWithEachObject:(ObjectType)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
