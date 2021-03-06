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

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property NSMenu *dockMenu;

@property (weak) IBOutlet NSMenu *characterMenu;

- (void)updateAPIKeys;

- (IBAction)showSettingsWindow:(id)sender;
- (IBAction)showAccountWindow:(id)sender;
- (IBAction)showCharacterWindow:(id)sender;
- (IBAction)showWalletWindow:(id)sender;

@end
