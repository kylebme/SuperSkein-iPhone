//
//  Triangle.m
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import "Triangle.h"


@implementation Triangle
@synthesize x1,x2,x3,y1,y2,y3,z1,z2,z3,xn,yn,zn;

- (id)initWithArray:(NSMutableArray*)pointArray {
	if((self=[super init])) {
		x1 = [[pointArray objectAtIndex:0] floatValue];
		y1 = [[pointArray objectAtIndex:1] floatValue];
		z1 = [[pointArray objectAtIndex:2] floatValue];
		x2 = [[pointArray objectAtIndex:3] floatValue];
		y2 = [[pointArray objectAtIndex:4] floatValue];
		z2 = [[pointArray objectAtIndex:5] floatValue];
		x3 = [[pointArray objectAtIndex:6] floatValue];
		y3 = [[pointArray objectAtIndex:7] floatValue];
		z3 = [[pointArray objectAtIndex:8] floatValue];
		[self Resort];
	}
	return self;
}

- (void)scaleWithFactor:(float)Factor {
	x1 = Factor*x1;
    y1 = Factor*y1;
    z1 = Factor*z1;
    x2 = Factor*x2;
    y2 = Factor*y2;
    z2 = Factor*z2;
    x3 = Factor*x3;
    y3 = Factor*y3;
    z3 = Factor*z3;
}

- (void)translateWithVector:(float*)vector {
	x1=x1+vector[0];
    x2=x2+vector[0];
    x3=x3+vector[0];
    y1=y1+vector[1];
    y2=y2+vector[1];
    y3=y3+vector[1];
    z1=z1+vector[2];
    z2=z2+vector[2];
    z3=z3+vector[2];
}

- (void)rotateZWithRadians:(float)Angle {
    xn = x1*cos(Angle) - y1*sin(Angle);
    yn = x1*sin(Angle) + y1*cos(Angle);
    x1 = xn;
    y1 = yn;
    xn = x2*cos(Angle) - y2*sin(Angle);
    yn = x2*sin(Angle) + y2*cos(Angle);
    x2 = xn;
    y2 = yn;
    xn = x3*cos(Angle) - y3*sin(Angle);
    yn = x3*sin(Angle) + y3*cos(Angle);
    x3 = xn;
    y3 = yn;
    [self Resort];
}

- (void)rotateYWithRadians:(float)Angle {
    xn = x1*cos(Angle) - z1*sin(Angle);
    zn = x1*sin(Angle) + z1*cos(Angle);
    x1 = xn;
    z1 = zn;
    xn = x2*cos(Angle) - z2*sin(Angle);
    zn = x2*sin(Angle) + z2*cos(Angle);
    x2 = xn;
    z2 = zn;
    xn = x3*cos(Angle) - z3*sin(Angle);
    zn = x3*sin(Angle) + z3*cos(Angle);
    x3 = xn;
    z3 = zn;
    [self Resort];
}

- (void)rotateXWithRadians:(float)Angle {
    yn = y1*cos(Angle) - z1*sin(Angle);
    zn = y1*sin(Angle) + z1*cos(Angle);
    y1 = yn;
    z1 = zn;
    yn = y2*cos(Angle) - z2*sin(Angle);
    zn = y2*sin(Angle) + z2*cos(Angle);
    y2 = yn;
    z2 = zn;
    yn = y3*cos(Angle) - z3*sin(Angle);
    zn = y3*sin(Angle) + z3*cos(Angle);
    y3 = yn;
    z3 = zn;
    [self Resort];
}

- (Line2D*)getZIntersectWithLevel:(float)ZLevel {
	Line2D *intersect;
	float xa,xb,ya,yb;
	if(z1<ZLevel) {
		if(z2>ZLevel) {
			xa = x1 + (x2-x1)*(ZLevel-z1)/(z2-z1);
			ya = y1 + (y2-y1)*(ZLevel-z1)/(z2-z1);
			if(z3>ZLevel)
			{
				xb = x1 + (x3-x1)*(ZLevel-z1)/(z3-z1);
				yb = y1 + (y3-y1)*(ZLevel-z1)/(z3-z1);
			}
			else
			{
				xb = x2 + (x3-x2)*(ZLevel-z2)/(z3-z2);
				yb = y2 + (y3-y2)*(ZLevel-z2)/(z3-z2);          
			}
			intersect = [[Line2D alloc] initWithPointOne:CGPointMake(xa, ya) andPointTwo:CGPointMake(xb, yb)];
			return intersect;
		}
		else
		{
			if(z3>ZLevel)
			{
				xa = x1 + (x3-x1)*(ZLevel-z1)/(z3-z1);
				ya = y1 + (y3-y1)*(ZLevel-z1)/(z3-z1);
				xb = x2 + (x3-x2)*(ZLevel-z2)/(z3-z2);
				yb = y2 + (y3-y2)*(ZLevel-z2)/(z3-z2);
				intersect = [[Line2D alloc]initWithPointOne:CGPointMake(xa, ya) andPointTwo:CGPointMake(xb, yb)];
				return intersect;
			}
			else {
				return nil;
			}
		}
	}
	else {
		return nil;
	}
}


- (void)Resort
{
	if(z3<z1)
    {
		xn=x1;
		yn=y1;
		zn=z1;
		x1=x3;
		y1=y3;
		z1=z3;
		x3=xn;
		y3=yn;
		z3=zn;
    }
    if(z2<z1)
    {
		xn=x1;
		yn=y1;
		zn=z1;
		x1=x2;
		y1=y2;
		z1=z2;
		x2=xn;
		y2=yn;
		z2=zn;
    }
    if(z3<z2)
    {
		xn=x3;
		yn=y3;
		zn=z3;
		x3=x2;
		y3=y2;
		z3=z2;
		x2=xn;
		y2=yn;
		z2=zn;
    }
}
	

@end
