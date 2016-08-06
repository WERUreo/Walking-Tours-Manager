//
//  HistoricLocation.h
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/30/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface HistoricLocation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *locationDescription;
@property (nonatomic, strong) NSString *locationType;
@property (nonatomic, strong) NSDate *localRegistryDate;
@property (nonatomic, strong) NSDate *nationalRegistryDate;

////////////////////////////////////////////////////////////

- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                 description:(NSString *)description
                        type:(NSString *)type
                 coordinates:(CLLocationCoordinate2D)coordinates
           localRegistryDate:(NSDate *)localRegistryDate
        nationalRegistryDate:(NSDate *)nationalRegistryDate;

////////////////////////////////////////////////////////////

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
