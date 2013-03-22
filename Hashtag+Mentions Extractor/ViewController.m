//
//  ViewController.m
//  Hashtag and Metnions Extractor
//
//  Created by Anton Pavlov on 3/22/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>

@property (nonatomic, strong) Extractor* extractor;

@end

@implementation ViewController
@synthesize input=_input;
@synthesize outputHashtagView=_outputHashtagView;
@synthesize outputMentionsView=_outputMentionsView;
@synthesize extractor=_extractor;
@synthesize hashtagArray=_hashtagArray;
@synthesize mentionsArray=_mentionsArray;
@synthesize spinner=_spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)hideKeyboard:(UIButton *)sender {
    [self.input resignFirstResponder];
    [self.outputHashtagView resignFirstResponder];
    [self.outputMentionsView resignFirstResponder];
}

-(Extractor*)extractor
{
    if (!_extractor)
    {
        _extractor=[[Extractor alloc]init];
        return _extractor;
    }
    return _extractor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.extractor.delegate=self;
    self.input.delegate=self;
    [self.spinner setHidden:YES];
    [self.spinner stopAnimating];
    
}

- (IBAction)extract:(UIButton *)sender {
    
    
    [self.spinner setHidden:NO];
    [self.spinner startAnimating];
    
    NSString *inputString=[self.input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   
    if (self.input.text.length)
    {
    [self.extractor extractHashtags:inputString];
    [self.extractor extractMentions:inputString];

    [self performSelector:@selector(displayExtracted) withObject:self afterDelay:1.0];
        //it takes a second for the extractor to run through the string and extract, which happens on a separate thread, so add a little delay before showing results, otherwise array will initially be null.
    }
}

-(void)displayExtracted
{
    [self.outputHashtagView setText:[NSString stringWithFormat:@"%@", self.hashtagArray]];
    [self.outputMentionsView setText:[NSString stringWithFormat:@"%@", self.mentionsArray]];
    [self.spinner setHidden:YES];
    [self.spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSpinner:nil];
    [super viewDidUnload];
}
@end
