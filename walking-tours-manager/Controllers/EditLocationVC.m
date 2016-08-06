//
//  EditLocationVC.m
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/31/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import "EditLocationVC.h"
#import "DataService.h"
@import GooglePlaces;

@interface EditLocationVC () <GMSAutocompleteViewControllerDelegate>

////////////////////////////////////////////////////////////
#pragma mark - IBOutlets
////////////////////////////////////////////////////////////

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation EditLocationVC

////////////////////////////////////////////////////////////
#pragma mark - View Controller Life Cycle
////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self populateViewWithLocation:self.location];
}

////////////////////////////////////////////////////////////
#pragma mark - IBActions
////////////////////////////////////////////////////////////

- (IBAction)saveLocationTapped:(id)sender
{
    HistoricLocation *location = [[HistoricLocation alloc] initWithName:self.nameTextField.text
                                                                address:self.addressTextField.text
                                                            description:self.descriptionTextView.text
                                                                   type:[self getLocationTypeFromSegmentedControl]
                                                            coordinates:CLLocationCoordinate2DMake([self.latitudeTextField.text doubleValue], [self.longitudeTextField.text doubleValue])
                                                      localRegistryDate:nil
                                                   nationalRegistryDate:nil];
    [[DataService sharedInstance] saveLocation:location inCity:self.city];
    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////

- (IBAction)searchButtonTapped:(id)sender
{
    GMSAutocompleteViewController *acViewController = [[GMSAutocompleteViewController alloc] init];
    acViewController.delegate = self;
    [self presentViewController:acViewController animated:YES completion:nil];
}

////////////////////////////////////////////////////////////
#pragma mark - Helper Functions
////////////////////////////////////////////////////////////

- (NSInteger)setSelectedIndex:(NSString *)locationType
{
    if ([locationType isEqualToString:@"Building"])
    {
        return 0;
    }
    else if ([locationType isEqualToString:@"Sign"])
    {
        return 1;
    }
    else if ([locationType isEqualToString:@"Park"])
    {
        return 2;
    }

    return 0;
}

////////////////////////////////////////////////////////////

- (NSString *)getLocationTypeFromSegmentedControl
{
    switch (self.typeSegmentedControl.selectedSegmentIndex)
    {
        case 0:
            return @"Building";
        case 1:
            return @"Sign";
        case 2:
            return @"Park";
        default:
            return @"Building";
    }
}

////////////////////////////////////////////////////////////

- (void)populateViewWithLocation:(HistoricLocation *)location
{
    CLLocationCoordinate2D centerCoordinate = (location) ? location.coordinate : self.startingCoordinates;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1000, 1000);
    [self.mapView setRegion:region];

    if (location)
    {
        self.nameTextField.text = location.title;
        self.addressTextField.text = location.subtitle;
        self.descriptionTextView.text = location.locationDescription;
        self.typeSegmentedControl.selectedSegmentIndex = [self setSelectedIndex:location.locationType];
        self.latitudeTextField.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        self.longitudeTextField.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];

        [self.mapView addAnnotation:location];
    }
}

////////////////////////////////////////////////////////////
#pragma mark - GMSAutocompleteViewControllerDelegate
////////////////////////////////////////////////////////////

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place
{
    HistoricLocation *location = [[HistoricLocation alloc] initWithName:place.name
                                                                address:place.formattedAddress
                                                            description:@"TBD"
                                                                   type:@"Building"
                                                            coordinates:place.coordinate
                                                      localRegistryDate:nil
                                                   nationalRegistryDate:nil];
    [self populateViewWithLocation:location];

    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);
    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
