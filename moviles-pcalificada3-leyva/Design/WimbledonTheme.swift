import SwiftUI

// Tokens extraídos de los estilos oficiales de wimbledon.com (variables CSS `--wdl-*`).
extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }

    // Marca
    static let wdlGreen = Color(hex: 0x006633)          // --wdl-button-primary
    static let wdlGreenHover = Color(hex: 0x00552B)
    static let wdlGreenActive = Color(hex: 0x00331A)
    static let wdlDeepGreen = Color(hex: 0x042)
    static let wdlPurple = Color(hex: 0x540082)          // --wdl-background-brand-02
    static let wdlDeepPurple = Color(hex: 0x240330)
    static let wdlGold = Color(hex: 0x816C3C)            // --wdl-background-brand-03
    static let wdlGoldBorder = Color(hex: 0x9B8148)
    static let wdlLime = Color(hex: 0xF3FF00)            // --wdl-highlight-brand-06
    static let wdlLimeSoft = Color(hex: 0xCAE86B)        // --wdl-highlight-brand-07
    static let wdlMint = Color(hex: 0xD3F0E0)            // --wdl-layer-highlight
    static let wdlLavender = Color(hex: 0xEDE7FF)

    // Neutros
    static let wdlSurface = Color(hex: 0xF2F4F8)
    static let wdlBorder = Color(hex: 0xDDE1E6)
    static let wdlInk = Color(hex: 0x121619)
    static let wdlInkSecondary = Color(hex: 0x697077)

    // Semánticos
    static let wdlError = Color(hex: 0xDA1E28)
    static let wdlWarning = Color(hex: 0xF1C21B)
    static let wdlSuccess = Color(hex: 0x198038)
}

// Wimbledon usa Gotham (sans) y Adobe Caslon Pro (serif). Ninguna es licenciable para iOS,
// así que se mapearon a las fuentes del sistema equivalentes.
enum WDLFont {
    static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static func sans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}
