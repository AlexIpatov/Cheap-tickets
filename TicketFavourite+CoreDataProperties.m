//
//  TicketFavourite+CoreDataProperties.m
//  Tickets_objective-c
//
//  Created by Александр Ипатов on 01.02.2021.
//
//

#import "TicketFavourite+CoreDataProperties.h"

@implementation TicketFavourite (CoreDataProperties)

+ (NSFetchRequest<TicketFavourite *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TicketFavourite"];
}

@dynamic airline;
@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic flightNumber;
@dynamic from;
@dynamic to;
@dynamic price;
@dynamic returnDate;

@end
