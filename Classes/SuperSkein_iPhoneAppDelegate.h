//
//  SuperSkein_iPhoneAppDelegate.h
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import <UIKit/UIKit.h>

@class SuperSkein_iPhoneViewController;

@interface SuperSkein_iPhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SuperSkein_iPhoneViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SuperSkein_iPhoneViewController *viewController;

@end

