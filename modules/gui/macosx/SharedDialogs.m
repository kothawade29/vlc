/*****************************************************************************
 * SharedDialogs.m: MacOS X interface module
 *****************************************************************************
 * Copyright (C) 2012 Felix Paul Kühne
 * $Id$
 *
 * Authors: Felix Paul Kühne <fkuehne -at- videolan -dot- org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

#import "SharedDialogs.h"

@implementation VLCTextfieldPanelController


- (id)init
{
    self = [super initWithWindowNibName:@"TextfieldPanel"];

    return self;
}

- (IBAction)windowElementAction:(id)sender
{
    [self.window orderOut:sender];
    [NSApp endSheet: self.window];

    if (self.target) {
        if ([self.target respondsToSelector:@selector(panel:returnValue:text:)]) {
            if (sender == _cancelButton)
                [self.target panel:self returnValue:NSCancelButton text:NULL];
            else
                [self.target panel:self returnValue:NSOKButton text:self.enteredText];
        }
    }
}

- (void)runModalForWindow:(NSWindow *)window
{
    [self window];

    [_titleLabel setStringValue:self.title];
    [_subtitleLabel setStringValue:self.subTitle];
    [_cancelButton setTitle:self.CancelButtonLabel];
    [_okButton setTitle:self.OKButtonLabel];
    [_textField setStringValue:@""];

    [NSApp beginSheet:self.window modalForWindow:window modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (NSString *)enteredText
{
    return [_textField stringValue];
}

@end

@implementation VLCPopupPanelController

- (id)init
{
    self = [super initWithWindowNibName:@"PopupPanel"];

    return self;
}

- (IBAction)windowElementAction:(id)sender
{
    [self.window orderOut:sender];
    [NSApp endSheet: self.window];

    if (self.target) {
        if ([self.target respondsToSelector:@selector(panel:returnValue:item:)]) {
            if (sender == _cancelButton)
                [self.target panel:self returnValue:NSCancelButton item:0];
            else
                [self.target panel:self returnValue:NSOKButton item:self.currentItem];
        }
    }
}

- (void)runModalForWindow:(NSWindow *)window
{
    [self window];

    [_titleLabel setStringValue:self.title];
    [_subtitleLabel setStringValue:self.subTitle];
    [_cancelButton setTitle:self.CancelButtonLabel];
    [_okButton setTitle:self.OKButtonLabel];
    [_popupButton removeAllItems];
    for (NSString *value in self.popupButtonContent)
        [[_popupButton menu] addItemWithTitle:value action:nil keyEquivalent:@""];

    [NSApp beginSheet:self.window modalForWindow:window modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (NSUInteger)currentItem
{
    return [_popupButton indexOfSelectedItem];
}

@end
