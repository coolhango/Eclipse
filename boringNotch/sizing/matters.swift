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
import Foundation

var closedNotchSize: CGSize = setNotchSize()

func setNotchSize() -> CGSize {
    
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

struct Area {
    var width: CGFloat?
    var height: CGFloat?
    var inset: CGFloat?
}

struct StatesSizes {
    var opened: Area
    var closed: Area
}

struct Sizes {
    var cornerRadius: StatesSizes = StatesSizes(opened: Area(inset: 24), closed: Area(inset: 10))
    var size: StatesSizes = StatesSizes(
        opened: Area(width: 500, height: 130),
        closed: Area(width: closedNotchSize.width, height: closedNotchSize.height)
    )
}

struct MusicPlayerElementSizes {
    
    var baseSize: Sizes = Sizes()
    
    var image: Sizes = Sizes(
        cornerRadius: StatesSizes(
            opened: Area(inset: 14), closed: Area(inset:4)),
        size: StatesSizes(
            opened: Area(width: 70, height: 70), closed: Area(width: 20, height: 20)
        )
    )
    var player: Sizes = Sizes(
        size: StatesSizes(
            opened: Area(width: 440), closed: Area(width: closedNotchSize.width)
        )
    )
}
