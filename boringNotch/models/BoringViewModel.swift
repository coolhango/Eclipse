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
import Combine

enum SneakContentType {
    case brightness
    case volume
    case backlight
    case music
}

struct SneakPeak {
    var show: Bool = false
    var type: SneakContentType = .music
}

class BoringViewModel: NSObject, ObservableObject {
    var cancellables: Set<AnyCancellable> = []
    
    let animationLibrary: BoringAnimations = BoringAnimations()
    let animation: Animation?
    @Published var contentType: ContentType = .normal
    @Published var notchState: NotchState = .closed
    @Published var currentView: NotchViews = .empty
    @Published var headerTitle: String = "Made with 🤟"
    @Published var emptyStateText: String = "New features coming soon!"
    @Published var sizes : Sizes = Sizes()
    @Published var musicPlayerSizes: MusicPlayerElementSizes = MusicPlayerElementSizes()
    @Published var waitInterval: Double = 3
    @Published var releaseName: String = "The Start"
    @Published var coloredSpectrogram: Bool = true
    @Published var accentColor: Color = .accentColor
    @Published var selectedDownloadIndicatorStyle: DownloadIndicatorStyle = .progress
    @Published var selectedDownloadIconStyle: DownloadIconStyle = .onlyAppIcon
    @AppStorage("showMenuBarIcon") var showMenuBarIcon: Bool = true
    @Published var enableHaptics: Bool = true
    @Published var nothumanface: Bool = false
    @Published var showBattery: Bool = true
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    @Published var showChargingInfo: Bool = true
    @Published var chargingInfoAllowed: Bool = true
    @AppStorage("showWhatsNew") var showWhatsNew: Bool = true
    @Published var whatsNewOnClose: (() -> Void)?
    @Published var minimumHoverDuration: TimeInterval = 0.3
    @Published var notchMetastability: Bool = true // True if notch not open
    @Published var settingsIconInNotch: Bool = true
    private var sneakPeakDispatch: DispatchWorkItem?
    @Published var sneakPeak: SneakPeak = SneakPeak() {
        didSet {
            if sneakPeak.show {
                sneakPeakDispatch?.cancel()
                
                sneakPeakDispatch = DispatchWorkItem { [weak self] in
                    guard let self = self else { return }
                    withAnimation {
                        self.toggleSneakPeak(status: false, type: SneakContentType.music)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: sneakPeakDispatch!)
            }
        }
    }
        
        deinit {
            destroy()
        }
        
        func destroy() {
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        }
        
        
        override
        init() {
            self.animation = self.animationLibrary.animation
            super.init()
        }
        
        func open(){
            self.notchState = .open
        }
        
        func toggleSneakPeak(status:Bool, type: SneakContentType){
            self.sneakPeak.show = status
            self.sneakPeak.type = type
        }
        
        func close(){
            self.notchState = .closed
        }
        
        func openMenu(){
            self.currentView = .menu
        }
        
        func openMusic(){
            self.currentView = .music
        }
        
        func showEmpty() {
            self.currentView = .empty
        }
        
        func closeHello() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.2){
                self.firstLaunch = false;
                withAnimation(self.animationLibrary.animation){
                    self.close()
                }
            }
        }
    }
    
