//
//  TicketTableViewCell.h
//  Tickets_objective-c
//
//  Created by Александр Ипатов on 29.01.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "Ticket.h"
#import "TicketFavourite+CoreDataClass.h"
NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell
@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) TicketFavourite *favoriteTicket;
@end


NS_ASSUME_NONNULL_END
