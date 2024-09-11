// Copyright © 2024 Gedeon Koh All rights reserved.
// No part of this publication may be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods, without the prior written permission of the publisher, except in the case of brief quotations embodied in reviews and certain other non-commercial uses permitted by copyright law.
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHOR OR COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// Use of this program for pranks or any malicious activities is strictly prohibited. Any unauthorized use or dissemination of the results produced by this program is unethical and may result in legal consequences.
// This code has been tested throughly. Please inform the operator or author if there is any mistake or error in the code.
// Any damage, disciplinary actions or death from this material is not the publisher's or owner's fault.
// Run and use this program this AT YOUR OWN RISK.
// Version 0.1

// This Space is for you to experiment your codes
// Start Typing Below :) ↓↓↓

import SwiftUI
import AVFoundation
import Combine
import Sparkle

@main
struct DynamicNotchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("showMenuBarIcon") var showMenuBarIcon: Bool = true
    let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        Settings {
            SettingsView(updaterController: updaterController)
                .environmentObject(appDelegate.vm)
        }
        
        MenuBarExtra("boring.notch", systemImage: "music.note" , isInserted: $showMenuBarIcon) {
            SettingsLink(label: {
                Text("Settings")
            })
            .keyboardShortcut(KeyEquivalent(","), modifiers: .command)
            CheckForUpdatesView(updater: updaterController.updater)
            Divider()
            Button("Quit", role: .destructive) {
                exit(0)
            }
            .keyboardShortcut(KeyEquivalent("Q"), modifiers: .command)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var window: NSWindow!
    var sizing: Sizes = Sizes()
    let vm: BoringViewModel = BoringViewModel()
    var whatsNewWindow: NSWindow?
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustWindowPosition),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
        
        
        window = BoringNotchWindow(
            contentRect: NSRect(x: 0, y: 0, width: sizing.size.opened.width! + 20, height: sizing.size.opened.height! + 30), styleMask: [.borderless], backing: .buffered, defer: false
        )
        
        window.contentView = NSHostingView(rootView: ContentView(onHover: adjustWindowPosition, batteryModel: .init(vm: self.vm)).environmentObject(vm))
        
        adjustWindowPosition()
        
        
        window.orderFrontRegardless()
        
        if(vm.firstLaunch){
            playWelcomeSound()
        }
        
    }
    
    
    func playWelcomeSound() {
        let audioPlayer = AudioPlayer()
        audioPlayer.play(fileName: "boring", fileExtension: "m4a")
    }
    
    func deviceHasNotch() -> Bool {
        if #available(macOS 12.0, *) {
            for screen in NSScreen.screens {
                if screen.safeAreaInsets.top > 0 {
                    return true
                }
            }
        }
        return false
    }
    
    
    @objc func adjustWindowPosition() {
        if let screenFrame = window.screen ?? NSScreen.main {
            let windowWidth = window.frame.width
            let notchCenterX = screenFrame.frame.width / 2
            let windowX = notchCenterX - windowWidth / 2
            let windowY = screenFrame.frame.height

            window.setFrameTopLeftPoint(NSPoint(x: windowX, y: windowY))
        }
    }
    
    func setNotchSize() -> CGSize {
        // Default notch size, to avoid using optionals
        var notchHeight: CGFloat = 32
        var notchWidth: CGFloat = 185
        
        // Check if the screen is available
        if let screen = NSScreen.main {
            // Calculate and set the exact width of the notch
            if let topLeftNotchpadding: CGFloat = screen.auxiliaryTopLeftArea?.width,
               let topRightNotchpadding: CGFloat = screen.auxiliaryTopRightArea?.width {
                notchWidth = screen.frame.width - topLeftNotchpadding - topRightNotchpadding + 10
            }
            
            // Use MenuBar height as notch height if there is no notch
            notchHeight = screen.frame.maxY - screen.visibleFrame.maxY
            
            // Check if the Mac has a notch
            if screen.safeAreaInsets.top > 0 {
                notchHeight = screen.safeAreaInsets.top
            }
        }
        
        return .init(width: notchWidth, height: notchHeight)
    }
    
    
    @objc func togglePopover(_ sender: Any?) {
        if window.isVisible {
            window.orderOut(nil)
        } else {
            window.orderFrontRegardless()
        }
    }
    
    @objc func showMenu() {
        statusItem!.menu?.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
    }
    
    @objc func quitAction() {
        NSApplication.shared.terminate(nil)
    }
    
}
