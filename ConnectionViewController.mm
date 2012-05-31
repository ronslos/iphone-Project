//
//  ConnectionViewController.m
//  3d_visioin
//
//  Created by Ron Slossberg on 4/30/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import "ConnectionViewController.h"
#import "MainMenuViewController.h"

@interface ConnectionViewController ()

@end

@implementation ConnectionViewController

@synthesize session;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    peerPicker =  [[GKPeerPickerController alloc] init];
	peerPicker.delegate = self;
	
	//There are 2 modes of connection type 
	// - GKPeerPickerConnectionTypeNearby via BlueTooth
	// - GKPeerPickerConnectionTypeOnline via Internet
	// We will use Bluetooth Connectivity for this example
	
	peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	peers=[[NSMutableArray alloc] init];
	
	// Create the buttons
	UIButton *btnConnect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnConnect addTarget:self action:@selector(connectToPeers:) forControlEvents:UIControlEventTouchUpInside];
	[btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
	btnConnect.frame = CGRectMake(20, 100, 280, 30);
	btnConnect.tag = 12;
	[self.view addSubview:btnConnect];
    
}

- (void) connectToPeers:(id) sender
{
	[peerPicker show];
}

- (void) sendDataToPeers:(id) sender WithData:(NSData*) data 
{
	// Send the fart to Peers using teh current sessions
	[session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:nil];
}

- (void) sendClick:(id) sender 
{
    NSString* capture = @"YES";
	// Send the fart to Peers using teh current sessions
    NSMutableData *data = [NSMutableData new];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:capture forKey:@"capture"];
    [archiver release];
    [session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:nil];
    [data release];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark GKPeerPickerControllerDelegate

// This creates a unique Connection Type for this particular applictaion
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	// Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
	GKSession* session = [[GKSession alloc] initWithSessionID:@"CalibrationSession" displayName:nil sessionMode:GKSessionModePeer];
    return [session autorelease];
}

// Tells us that the peer was connected
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	
	// Get the session and assign it locally
    self.session = session;
    session.delegate = self;
    
    //No need of the picekr anymore
	picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
}


// Function to receive data when sent from peer
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
}

#pragma mark -
#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    
	if(state == GKPeerStateConnected){
		// Add the peer to the Array
		[peers addObject:peerID];
        
		NSString *str = [NSString stringWithFormat:@"Connected with %@",[self.session displayNameForPeer:peerID]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		// Used to acknowledge that we will be sending data
		[self.session setDataReceiveHandler:self withContext:nil];
		
		[[self.view viewWithTag:12] removeFromSuperview];       
        
	}
	
}


@end
