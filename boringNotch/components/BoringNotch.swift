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

var notchAnimation = Animation.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)

struct BoringNotch: View {
    @StateObject var vm: BoringViewModel
    let onHover: () -> Void
    @State private var isExpanded = false
    @State var showEmptyState = false
    @StateObject private var musicManager: MusicManager
    @StateObject var batteryModel: BatteryStatusViewModel
    @State private var haptics: Bool = false
    
    @State private var hoverStartTime: Date?
    @State private var hoverTimer: Timer?
    @State private var hoverAnimation: Bool = false
    
    init(vm: BoringViewModel, batteryModel: BatteryStatusViewModel, onHover: @escaping () -> Void) {
        _vm = StateObject(wrappedValue: vm)
        _musicManager = StateObject(wrappedValue: MusicManager(vm: vm)!)
        _batteryModel = StateObject(wrappedValue: batteryModel)
        self.onHover = onHover
    }
    
    func calculateNotchWidth() -> CGFloat {
        let isFaceVisible = (musicManager.isPlayerIdle ? vm.nothumanface: true) || musicManager.isPlaying
        let baseWidth = vm.sizes.size.closed.width ?? 0
        
        let notchWidth: CGFloat = vm.notchState == .open
        ? vm.sizes.size.opened.width!
        : batteryModel.showChargingInfo
        ? baseWidth + 160
        : CGFloat(vm.firstLaunch ? 50 : 0) + baseWidth + (isFaceVisible ? 65 : 0)
        
        return notchWidth + (hoverAnimation ? 16 : 0)
    }
    
    var body: some View {
        Rectangle()
            .foregroundColor(.black)
            .mask(NotchShape(cornerRadius: vm.notchState == .open ? vm.sizes.cornerRadius.opened.inset : (vm.sneakPeak.show ? 4 : 0) + vm.sizes.cornerRadius.closed.inset!))
            .frame(width: calculateNotchWidth(), height: vm.notchState == .open ? (vm.sizes.size.opened.height!) : vm.sizes.size.closed.height! + (hoverAnimation ? 8 : !batteryModel.showChargingInfo && vm.sneakPeak.show ? 25 : 0))
            .animation(notchAnimation, value: batteryModel.showChargingInfo)
            .animation(notchAnimation, value: musicManager.isPlaying)
            .animation(notchAnimation, value: musicManager.lastUpdated)
            .animation(notchAnimation, value: musicManager.isPlayerIdle)
            .animation(.smooth, value: vm.firstLaunch)
            .animation(notchAnimation, value: vm.sneakPeak.show)
            .overlay {
                NotchContentView()
                    .environmentObject(vm)
                    .environmentObject(musicManager)
                    .environmentObject(batteryModel)
            }
            .clipped()
            .onHover { hovering in
                if hovering {
                    if ((vm.notchState == .closed) && vm.enableHaptics) {
                        haptics.toggle()
                    }
                    startHoverTimer()
                } else {
                    vm.notchMetastability = true
                    cancelHoverTimer()
                    if vm.notchState == .open {
                        withAnimation(.smooth) {
                            vm.close()
                            vm.openMusic()
                        }
                    }
                }
            }
            .shadow(color: vm.notchState == .open ? .black : hoverAnimation ? .black.opacity(0.5) : .clear, radius: 10)
            .sensoryFeedback(.levelChange, trigger: haptics)
            .onChange(of: batteryModel.isPluggedIn, { oldValue, newValue in
                withAnimation(.spring(response: 1, dampingFraction: 0.8, blendDuration: 0.7)) {
                    if newValue {
                        batteryModel.showChargingInfo = true
                    } else {
                        batteryModel.showChargingInfo = false
                    }
                }
            })
            .environmentObject(vm)
    }
    
    
    private func startHoverTimer() {
        hoverStartTime = Date()
        hoverTimer?.invalidate()
        withAnimation(vm.animation) {
            hoverAnimation = true
        }
        hoverTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            checkHoverDuration()
        }
    }
    
    private func checkHoverDuration() {
        guard let startTime = hoverStartTime else { return }
        let hoverDuration = Date().timeIntervalSince(startTime)
        if hoverDuration >= vm.minimumHoverDuration {
            withAnimation() {
                vm.open()
                vm.notchMetastability = false
            }
            cancelHoverTimer()
        }
    }
    
    private func cancelHoverTimer() {
        hoverTimer?.invalidate()
        hoverTimer = nil
        hoverStartTime = nil
        withAnimation(vm.animation) {
            hoverAnimation = false
        }
    }
}

func onHover(){}

#Preview {
    BoringNotch(vm: BoringViewModel(), batteryModel: BatteryStatusViewModel(vm: .init()), onHover: onHover).frame(width: 600, height: 500)
}
