//
//  NSString + Localize.m
//  Tickets_objective-c
//
//  Created by Александр Ипатов on 06.02.2021.
//

#import "NSString + Localize.h"

@implementation NSString (Localize)

- (NSString *)localize {
    return NSLocalizedString(self, "");
}

@end

