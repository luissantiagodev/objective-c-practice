//
//  RegisterEditController.m
//  ObjcPractice
//
//  Created by Luis Santiago on 22/02/21.
//

#import "RegisterEditController.h"
#import "ObjcPractice-Swift.h"
#import "ServerRequest.h"

@interface RegisterEditController ()

@end

@implementation RegisterEditController

    CustomInputField *providerInput;
    CustomInputField *amountInput;
    CustomInputField *commentInput;
    UILabel *labelDatePicker;
    UIDatePicker *datePicker;
    UILabel *labelCurrency;
    UIButton *currencyElectionButton;
    NSString *dateEmitted;
    NSString *currency;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setUpNavbar];
    [self initViews];
    [self setUpViews];
    
    [datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void) onDatePickerValueChanged:(id)sender{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/dd/yyyy"];
    dateEmitted = [df stringFromDate: datePicker.date];
}


-(void) setUpNavbar {
    self.navigationItem.title = @"New Receipt";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed: @"icons8-checkmark-100"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(handleAddButton)];
    
    self.navigationItem.rightBarButtonItem = flipButton;
}


-(void) handleAddButton {
    
    Receipt *receipt = Receipt.new;
    receipt.amount = [NSNumber numberWithInteger: [amountInput.text integerValue]];
    receipt.comment = commentInput.text;
    receipt.emission_date = dateEmitted;
    receipt.provider = providerInput.text;
    
    ServerRequest *sharedManager = [ServerRequest sharedServerRequest];
    
    [sharedManager registerReceipt:receipt :^(NSError * _Nullable error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}



-(void) initViews {
    
    providerInput = [self generateInputTextField: @"Provider"];
    amountInput =[self generateInputTextField: @"Amount"];
    commentInput = [self generateInputTextField: @"Comment"];
    labelDatePicker = [self generateLabel:@"Emission date"];
    currencyElectionButton = [self generateButton:@"Select currency"];

    labelCurrency = [self generateLabel:@"Find Currency"];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setPreferredDatePickerStyle: UIDatePickerStyleWheels];
    datePicker.translatesAutoresizingMaskIntoConstraints = false;
    
    amountInput.keyboardType = UIKeyboardTypeNumberPad;
    
    [currencyElectionButton addTarget:self action:@selector(handleCurrencyButton) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:providerInput];
    [self.view addSubview:amountInput];
    [self.view addSubview:commentInput];
    [self.view addSubview:datePicker];
    [self.view addSubview:labelDatePicker];
    [self.view addSubview:labelCurrency];
    [self.view addSubview:currencyElectionButton];
}

-(void) handleCurrencyButton {
    CurrencyTableTableViewController * tableController = [[CurrencyTableTableViewController alloc] init];
    tableController.modalPresentationStyle = UIModalPresentationFullScreen;
    tableController.listener = self;
    [self.navigationController pushViewController:tableController animated:YES];
}


-(void) setUpViews {
    [NSLayoutConstraint activateConstraints:(@[
        
        [providerInput.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant: 10],
        [providerInput.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10],
        [providerInput.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-10],
        [providerInput.heightAnchor constraintEqualToConstant: 50],
        
        [amountInput.topAnchor constraintEqualToAnchor: providerInput.bottomAnchor constant: 10],
        [amountInput.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10],
        [amountInput.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-10],
        [amountInput.heightAnchor constraintEqualToConstant: 50],
        
        
        [commentInput.topAnchor constraintEqualToAnchor: amountInput.bottomAnchor constant: 10],
        [commentInput.leftAnchor constraintEqualToAnchor: self.view.leftAnchor constant:10],
        [commentInput.rightAnchor constraintEqualToAnchor: self.view.rightAnchor constant:-10],
        [commentInput.heightAnchor constraintEqualToConstant: 50],
        
        
        [labelDatePicker.topAnchor constraintEqualToAnchor: commentInput.bottomAnchor constant: 20],
        [labelDatePicker.leftAnchor constraintEqualToAnchor: self.view.leftAnchor constant: 20],
        [labelDatePicker.rightAnchor constraintEqualToAnchor: self.view.rightAnchor constant: -5],
        
        [datePicker.topAnchor constraintEqualToAnchor: labelDatePicker.bottomAnchor],
        [datePicker.leftAnchor constraintEqualToAnchor: self.view.leftAnchor constant: 5],
        [datePicker.rightAnchor constraintEqualToAnchor: self.view.rightAnchor constant: -5],
        [datePicker.heightAnchor constraintEqualToAnchor: self.view.heightAnchor multiplier: 0.3],
        
        
        [labelCurrency.topAnchor constraintEqualToAnchor: datePicker.bottomAnchor],
        [labelCurrency.leftAnchor constraintEqualToAnchor: self.view.leftAnchor constant: 20],
        [labelCurrency.rightAnchor constraintEqualToAnchor: self.view.rightAnchor constant: -20],
        
        
        [currencyElectionButton.topAnchor constraintEqualToAnchor: labelCurrency.bottomAnchor constant: 10 ],
        [currencyElectionButton.leftAnchor constraintEqualToAnchor: self.view.leftAnchor constant: 20],
        [currencyElectionButton.rightAnchor constraintEqualToAnchor: self.view.rightAnchor constant: -20],
        [currencyElectionButton.heightAnchor constraintEqualToConstant: 50],
        
    ])];
}


- (CustomInputField *) generateInputTextField : (NSString*)placeHolderText {
    
    CustomInputField *textfield = CustomInputField.new;
    textfield.translatesAutoresizingMaskIntoConstraints = false;
    textfield.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha: 1.00];
    
    UIColor *color = [UIColor colorWithRed: 0.76 green:0.78 blue:0.82 alpha: 1.00];
    
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color };
    
    NSAttributedString *atribute = [[NSAttributedString alloc] initWithString:placeHolderText attributes:attrs];
    
    textfield.attributedPlaceholder = atribute;
    return textfield;
}


- (UILabel *) generateLabel : (NSString*)textToShow {
    
    UILabel *label = UILabel.new;
    label.translatesAutoresizingMaskIntoConstraints = false;
    label.backgroundColor = UIColor.whiteColor;
    label.text = textToShow;
    [label sizeToFit];
    return label;
}



- (UIButton *) generateButton : (NSString*)textToShow {
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = false;
    button.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha: 1.00];
    [button setTitle:textToShow forState:UIControlStateNormal];
    button.contentHorizontalAlignment = NSLayoutAttributeLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    return button;
}

- (void)onCurrencySelectedWithCountry:(Country *)country {
    [currencyElectionButton setTitle: country.currency forState: UIControlStateNormal];
    currency = country.currency;
}

@end
