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

struct BatteryView: View {
    @State var percentage: Float
    @State var isCharging: Bool
    var batteryWidth: CGFloat = 26
    var animationStyle: BoringAnimations = BoringAnimations()
    
    var icon: String {
        return "battery.0"
    }
    
    var batteryColor: Color {
        if percentage.isLessThanOrEqualTo(20) {
            return .red
        } else {
            return .white
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(systemName: icon)
                .resizable()
                .fontWeight(.thin)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
                .frame(
                    width: batteryWidth + 1
                )
            
            RoundedRectangle(cornerRadius: 2)
                .fill(batteryColor)
                .frame(width: CGFloat(((CGFloat(CFloat(percentage)) / 100) * (batteryWidth - 6))), height: (batteryWidth - 2.5) - 18).padding(.leading, 2).padding(.top, -0.5)
            if isCharging {
                Image(.bolt).resizable().aspectRatio(contentMode: .fit).foregroundColor(.yellow).frame(width: 16, height: 16).padding(.leading, 7).offset(y: -1)
            }
            
        }
    }
}

struct BoringBatteryView: View {
    @State var batteryPercentage: Float = 0
    @State var isPluggedIn:Bool = false
    @State var batteryWidth: CGFloat = 26
    
    var body: some View {
           if hasBattery() {
               HStack {
                   Text("\(Int32(batteryPercentage))%")
                       .font(.callout)
                   BatteryView(percentage: batteryPercentage, isCharging: isPluggedIn, batteryWidth: batteryWidth)
               }
           }
       }
}

#Preview {
    BoringBatteryView(
        batteryPercentage: 40,
        isPluggedIn: true,
        batteryWidth: 30
    ).frame(width: 200, height: 200)
}
