/*
 * This file is part of ForbiddenFruit.
 *
 * Copyright 2013 Crazor <crazor@gmail.com>
 *
 * ForbiddenFruit is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * ForbiddenFruit is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with ForbiddenFruit.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "Constants.h"

NSString *const DefaultApiKeyArray = @"ApiKeys";
NSString *const DefaultAccountName = @"name";
NSString *const DefaultKeyID = @"keyID";
NSString *const DefaultVCode = @"vCode";

NSString *const AccountAPIURL = @"https://api.eveonline.com/account/AccountStatus.xml.aspx?keyID=%@&vCode=%@";
NSString *const CharacterAPIURL = @"https://api.eveonline.com/account/Characters.xml.aspx?keyID=%@&vCode=%@";
NSString *const CharacterInfoAPIURL = @"https://api.eveonline.com/eve/CharacterInfo.xml.aspx?keyID=%%@&vCode=%%@&characterID=%@";
NSString *const WalletJournalAPIURL = @"https://api.eveonline.com/char/WalletJournal.xml.aspx?keyID=%%@&vCode=%%@&characterID=%@&fromID=%@";
NSString *const RefTypesAPIURL = @"https://api.eveonline.com/eve/RefTypes.xml.aspx";

NSString *const MovedAPIKeyRowsType = @"MovedAPIRowsType";