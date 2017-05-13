//
//  HSFJSONManager.m
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "HSFJSONManager.h"
#import "HSFEventManager.h"

@interface HSFJSONManager () <HSFEventManagerDelegate>



@end

@implementation HSFJSONManager

- (void)eventManager:(HSFEventManager *)manager didReceiveData:(NSDictionary *)data
{
	NSError *error = nil;
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];

	if (error == nil)
	{
		[jsonData writeToFile:[self pathForJSON] atomically:YES];
		[self.delegate jsonManager:self didUpdateData:data];
	}
}

- (NSString *)pathForJSON
{
	NSFileManager *fileManager = [NSFileManager defaultManager];

	NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* fileName = @"data.json";
	NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];

	if (![fileManager fileExistsAtPath:fileAtPath])
	{
		[fileManager createFileAtPath:fileAtPath contents:nil attributes:nil];
	}

	return fileAtPath;
}

@end
