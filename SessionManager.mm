//
//  SessionManager.m
//  3d_visioin
//
//  Created by Ron Slossberg on 4/30/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager
@synthesize mySession;

static SessionManager *gInstance = NULL;

+ (SessionManager *)instance
{
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    
    return(gInstance);
}

- (void) initializeSession
{
    peerPicker =  [[GKPeerPickerController alloc] init];
    peerPicker.delegate = self;

    peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    peers=[[NSMutableArray alloc] init];
    [peerPicker show];
}

- (void) sendDataToPeers:(id) sender WithData:(NSData*) data 
{
	// Send the fart to Peers using teh current sessions
	[mySession sendData:data toPeers:peers withDataMode:GKSendDataReliable error:nil];
}

- (void) sendClick:(id) sender;
{
    
    NSString *str = @"capture";
	[mySession sendDataToAllPeers:[str dataUsingEncoding: NSASCIIStringEncoding] withDataMode:GKSendDataReliable error:nil];
	
}

-(void) dealloc
{
    [mySession release];
    [super dealloc];
}

#pragma mark -
#pragma mark GKPeerPickerControllerDelegate

// This creates a unique Connection Type for this particular applictaion
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	// Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
	GKSession* session = [[GKSession alloc] initWithSessionID:@"com.Calib.session" displayName:nil sessionMode:GKSessionModePeer];
    return [session autorelease];
}

// Tells us that the peer was connected
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	
	// Get the session and assign it locally
	session.delegate = self;
	//[session setDataReceiveHandler:self withContext:nil];
	self.mySession = session;
    
    //No need of the picekr anymore
	picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
}


// Function to receive data when sent from peer
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{   
    NSString *whatDidIget = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Received" message:whatDidIget delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[whatDidIget release];
}

#pragma mark -
#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    
	if(state == GKPeerStateConnected){
		// Add the peer to the Array
		[peers addObject:peerID];
        
		NSString *str = [NSString stringWithFormat:@"Connected with %@",[mySession displayNameForPeer:peerID]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		// Used to acknowledge that we will be sending data
		//[mySession setDataReceiveHandler:self withContext:nil];
		      
        
	}
	
}



@end
