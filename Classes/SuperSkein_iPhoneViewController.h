//
//  SuperSkein_iPhoneViewController.h
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import <UIKit/UIKit.h>
#import "Slice.h"
#import "Mesh.h"
#import "Triangle.h"
#import "Line2D.h"
#import "Everything.h"

@interface SuperSkein_iPhoneViewController : UIViewController {
	IBOutlet UITextField *feedratefield, *layerheightfield, *sinkfield, *prescalefield, *zfeedratefield;
	int t;
	float tfloat;
	Mesh *STLFile;
	float MeshHeight;
	Slice *theSlice;
}

- (IBAction)chooseFile;
- (IBAction)skeinIt;

@end

