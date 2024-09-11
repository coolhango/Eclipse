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

struct Marquee: View {
    @State var text: String
    var font: Font
    
    @State var storedSize: CGSize = .zero
    @State var offset: CGFloat = 0
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            Text(text)
                .font(font)
                .offset(x: offset)
        }
        .disabled(true)
        .onAppear {
            storedSize = textSize()
            
            (1...15).forEach {_ in
                text.append(" ")
            }
            
            let timing: Double = (0.02 * storedSize.width)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation(.linear(duration: timing)){
                    offset = -storedSize.width
                }
            }
        }
        .onReceive(Timer.publish(every: (0.02 * storedSize.width), on: .main, in: .default).autoconnect(), perform: { _ in
            offset = 0
            withAnimation(.linear(duration: (0.02 * storedSize.width))) {
                offset = -storedSize.width
            }
        })
    }
    
    func textSize() -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        
        return size
    }
}
