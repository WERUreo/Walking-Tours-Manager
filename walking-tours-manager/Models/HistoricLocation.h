//
//  HistoricLocation.h
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/30/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface HistoricLocation : NSObject

@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *locationAddress;
@property (nonatomic, strong) NSString *locationDescription;
@property (nonatomic, strong) NSString *locationType;
@property (nonatomic) CLLocationCoordinate2D locationCoordinates;
@property (nonatomic, strong) NSDate *localRegistryDate;
@property (nonatomic, strong) NSDate *nationalRegistryDate;

- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                 description:(NSString *)description
                        type:(NSString *)type
                 coordinates:(CLLocationCoordinate2D)coordinates
           localRegistryDate:(NSDate *)localRegistryDate
        nationalRegistryDate:(NSDate *)nationalRegistryDate;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
