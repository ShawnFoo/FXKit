//
//  FXFileUtil.h
//  FXKit
//
//  Created by ShawnFoo on 8/24/15.
//  Copyright (c) 2015 ShawnFoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - FXFileUtil

/**
 FXFileUtil: 提供文件路径获取、合成的方法.
 
 FXFileUtil + FilePathAppending: 提供文件路径合成的方法.
 
 FXFileUtil + FileOperation: 文件创建、删除、是否存在的方法.
 
 FXFileUtil + FileSize: 提供文件大小检测, 格式化的方法.
 */
@interface FXFileUtil : NSObject

@property (nonatomic, readonly, class) NSString *documentPath;
@property (nonatomic, readonly, class) NSString *cachePath;
@property (nonatomic, readonly, class) NSString *tempPath;
@property (nonatomic, readonly, class) NSString *resourcePath;

@property (nonatomic, readonly, class) NSURL *documentURLPath;
@property (nonatomic, readonly, class) NSURL *cacheURLPath;
@property (nonatomic, readonly, class) NSURL *tempURLPath;
@property (nonatomic, readonly, class) NSURL *resourceURLPath;

@end


#pragma mark - FXFileUtil + FilePathAppending
@interface FXFileUtil (FilePathAppending)

/** 基于document目录路径追加文件成员 */
+ (NSString *)documentPathByAppendingComponent:(NSString *)component;

/** 基于cache目录路径追加文件成员 */
+ (NSString *)cachePathByAppendingComponent:(NSString *)component;

/** 在main bundle目录中浅度查找文件成员. 若bundle下能找到该文件, 会返回该文件的绝对路径, 否则会返回nil */
+ (nullable NSString *)bundlePathOfExsitedComponent:(NSString *)component;

/** 在document目录中浅度查找文件成员. 若document下能找到该文件, 会返回该文件的绝对路径, 否则会返回nil */
+ (nullable NSString *)documentPathOfExsitedComponent:(NSString *)component;

/** 先在document下目录中浅度查找文件成员. 若不存在于document目录中, 会再去bundle目录中查找. 若能找到该文件, 会返回该文件的绝对路径, 否则会返回nil */
+ (nullable NSString *)documentOrBundlePathOfExsitedComponent:(NSString *)component;

/** 浅度搜索该路径对应目录下的所有文件(文件名) */
+ (nullable NSArray<NSString *> *)filesInDirectoryAtPath:(NSString *)path error:(NSError * _Nullable *)error;

@end


#pragma mark - FXFileUtil + FileOperation
@interface FXFileUtil (FileOperation)

/** 创建指定路径的文件夹 */
+ (nullable NSError *)createDirOfPath:(NSString *)path;

/** 删除指定路径的文件或目录 */
+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError * _Nullable *)error;

/** 传入的文件路径是否存在对应文件(或目录) */
+ (BOOL)itemExistsAtPath:(NSString *)path;

/** 传入的目录路径是否存在该目录, 只能是目录路径, 传入文件路径返回false */
+ (BOOL)dirExistsAtPath:(NSString *)path;

@end


#pragma mark - FXFileUtil + FileSize
@interface FXFileUtil (FileSize)

/** 读取某个文件或目录(会递归所有子目录)的大小, 单位:byte */
+ (int64_t)sizeOfItemAtPath:(NSString *)path;

/**
 格式化输出某个文件或目录(会递归所有子目录)的大小.
 
 @return 如果大于1mb则返回的单位为mb; 否则为kb. 结果保留1位小数
 */
+ (NSString *)formatSizeOfItemAtPath:(NSString *)path;

/**
 格式化输出某个文件或目录(会递归所有子目录)的大小. 使用方法可参考"formatSizeOfItemAtPath:"的实现

 @params formatBlock 用于格式化大小字符串的Block, 参数: 路径对应文件/目录的字节数
 @return 格式化大小
 */
+ (NSString *)sizeOfItemAtPath:(NSString *)path withFormatBlock:(NSString * (^)(int64_t bytes))formatBlock;

@end

NS_ASSUME_NONNULL_END
