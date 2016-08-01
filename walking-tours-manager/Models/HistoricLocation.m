//
//  HistoricLocation.m
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/30/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import "HistoricLocation.h"

@implementation HistoricLocation

////////////////////////////////////////////////////////////
#pragma mark - Initializers
////////////////////////////////////////////////////////////

- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                 description:(NSString *)description
                        type:(NSString *)type
                 coordinates:(CLLocationCoordinate2D)coordinates
           localRegistryDate:(NSDate *)localRegistryDate
        nationalRegistryDate:(NSDate *)nationalRegistryDate
{
    self = [super init];
    if (self)
    {
        self.locationName = name;
        self.locationAddress = address;
        self.locationDescription = description;
        self.locationType = type;
        self.locationCoordinates = coordinates;
        self.localRegistryDate = localRegistryDate;
        self.nationalRegistryDate = nationalRegistryDate;
    }

    return self;
}

////////////////////////////////////////////////////////////

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

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.sss";
        self.localRegistryDate = [formatter dateFromString:[json objectForKey:@"localRegistryDate"]];
        self.nationalRegistryDate = [formatter dateFromString:[json objectForKey:@"nationalRegistryDate"]];
    }

    return self;
}

@end
