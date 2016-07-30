//
//  DataService.m
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/30/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import "DataService.h"
@import Firebase;
@import FirebaseDatabase;
#import "HistoricLocation.h"

@interface DataService ()

@property (nonatomic, strong) FIRDatabaseReference *ref;

@end

@implementation DataService

+ (instancetype)sharedInstance
{
    static DataService *sharedService = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
                      sharedService = [[self alloc] init];
                  });

    return sharedService;
}

- (FIRDatabaseReference *)ref
{
    if (!_ref)
    {
        _ref = [[FIRDatabase database] reference];
    }

    return _ref;
}

- (void)getLocationsWithCompletion:(void (^)(NSArray *locations))completion
{
    FIRDatabaseReference *locations = [[self ref] child:@"historic-locations"];
    [locations observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *historicLocations = [NSMutableArray array];
        NSArray *snapshots = snapshot.children.allObjects;

        for (FIRDataSnapshot *snapshot in snapshots)
        {
            NSDictionary *locationDictionary = snapshot.value;
            HistoricLocation *newLocation = [[HistoricLocation alloc] initWithJSON:locationDictionary];
            [historicLocations addObject:newLocation];
        }

        completion(historicLocations);
    }];
}

@end
