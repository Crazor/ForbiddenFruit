//
//  Constants.m
//  ForbiddenFruit
//
//  Created by Crazor on 22.03.13.
//  Copyright (c) 2013 Crazor. All rights reserved.
//

#import "Constants.h"

NSString *const DefaultKeyID = @"keyID";
NSString *const DefaultVCode = @"vCode";

NSString *const AccountAPIURL = @"https://api.eveonline.com/account/AccountStatus.xml.aspx?keyID=%@&vCode=%@";
NSString *const CharacterAPIURL = @"https://api.eveonline.com/account/Characters.xml.aspx?keyID=%@&vCode=%@";
NSString *const CharacterInfoAPIURL = @"https://api.eveonline.com/eve/CharacterInfo.xml.aspx?keyID=%%@&vCode=%%@&characterID=%@";
NSString *const WalletJournalAPIURL = @"https://api.eveonline.com/char/WalletJournal.xml.aspx?keyID=%%@&vCode=%%@&characterID=%@";
NSString *const RefTypesAPIURL = @"https://api.eveonline.com/eve/RefTypes.xml.aspx";
