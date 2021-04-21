//
//  ContentViewController.h
//  Tickets_objective-c
//
//  Created by Александр Ипатов on 04.02.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentViewController : UIViewController
    @property (nonatomic, strong) NSString *contentText;
    @property (nonatomic, strong) UIImage *image;
    @property (nonatomic) int index;
@end

NS_ASSUME_NONNULL_END

