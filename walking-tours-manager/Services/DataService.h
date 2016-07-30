//
//  DataService.h
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/30/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject

+ (instancetype)sharedInstance;
- (void)getLocationsWithCompletion:(void (^)(NSArray *locations))completion;

@end
