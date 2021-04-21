//
//  MainViewController.m
//  Tickets_objective-c
//
//  Created by Александр Ипатов on 29.01.2021.
//

#import "MainViewController.h"
#import "DataManager.h"
#import "PlaceViewController.h"
#import "APIManager.h"
#import "TicketsViewController.h"
#import "ProgressView.h"
#import "FirstViewController.h"


@interface MainViewController ()

@property (nonatomic, strong) UIView *placeContainerView;
@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation MainViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self presentFirstViewControllerIfNeeded];
}


- (void)presentFirstViewControllerIfNeeded
{
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
    if (!isFirstStart) {
        FirstViewController *firstViewController = [[FirstViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        firstViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:firstViewController animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataManager sharedInstance] loadData];
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.title = NSLocalizedString(@"search_tab", "");
        
        _placeContainerView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 140.0, [UIScreen mainScreen].bounds.size.width - 40.0, 170.0)];
        _placeContainerView.backgroundColor = [UIColor whiteColor];
        _placeContainerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        _placeContainerView.layer.shadowOffset = CGSizeZero;
        _placeContainerView.layer.shadowRadius = 20.0;
        _placeContainerView.layer.shadowOpacity = 1.0;
        _placeContainerView.layer.cornerRadius = 6.0;
        
        _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_departureButton setTitle:NSLocalizedString(@"main_from", "") forState: UIControlStateNormal];
        _departureButton.tintColor = [UIColor blackColor];
        _departureButton.frame = CGRectMake(10.0, 20.0, _placeContainerView.frame.size.width - 20.0, 60.0);
        _departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
        _departureButton.layer.cornerRadius = 4.0;
        [_departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.placeContainerView addSubview:_departureButton];
        
        _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_arrivalButton setTitle:NSLocalizedString(@"main_to", "") forState: UIControlStateNormal];
        _arrivalButton.tintColor = [UIColor blackColor];
        _arrivalButton.frame = CGRectMake(10.0, CGRectGetMaxY(_departureButton.frame) + 10.0, _placeContainerView.frame.size.width - 20.0, 60.0);
        _arrivalButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
        _arrivalButton.layer.cornerRadius = 4.0;
        [_arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.placeContainerView addSubview:_arrivalButton];
        
        [self.view addSubview:_placeContainerView];
        
        _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_searchButton setTitle:NSLocalizedString(@"main_search", "") forState:UIControlStateNormal];
        _searchButton.tintColor = [UIColor whiteColor];
        _searchButton.frame = CGRectMake(30.0, CGRectGetMaxY(_placeContainerView.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
        _searchButton.backgroundColor = [UIColor blackColor];
        _searchButton.layer.cornerRadius = 8.0;
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
        [_searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_searchButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    }

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)searchButtonDidTap:(UIButton *)sender {
    if (_searchRequest.origin && _searchRequest.destionation) {
        [[ProgressView sharedInstance] show:^{
            
            [[APIManager sharedInstance] ticketsWithRequest:self->_searchRequest withCompletion:^(NSArray *tickets) {
                
                [[ProgressView sharedInstance] dismiss:^{
                    if (tickets.count > 0) {
                        TicketsViewController *ticketsViewController = [[TicketsViewController alloc] initWithTickets:tickets];
                        [self.navigationController showViewController:ticketsViewController sender:self];
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"oops", "") message:NSLocalizedString(@"tickets_not_found", "") preferredStyle: UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"close", "") style:(UIAlertActionStyleDefault) handler:nil]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }];
            }];
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error", "") message:NSLocalizedString(@"not_set_place_arrival_or_departure", "") preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"close", "") style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



- (void)dataLoadedSuccessfully {
    [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
        [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self->_departureButton];
    }];
}



    - (void)placeButtonDidTap:(UIButton *)sender {
        PlaceViewController *placeViewController;
        if ([sender isEqual:_departureButton]) {
            placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
        } else {
            placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeArrival];
        }
        placeViewController.delegate = self;
        [self.navigationController pushViewController: placeViewController animated:YES];
    }
    #pragma mark - PlaceViewControllerDelegate

    - (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
        [self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceTypeDeparture) ? _departureButton : _arrivalButton ];
    }

    - (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {
        NSString *title;
        NSString *iata;
        if (dataType == DataSourceTypeCity) {
            City *city = (City *)place;
            title = city.name;
            iata = city.code;
        }
        else if (dataType == DataSourceTypeAirport) {
            Airport *airport = (Airport *)place;
            title = airport.name;
            iata = airport.cityCode;
        }
        if (placeType == PlaceTypeDeparture) {
            _searchRequest.origin = iata;
        } else {
            _searchRequest.destionation = iata;
        }
        [button setTitle: title forState: UIControlStateNormal];
    }


@end
