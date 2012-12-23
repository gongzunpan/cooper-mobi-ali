//
//  DateTextField.h
//  CooperNative
//
//  Created by sunleepy on 12-12-23.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@class DateTextField;

@protocol DateTextFieldDelegate <NSObject>
@optional
- (void)tableViewCell:(DateTextField *)textField didEndEditingWithDate:(NSDate *)value;
@end

@interface DateTextField : UITextField<UIPopoverControllerDelegate>
{
    UIPopoverController *popoverController;
	UIToolbar *inputAccessoryView;
}

@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (strong) IBOutlet id<DateTextFieldDelegate> delegate;

- (void)setMaxDate:(NSDate *)max;
- (void)setMinDate:(NSDate *)min;
- (void)setMinuteInterval:(NSUInteger)value;
@end
