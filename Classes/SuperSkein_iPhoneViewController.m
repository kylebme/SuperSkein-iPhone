//
//  SuperSkein_iPhoneViewController.m
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import "SuperSkein_iPhoneViewController.h"

@implementation SuperSkein_iPhoneViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// Check the saved defaults to see if there is anything there and if there is fill up the text fields with the saved content
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	float tempfeedrate = [defaults floatForKey:@"feedrate"];
	if(tempfeedrate == 0) [defaults setFloat:3600 forKey:@"feedrate"];
	else feedratefield.text = [NSString stringWithFormat:@"%f",tempfeedrate];
	
	float templayerthickness = [defaults floatForKey:@"layerthickness"];
	if(templayerthickness == 0) [defaults setFloat:0.25 forKey:@"layerthickness"];
	else layerheightfield.text = [NSString stringWithFormat:@"%f",templayerthickness];
	
	float tempzfeedrate = [defaults floatForKey:@"zfeedrate"];
	if(tempzfeedrate == 0) [defaults setFloat:150 forKey:@"zfeedrate"];
	else zfeedratefield.text = [NSString stringWithFormat:@"%f",tempzfeedrate];
	
	float tempprescale = [defaults floatForKey:@"prescale"];
	if(tempprescale == 0) [defaults setFloat:1.0 forKey:@"prescale"];
	else prescalefield.text = [NSString stringWithFormat:@"%f", tempprescale];
	
	sinkfield.text = [NSString stringWithFormat:@"%f", [defaults floatForKey:@"sink"]];
	
	t=0;
	tfloat=0;
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (IBAction)skeinIt {
	// If they haven't selected a file yet, then get mad and escape.
	if(!selectedFilePath) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No File Selected!" message:@"You must first select a file to skein!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableString *theFileContents = [[NSMutableString alloc] initWithCapacity:1];
	float layerThickness = [defaults floatForKey:@"layerthickness"];
	float feedRate = [defaults floatForKey:@"feedrate"];
	float ZFeedRate = [defaults floatForKey:@"zfeedrate"];
	NSLog(@"Loading STL file...\n");
	STLFile = [[Mesh alloc] initWithFile:selectedFilePath];
	float prescale = [defaults floatForKey:@"prescale"];
	if(prescale!=0) [STLFile scaleWithFactor:abs(prescale)];
	float tempAr[3] = {0,0,-STLFile.bz1};
	float tempAr2[3] = {0,0,-layerThickness};
	float tempAr3[3] = {0,0,-[defaults floatForKey:@"sink"]};
	[STLFile translateWithVector:tempAr];
	[STLFile translateWithVector:tempAr2];
	[STLFile translateWithVector:tempAr3];
	[theFileContents appendString:[defaults stringForKey:@"starttext"]];
	int Layers = (int)(STLFile.bz2/layerThickness);
	float ZLevel;
	for(ZLevel = 0; ZLevel<(STLFile.bz2-layerThickness); ZLevel+=layerThickness) {
		theSlice = [[Slice alloc] initWithMesh:STLFile andZLevel:ZLevel];
		int j;
		Line2D * lin = [theSlice.Lines objectAtIndex:0];
		[theFileContents appendFormat:@"G1 X%f Y%f Z%f F%f\n", lin.theFirstPoint.x, lin.theFirstPoint.y, ZLevel, ZFeedRate];
		for(j = 0; j<theSlice.Lines.count; j++) {
			lin = [theSlice.Lines objectAtIndex:j];
			[theFileContents appendFormat:@"G1 X%f Y%f Z%f F%f\n", lin.theSecondPoint.x, lin.theSecondPoint.y, ZLevel, feedRate];
		}
		[theSlice release];
	}
	[theFileContents appendString:[defaults stringForKey:@"endtext"]];
	[theFileContents writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"output.gcode"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished!" message:[NSString stringWithFormat:@"Finished slicing all %i layers", Layers] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)saveFileSelectionWithFilepath:(NSString*)path {
	selectedFilePath = path;
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)chooseFile {
	[self presentModalViewController:theFilePicker animated:YES];
}

- (IBAction)cancelFilePicker {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)editStartText {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	startTextView.text = [defaults stringForKey:@"starttext"];
	[self presentModalViewController:startController animated:YES];
	[startTextView becomeFirstResponder];
}

- (IBAction)editEndText {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	endTextView.text = [defaults stringForKey:@"endtext"];
	[self presentModalViewController:endController animated:YES];
	[endTextView becomeFirstResponder];
}

- (IBAction)saveStartAndEnd {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:startTextView.text forKey:@"starttext"];
	[defaults setObject:endTextView.text forKey:@"endtext"];
	[defaults synchronize];
	[self dismissModalViewControllerAnimated:YES];
}

// I can't figure out how to display a float without all those pesky zeros at the end.
// I tried to write this algorithm to detect the extent of the zeros at the end then round that far and display it as 2 numbers divided by the decimal point.
// Doesn't work yet though...
/*
- (NSString*)cleanFloat:(float)theFloat {
	int leftOfDecimal = (int)theFloat;
	float rightOfDecimal = theFloat-(float)leftOfDecimal;
	int multiplier = 1000000;
	int lastTested;
	while(multiplier>0) {
		int subtractor = rightOfDecimal*(multiplier/10);
		subtractor*=10;
		float testedNum = rightOfDecimal*multiplier-subtractor;
		multiplier/=10;
		if((int)lastTested==0&&testedNum!=0) break;
		lastTested = testedNum;
	}
	return [NSString stringWithFormat:@"%i.%i", leftOfDecimal, (int)(rightOfDecimal*multiplier/100)];
}*/

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	[textField resignFirstResponder];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat:[layerheightfield.text floatValue] forKey:@"layerthickness"];
	[defaults setFloat:[feedratefield.text floatValue] forKey:@"feedrate"];
	[defaults setFloat:[zfeedratefield.text floatValue] forKey:@"zfeedrate"];
	[defaults setFloat:[prescalefield.text floatValue] forKey:@"prescale"];
	[defaults setFloat:[sinkfield.text floatValue] forKey:@"sink"];
	[defaults synchronize];
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	if(STLFile) [STLFile release];
}

@end
