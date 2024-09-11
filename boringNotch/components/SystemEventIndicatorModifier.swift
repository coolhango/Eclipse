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

struct SystemEventIndicatorModifier: ViewModifier {
    @State var eventType: SystemEventType
    @State var value: CGFloat
    let showSlider: Bool = false
    
    func body(content: Content) -> some View {
        VStack {
            content
            HStack(spacing: 20) {
                switch (eventType) {
                    case .volume:
                        Image(systemName: SpeakerSymbol(value))
                            .contentTransition(.interpolate)
                            .frame(width: 20, alignment: .leading)
                    case .brightness:
                        Image(systemName: "sun.max.fill")
                            .contentTransition(.interpolate)
                            .frame(width: 20)
                    case .backlight:
                        Image(systemName: "keyboard")
                            .contentTransition(.interpolate)
                            .frame(width: 20)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.quaternary)
                        Capsule()
                            .fill(LinearGradient(colors: [.white, .white.opacity(0.2)], startPoint: .trailing, endPoint: .leading))
                            .frame(width: geo.size.width * value)
                            .shadow(color: .white, radius: 8, x: 3)
                    }
                }
                .frame(height: 6)
            }
            .symbolVariant(.fill)
            .imageScale(.large)
            .padding(.vertical)
            if showSlider {
                Slider(value: $value.animation(.smooth), in: 0...1)
            }
        }
    }
    
    func SpeakerSymbol(_ value: CGFloat) -> String {
        switch(value) {
            case 0:
                return "speaker.slash.fill"
            case 0...0.3:
                return "speaker.wave.1"
            case 0.3...0.8:
                return "speaker.wave.2"
            case 0.8...1:
                return "speaker.wave.3"
            default:
                return "speaker.wave.2"
        }
    }
}

enum SystemEventType {
    case volume
    case brightness
    case backlight
}

extension View {
    func systemEventIndicator(for eventType: SystemEventType, value: CGFloat) -> some View {
        self.modifier(SystemEventIndicatorModifier(eventType: eventType, value: value))
    }
}

#Preview {
    EmptyView()
        .systemEventIndicator(for: .volume, value: 0.4)
        .systemEventIndicator(for: .brightness, value: 0.7)
        .systemEventIndicator(for: .backlight, value: 0.2)
        .frame(width: 200)
        .padding()
        .background(.black)
}
