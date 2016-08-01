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

////////////////////////////////////////////////////////////

- (FIRDatabaseReference *)ref
{
    if (!_ref)
    {
        _ref = [[FIRDatabase database] reference];
    }

    return _ref;
}

////////////////////////////////////////////////////////////

- (void)getLocationsFromCity:(NSString *)city withCompletion:(void (^)(NSArray *locations))completion
{
    FIRDatabaseReference *locations = [[[self ref] child:@"historic-locations"] child:city];
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

////////////////////////////////////////////////////////////

- (void)saveLocation:(HistoricLocation *)location inCity:(NSString *)city
{
    FIRDatabaseReference *locationsRef = [[[self ref] child:@"historic-locations"] child:city];

    NSString *key = [locationsRef childByAutoId].key;
    [[[locationsRef child:key] child:@"name"] setValue:location.locationName];
    [[[locationsRef child:key] child:@"address"] setValue:location.locationAddress];
    [[[locationsRef child:key] child:@"description"] setValue:location.locationDescription];
    [[[locationsRef child:key] child:@"type"] setValue:location.locationType];
    [[[[locationsRef child:key] child:@"location"] child:@"latitude"] setValue:@(location.locationCoordinates.latitude)];
    [[[[locationsRef child:key] child:@"location"] child:@"longitude"] setValue:@(location.locationCoordinates.longitude)];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.sss";
    if (location.localRegistryDate)
    {
        [[[locationsRef child:key] child:@"localRegistryDate"] setValue:[formatter stringFromDate:location.localRegistryDate]];
    }

    if (location.nationalRegistryDate)
    {
        [[[locationsRef child:key] child:@"nationalRegistryDate"] setValue:[formatter stringFromDate:location.nationalRegistryDate]];
    }
}

@end
