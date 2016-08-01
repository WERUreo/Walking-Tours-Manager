//
//  EditLocationVC.h
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/31/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoricLocation.h"

@interface EditLocationVC : UIViewController

@property (nonatomic, strong) HistoricLocation *location;
@property (nonatomic) CLLocationCoordinate2D startingCoordinates;

@end
