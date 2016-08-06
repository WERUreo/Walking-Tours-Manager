//
//  MapVC.h
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/30/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoricLocation.h"
@import MapKit;

@interface MapVC : UIViewController <MKMapViewDelegate>

- (IBAction)citySelected:(id)sender;

@end
