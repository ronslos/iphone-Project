//
//  ConnectionViewController.h
//  3d_visioin
//
//  Created by Ron Slossberg on 4/30/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
@interface ConnectionViewController : UIViewController<GKSessionDelegate, GKPeerPickerControllerDelegate>
{
//session Object
GKSession *session;
// PeerPicker Object
GKPeerPickerController *peerPicker;
// Array of peers connected
NSMutableArray *peers;
}

@property (retain) GKSession *session;

// 4.  Methods to connect and send data
- (void) connectToPeers:(id) sender;
- (void) sendDataToPeers:(id) sender WithData:(NSData*) data ;

@end
