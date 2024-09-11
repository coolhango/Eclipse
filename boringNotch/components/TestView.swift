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

struct FluidSlider: View {
    private let color: Color = Color.white
    @State private var offset: CGFloat = 0
    var rectSize = CGSize(width: 300, height: 50)
    var rectSize2 = CGSize(width: 200, height: 18)
    var circleSize: CGFloat = 35
    @GestureState var isDragging: Bool = false
    @State var previousOffset: CGFloat = 0
    @State private var isBeating: Bool = false
    
    var body: some View {
        HStack {
            slider
                .frame(width: rectSize2.width, height: circleSize)
        }
        .padding()
        .background(.black)
    }
    
    private var slider: some View {
        ZStack {
            Canvas { context, size in
                context.addFilter(.alphaThreshold(min: 0.5, max: 1, color: color))
                context.addFilter(.blur(radius: 10))
                
                context.drawLayer { ctx in
                    if let rectangle = ctx.resolveSymbol(id: "Capsule") {
                        ctx.draw(rectangle, at: CGPoint(x: size.width/2, y: size.height/2))
                    }
                    if let circle = ctx.resolveSymbol(id: "Circle") {
                        ctx.draw(circle, at: CGPoint(x: size.width/2 - rectSize2.width/2 + circleSize/2, y: size.height/2))
                    }
                }
            } symbols: {
                Capsule()
                    .frame(width: rectSize2.width, height: rectSize2.height, alignment: .center)
                    .tag("Capsule")
                
                Circle()
                    .frame(width: circleSize, height: circleSize, alignment: .center)
                    .offset(x: offset)
                    .animation(.spring(), value: isDragging)
                    .tag("Circle")
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isDragging, body: { _, state, _ in
                        state = true
                    })
                    .onChanged({ value in
                        self.offset = min(max(self.previousOffset + value.translation.width, 0), rectSize2.width - circleSize)
                    })
                    .onEnded({ value in
                        self.previousOffset = self.offset
                    })
            )
            Circle()
                .fill(Color.black)
                .frame(width: circleSize * 0.6)
                .overlay {
                    Image(systemName: "speaker.wave.2.fill")
                        .imageScale(.small)
                }
                .offset(x: (-rectSize2.width/2) + (circleSize/2))
                .offset(x: offset)
                .animation(.spring(), value: isDragging)
                .allowsHitTesting(false)
        }
    }
    
    
    private var animation: Animation {
        .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)
    }
    
    private var percentage: Int {
        Int((offset) / (rectSize.width - circleSize) * 100)
    }
}

#Preview {
    FluidSlider()
}
