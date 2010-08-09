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
#import "ChooseFileController.h"

@interface SuperSkein_iPhoneViewController : UIViewController {
	IBOutlet UITextField *feedratefield, *layerheightfield, *sinkfield, *prescalefield, *zfeedratefield;
	IBOutlet UIViewController *startController, *endController;
	IBOutlet UITextView *startTextView, *endTextView;
	IBOutlet ChooseFileController *theFilePicker;
	int t;
	float tfloat;
	Mesh *STLFile;
	float MeshHeight;
	Slice *theSlice;
	NSString *selectedFilePath;
}

- (IBAction)chooseFile;
- (IBAction)cancelFilePicker;
- (IBAction)skeinIt;
- (IBAction)editStartText;
- (IBAction)editEndText;
- (IBAction)saveStartAndEnd;
- (void)saveFileSelectionWithFilepath:(NSString *)path;
//- (NSString*)cleanFloat:(float)theFloat;

@end

