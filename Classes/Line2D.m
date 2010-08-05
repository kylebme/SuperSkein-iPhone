//
//  Line2D.m
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import "Line2D.h"


@implementation Line2D

@synthesize theFirstPoint, theSecondPoint;

- (id)initWithPointOne:(CGPoint)pointOne andPointTwo:(CGPoint)pointTwo {
	if((self=[super init])) {
		theFirstPoint = pointOne;
		theSecondPoint = pointTwo;
	}
	return self;
}

- (void)scaleWithFactor:(float)factor {
	theFirstPoint = CGPointMake(theFirstPoint.x*factor, theFirstPoint.y*factor);
	theSecondPoint = CGPointMake(theSecondPoint.x*factor, theSecondPoint.y*factor);
}

- (void)flip {
	float xn, yn;
	xn = theFirstPoint.x;
	yn = theFirstPoint.y;
	theFirstPoint = CGPointMake(theSecondPoint.x, theSecondPoint.y);
	theSecondPoint = CGPointMake(xn, yn);
}

- (void)rotateWithRadians:(float)angle {
	float xn, yn;
	float cosofan = cos(angle);
	float sinofan = sin(angle);
	xn = theFirstPoint.x*cosofan - theFirstPoint.y*sinofan;
	yn = theFirstPoint.x*sinofan + theFirstPoint.y*cosofan;
	theFirstPoint = CGPointMake(xn, yn);
	xn = theSecondPoint.x*cosofan - theSecondPoint.y*sinofan;
	yn = theSecondPoint.x*sinofan + theSecondPoint.y*cosofan;
	theSecondPoint = CGPointMake(xn, yn);
}

@end
