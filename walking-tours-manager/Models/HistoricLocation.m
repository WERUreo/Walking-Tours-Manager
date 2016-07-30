//
//  HistoricLocation.m
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/30/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import "HistoricLocation.h"

@implementation HistoricLocation

- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                 description:(NSString *)description
                        type:(NSString *)type
                 coordinates:(CLLocationCoordinate2D)coordinates
{
    self = [super init];
    if (self)
    {
        self.locationName = name;
        self.locationAddress = address;
        self.locationDescription = description;
        self.locationType = type;
        self.locationCoordinates = coordinates;
    }

    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (self)
    {
        self.locationName = [json objectForKey:@"name"];
        self.locationAddress = [json objectForKey:@"address"];
        self.locationDescription = [json objectForKey:@"description"];
        self.locationType = [json objectForKey:@"type"];
        self.locationCoordinates = CLLocationCoordinate2DMake([[[json objectForKey:@"location"] objectForKey:@"latitude"] doubleValue], [[[json objectForKey:@"location"] objectForKey:@"longitude"] doubleValue]);
    }

    return self;
}
@end
