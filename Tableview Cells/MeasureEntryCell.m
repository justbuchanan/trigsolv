//
//  MeasureEntryCell.m
//  Shape Master
//
//  Created by Justin Buchanan on 9/22/08.
//  Copyright 2008 JustBuchanan Enterprises. All rights reserved.
//

#import "MeasureEntryCell.h"
#import "MeasureEntryViewController.h"
#import "ShapeController.h"

@implementation MeasureEntryCell

@synthesize textField;
@synthesize measureEntryController;
@synthesize key;

- (id)initWithMeasureEntryViewController:(MeasureEntryViewController *)viewController key:(NSString *)theKey
{
	if ( self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] )
	{
		measureEntryController = viewController;
		key = [theKey retain];
		
		self.accessoryType = UITableViewCellAccessoryNone;
		self.textLabel.textColor = MEASURE_NAME_COLOR;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		textField = [[UITextField alloc] initWithFrame:CGRectZero];
		textField.borderStyle = UITextBorderStyleNone;
		textField.textColor = MEASURE_VALUE_COLOR;
		textField.delegate = self;
		textField.enabled = YES;
		textField.returnKeyType = UIReturnKeyDone;
		textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		textField.adjustsFontSizeToFitWidth = YES;
		textField.minimumFontSize = 1;
		textField.textAlignment = UITextAlignmentRight;
		[self addSubview:textField];
		[textField release];
		
		NSString *value = [self.measureEntryController.shapeController.measureValues objectForKey:self.key];
		textField.text = ( [value isEqualToString:@""] ) ? @" " : value;
		self.textLabel.text = NSLocalizedString( key, nil );
		
	}
	return self;
}

- (void)dealloc
{
	//the text field is owned as a subview, so we don't need to seperately release it here
	[key release];
	[super dealloc];
}


/*
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[[UIColor redColor] set];
	CGContextFillRect(context, self.contentView.frame);
}

*/



- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect textFieldFrame;
	textFieldFrame.size.width = self.bounds.size.width - MEASURE_NAME_WIDTH - CELL_ACCESSORY_VIEW_OFFSET;
	textFieldFrame.size.height = MEASURE_VALUE_LABEL_HEIGHT;
	textFieldFrame.origin.x = MEASURE_NAME_WIDTH;
	textFieldFrame.origin.y = 11;
	textField.frame = textFieldFrame;
	
	
	
	CGPoint center = self.textLabel.center;
	center.y = self.contentView.bounds.size.height / 2;
	self.textLabel.center = center;
}



#pragma mark Text Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
	[theTextField resignFirstResponder];
	[self.measureEntryController.navigationController popViewControllerAnimated:YES];
	
	return YES;
}


- (void)userFinishedEditingTextField
{
	//This method is called when the user is finished editing the cell.  The sender is the notification center.  
	//The notification is posted by the navigation controller that owns the measureentryviewcontroller.
	
	NSMutableString *string = [[NSMutableString alloc] initWithString:self.textField.text];
	NSString *allowedCharacters = [[NSString alloc] initWithString:@".0123456789"];
	
	int stringIndex = 0;
	short int allowedCharacterIndex = 0;
	int dotCount = 0;

	BOOL stringDidChange = NO;

	while ( stringIndex < [string length] ) {
		allowedCharacterIndex = 0;
	
		while ( YES ) {
			if ( allowedCharacterIndex == 11 ) {
				[string deleteCharactersInRange:NSMakeRange(stringIndex, 1)];
				stringDidChange = YES;
				break;
			}
			
			if ( [string characterAtIndex:stringIndex] == [allowedCharacters characterAtIndex:allowedCharacterIndex] ) {
				if ( [string characterAtIndex:stringIndex] == '.' ) {
					if ( dotCount > 0 ) {
						[string deleteCharactersInRange:NSMakeRange(stringIndex, 1)];
						stringDidChange = YES;
						break;
					} else {
						++dotCount;
						++stringIndex;
					}
				} else {
					++stringIndex;
				}
				
				break;
			} else { 
				++allowedCharacterIndex;
			}
		}

	}
	
	[allowedCharacters release];
	
	[self.measureEntryController userFinishedEnteringValue:string forKey:self.key];
	[self.textField resignFirstResponder];
	[string release];
}


@end
