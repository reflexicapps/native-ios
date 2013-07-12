/* @license
 * This file is part of the Game Closure SDK.
 *
 * The Game Closure SDK is free software: you can redistribute it and/or modify
 * it under the terms of the Mozilla Public License v. 2.0 as published by Mozilla.
 
 * The Game Closure SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * Mozilla Public License v. 2.0 for more details.
 
 * You should have received a copy of the Mozilla Public License v. 2.0
 * along with the Game Closure SDK.  If not, see <http://mozilla.org/MPL/2.0/>.
 */

#import <Foundation/Foundation.h>
#import "Texture2D.h"

@interface ResourceLoader : NSObject

@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) NSString *appBundle;		// resources.bundle path
@property (nonatomic, retain) NSString *appBase;		// Root resource path (includes splash screens)
@property (nonatomic, retain) NSCondition *imageWaiter;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSString *documentsDirectory;

- (NSString *) initStringWithContentsOfURL:(NSString *)url;
- (NSURL *) resolve:(NSString *)url;
- (NSURL *) resolveFile:(NSString *)url inBundle:(BOOL)inBundle;
- (NSURL *) resolveFileUrl:(NSString *)url;

- (void) finishLoadingText:(NSString *)url;
-(void) sendImageLoadedEventForURL: (NSString *) url glName: (int) glName width: (int) width height: (int) height originalWidth: (int) originalWidth originalHeight: (int) originalHeight;

- (void) imageThread;
- (void) loadImage:(NSString *)url;
+ (ResourceLoader *) get;
+ (void) release;
@end
