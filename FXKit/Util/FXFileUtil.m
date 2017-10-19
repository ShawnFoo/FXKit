//
//  FXFileUtil.m
//  FXKit
//
//  Created by ShawnFoo on 8/24/15.
//  Copyright (c) 2015 ShawnFoo. All rights reserved.
//

#import "FXFileUtil.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FXFileUtil

+ (NSString *)firstSearchPathForDirectoriesInUserDomains:(NSSearchPathDirectory)directory {
	return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)documentPath {
    return [self firstSearchPathForDirectoriesInUserDomains:NSDocumentDirectory];
}

+ (NSString *)cachePath {
	return [self firstSearchPathForDirectoriesInUserDomains:NSCachesDirectory];
}

+ (NSString *)tempPath {
	return NSTemporaryDirectory();
}

+ (NSString *)resourcePath {
	return [[NSBundle mainBundle] resourcePath];
}

+ (NSURL *)documentURLPath {
	return [NSURL fileURLWithPath:[self documentPath]];
}

+ (NSURL *)cacheURLPath {
	return [NSURL fileURLWithPath:[self cachePath]];
}

+ (NSURL *)tempURLPath {
	return [NSURL fileURLWithPath:[self tempPath]];
}

+ (NSURL *)resourceURLPath {
	return [NSURL fileURLWithPath:[self resourcePath]];
}

@end


#pragma mark - FXFileUtil + FilePathAppending
@implementation FXFileUtil (FilePathAppending)

+ (NSString *)documentPathByAppendingComponent:(NSString *)component {
	return [[self documentPath] stringByAppendingPathComponent:component];
}

+ (NSString *)cachePathByAppendingComponent:(NSString *)component {
	return [[self cachePath] stringByAppendingPathComponent:component];
}

+ (nullable NSString *)bundlePathOfExsitedComponent:(NSString *)component {
	NSString *directory = [component stringByDeletingLastPathComponent];
	if (!directory.length) {
		directory = nil;
	}
	NSString *lastComponent = [component lastPathComponent];
	NSString *name = [lastComponent stringByDeletingPathExtension];
	NSString *ext = [lastComponent pathExtension];
	
	return [[NSBundle mainBundle] pathForResource:name ofType:ext inDirectory:directory];
}

+ (nullable NSString *)documentPathOfExsitedComponent:(NSString *)component {
	NSString *path = [self documentPathByAppendingComponent:component];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		return path;
	}
	return nil;
}

+ (nullable NSString *)documentOrBundlePathOfExsitedComponent:(NSString *)component {
	NSString *path = [self documentOrBundlePathOfExsitedComponent:component];
	return path.length ? path : [self bundlePathOfExsitedComponent:component];
}

+ (nullable NSArray<NSString *> *)filesInDirectoryAtPath:(NSString *)path error:(NSError * _Nullable *)error {
	return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:error];;
}

@end


#pragma mark - FXFileUtil + FileOperation
@implementation FXFileUtil (FileOperation)

+ (nullable NSError *)createDirOfPath:(NSString *)path {
	if (![self itemExistsAtPath:path]) {
		NSError *error = nil;
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
		if (error) {
			return error;
		}
		return nil;
	}
	return [NSError errorWithDomain:NSFilePathErrorKey
							   code:NSFileWriteFileExistsError
						   userInfo:@{
									  NSLocalizedDescriptionKey: @"文件创建失败, 存在同名文件."
									  }];
}

+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError * _Nullable *)error {
	return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

+ (BOOL)itemExistsAtPath:(NSString *)filePath {
	return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (BOOL)dirExistsAtPath:(NSString *)dir {
	BOOL isDir = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir]) {
		return isDir;
	}
	return NO;
}

@end


#pragma mark - FXFileUtil + FileSize
@implementation FXFileUtil (FileSize)

+ (int64_t)sizeOfFileAtPath:(NSString *)path {
	NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
	NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] integerValue];
	return fileSize;
}

+ (int64_t)sizeOfFolderAtPath:(NSString *)path {
	int64_t bytes = 0;
	NSArray *contents = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
	NSEnumerator *contentsEnumurator = [contents objectEnumerator];
	NSString *file;
	while (file = [contentsEnumurator nextObject]) {// 遍历每个文件的大小
		bytes += [self sizeOfFileAtPath:[path stringByAppendingPathComponent:file]];
	}
	return bytes;
}

+ (int64_t)sizeOfItemAtPath:(NSString *)path {
	if ([self dirExistsAtPath:path]) {
		[self sizeOfFolderAtPath:path];
	}
	return [self sizeOfFileAtPath:path];
}

+ (NSString *)formatSizeOfItemAtPath:(NSString *)path {
	return [self sizeOfItemAtPath:path
				  withFormatBlock:^NSString * _Nonnull(int64_t bytes) {
					  NSString *formatSize;
					  double kbSize = bytes / 1024.0;
					  if (kbSize < 1024) {
						  formatSize = [NSString stringWithFormat:@"%.1fKB", kbSize];
					  }
					  else {
						  float mbSize = kbSize / 1024.0;
						  formatSize = [NSString stringWithFormat:@"%.1fMB", mbSize];
					  }
					  return formatSize;
				  }];
}

+ (NSString *)sizeOfItemAtPath:(NSString *)path withFormatBlock:(NSString * (^)(int64_t bytes))formatBlock {
	int64_t byteSize = [self sizeOfItemAtPath:path];
	return formatBlock(byteSize);
}


@end

NS_ASSUME_NONNULL_END
