//
//  DataService.h
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/30/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoricLocation.h"

@interface DataService : NSObject

+ (instancetype)sharedInstance;
- (void)getLocationsFromCity:(NSString *) city withCompletion:(void (^)(NSArray *locations))completion;
- (void)saveLocation:(HistoricLocation *)location inCity:(NSString *)city;

@end
