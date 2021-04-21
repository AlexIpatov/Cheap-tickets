//
//  TicketFavourite+CoreDataProperties.h
//  Tickets_objective-c
//
//  Created by Александр Ипатов on 01.02.2021.
//
//

#import "TicketFavourite+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TicketFavourite (CoreDataProperties)

+ (NSFetchRequest<TicketFavourite *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate* departure;
@property (nullable, nonatomic, copy) NSDate *expires;
@property (nonatomic) int16_t flightNumber;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *to;
@property (nonatomic) int64_t price;
@property (nullable, nonatomic, copy) NSDate *returnDate;

@end

NS_ASSUME_NONNULL_END
