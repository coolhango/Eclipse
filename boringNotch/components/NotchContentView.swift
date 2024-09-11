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

struct NotchContentView: View {
    @EnvironmentObject var vm: BoringViewModel
    @EnvironmentObject var musicManager: MusicManager
    @EnvironmentObject var batteryModel: BatteryStatusViewModel
    
    var body: some View {
        VStack {
            if vm.notchState == .open {
                VStack(spacing: 10) {
                    BoringHeader(vm: vm, percentage: batteryModel.batteryPercentage, isCharging: batteryModel.isPluggedIn).padding(.leading, 6).padding(.trailing, 6).animation(.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8), value: vm.notchState)
                    if vm.firstLaunch {
                        HelloAnimation().frame(width: 180, height: 60).onAppear(perform: {
                            vm.closeHello()
                        })
                    }
                }
            }
            
            if !vm.firstLaunch {
                
                HStack(spacing: 15) {
                    if vm.notchState == .closed && batteryModel.showChargingInfo {
                        Text("Charging").foregroundStyle(.white).padding(.leading, 4)
                    }
                    if !batteryModel.showChargingInfo && vm.currentView != .menu  {
                        
                        Image(nsImage: musicManager.albumArt)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: vm.notchState == .open ? vm.musicPlayerSizes.image.size.opened.width : vm.musicPlayerSizes.image.size.closed.width,
                                height: vm.notchState == .open ? vm.musicPlayerSizes.image.size.opened.height : vm.musicPlayerSizes.image.size.closed.height
                            )
                            .cornerRadius(vm.notchState == .open ? vm.musicPlayerSizes.image.cornerRadius.opened.inset! : vm.musicPlayerSizes.image.cornerRadius.closed.inset!)
                            .scaledToFit()
                            .padding(.leading, vm.notchState == .open ? 5 : 3)
                    }
                    
                    if vm.notchState == .open {
                        if vm.currentView == .menu {
                            BoringExtrasMenu(vm: vm).transition(.blurReplace.animation(.spring(.bouncy(duration: 0.3))))
                        }
                        
                        if vm.currentView != .menu {
                            if true {
                                VStack(alignment: .leading, spacing: 5) {
                                    VStack(alignment: .leading, spacing: 3){
                                        Text(musicManager.songTitle)
                                            .font(.headline)
                                            .fontWeight(.regular)
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        Text(musicManager.artistName)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                    HStack(spacing: 5) {
                                        Button {
                                            musicManager.previousTrack()
                                        } label: {
                                            Rectangle()
                                                .fill(.clear)
                                                .contentShape(Rectangle())
                                                .frame(width: 30, height: 30)
                                                .overlay {
                                                    Image(systemName: "backward.fill")
                                                        .foregroundColor(.white)
                                                        .imageScale(.medium)
                                                }
                                        }
                                        Button {
                                            print("tapped")
                                            musicManager.togglePlayPause()
                                        } label: {
                                            Rectangle()
                                                .fill(.clear)
                                                .contentShape(Rectangle())
                                                .frame(width: 30, height: 30)
                                                .overlay {
                                                    Image(systemName: musicManager.isPlaying ? "pause.fill" : "play.fill")
                                                        .foregroundColor(.white)
                                                        .contentTransition(.symbolEffect)
                                                        .imageScale(.large)
                                                }
                                        }
                                        Button {
                                            musicManager.nextTrack()
                                        } label: {
                                            Rectangle()
                                                .fill(.clear)
                                                .contentShape(Rectangle())
                                                .frame(width: 30, height: 30)
                                                .overlay {
                                                    Capsule()
                                                        .fill(.black)
                                                        .frame(width: 30, height: 30)
                                                        .overlay {
                                                            Image(systemName: "forward.fill")
                                                                .foregroundColor(.white)
                                                                .imageScale(.medium)
                                                            
                                                        }
                                                }
                                        }
                                    }
                                }
                                .allowsHitTesting(!vm.notchMetastability)
                                .transition(.blurReplace.animation(.spring(.bouncy(duration: 0.3)).delay(vm.notchState == .closed ? 0 : 0.1)))
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    
                    if vm.currentView != .menu {
                        Spacer()
                    }
                    
                    if musicManager.isPlayerIdle == true && vm.notchState == .closed && !batteryModel.showChargingInfo && vm.nothumanface {
                        MinimalFaceFeatures().transition(.blurReplace.animation(.spring(.bouncy(duration: 0.3))))
                    }
                    
                    
                    if vm.currentView != .menu && vm.notchState == .closed && batteryModel.showChargingInfo {
                        BoringBatteryView(batteryPercentage: batteryModel.batteryPercentage, isPluggedIn: batteryModel.isPluggedIn, batteryWidth: 30)}
                    
                    if vm.currentView != .menu && !batteryModel.showChargingInfo && (musicManager.isPlaying || !musicManager.isPlayerIdle) {
                        MusicVisualizer(avgColor: musicManager.avgColor, isPlaying: musicManager.isPlaying)
                            .frame(width: 30)
                    }
                }
            }
            
            if vm.notchState == .closed &&  vm.sneakPeak.show && !batteryModel.showChargingInfo {
                switch vm.sneakPeak.type {
                    case .music:
                        HStack() {
                            Image(systemName: "music.note").padding(.leading, 4)
                            Text(musicManager.songTitle)
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                            
                            Spacer()
                        }.foregroundStyle(.gray, .gray).transition(.blurReplace.animation(.spring(.bouncy(duration: 0.3)).delay(0.1))).padding(.horizontal, 4).padding(.vertical, 2)
                    default:
                        Text("")
                }
            }
        }
        .frame(width: calculateFrameWidthforNotchContent())
        .transition(.blurReplace.animation(.spring(.bouncy(duration: 0.5))))
    }
    
    func calculateFrameWidthforNotchContent() -> CGFloat? {
            // Calculate intermediate values
        let chargingInfoWidth: CGFloat = batteryModel.showChargingInfo ? 160 : 0
        let musicPlayingWidth: CGFloat = (!vm.firstLaunch && !batteryModel.showChargingInfo && (musicManager.isPlaying || (musicManager.isPlayerIdle ? vm.nothumanface : true))) ? 60 : -15
        
        let closedWidth: CGFloat = vm.sizes.size.closed.width! - 10
        
        let dynamicWidth: CGFloat = chargingInfoWidth + musicPlayingWidth + closedWidth
            // Return the appropriate width based on the notch state
        return vm.notchState == .open ? vm.musicPlayerSizes.player.size.opened.width : dynamicWidth + (vm.sneakPeak.show ? -12 : 0)
    }
}

#Preview {
    BoringNotch(vm: BoringViewModel(), batteryModel: BatteryStatusViewModel(vm: .init()), onHover: onHover).frame(width: 600, height: 500)
}
