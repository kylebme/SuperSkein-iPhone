//
//  Line2D.h
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import <Foundation/Foundation.h>


@interface Line2D : NSObject {
	CGPoint theFirstPoint, theSecondPoint;
}

- (id)initWithPointOne:(CGPoint)pointOne andPointTwo:(CGPoint)pointTwo;
- (void)scaleWithFactor:(float)factor;
- (void)flip;
- (void)rotateWithRadians:(float)angle;

@property (nonatomic) CGPoint theFirstPoint, theSecondPoint;

@end
