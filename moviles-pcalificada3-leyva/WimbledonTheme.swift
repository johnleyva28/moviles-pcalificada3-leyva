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

    // Morado: es el color del escudo oficial de Wimbledon (Logo-Wimbledon.svg).
    static let wdlPurple = Color(hex: 0x54008B)
    static let wdlPurpleHover = Color(hex: 0x6A1FA3)
    static let wdlDeepPurple = Color(hex: 0x240330)
    static let wdlPurpleSoft = Color(hex: 0xEDE7FF)

    // Verdes: la cancha y el césped de Wimbledon.
    static let wdlGreen = Color(hex: 0x046633)          // --wdl-button-primary
    static let wdlGreenHover = Color(hex: 0x00552B)
    static let wdlGreenActive = Color(hex: 0x00331A)
    static let wdlGrass = Color(hex: 0x0E6027)           // verde césped
    static let wdlCourt = Color(hex: 0x11742F)           // verde de la cancha
    static let wdlDeepGreen = Color(hex: 0x042)
    static let wdlForest = Color(hex: 0x0B2917)
    static let wdlBrightGreen = Color(hex: 0x22B263)     // --wdl-highlight-brand-03
    static let wdlSuccess = Color(hex: 0x198038)
    static let wdlSuccessBright = Color(hex: 0x42BE65)
    static let wdlMint = Color(hex: 0xD3F0E0)            // --wdl-layer-highlight
    static let wdlLimeSoft = Color(hex: 0xCAE86B)        // --wdl-highlight-brand-07
    static let wdlLime = Color(hex: 0xF3FF00)            // --wdl-highlight-brand-06

    // Acentos
    static let wdlGold = Color(hex: 0x816C3C)            // --wdl-background-brand-03
    static let wdlGoldBorder = Color(hex: 0x9B8148)
    static let wdlTennis = Color(hex: 0xC4D600)          // verde limón de la pelota

    // Neutros
    static let wdlSurface = Color(hex: 0xF2F4F8)         // --wdl-layer-02
    static let wdlPaper = Color(hex: 0xFFFFFF)
    static let wdlBorder = Color(hex: 0xDDE1E6)          // --wdl-border-strong
    static let wdlHairline = Color(hex: 0xE4E9F1)        // --wdl-border-disabled
    static let wdlInk = Color(hex: 0x121619)             // --wdl-text-primary
    static let wdlInkSecondary = Color(hex: 0x697077)    // --wdl-text-secondary

    // Semánticos
    static let wdlError = Color(hex: 0xDA1E28)
    static let wdlWarning = Color(hex: 0xF1C21B)
}

// Wimbledon usa Gotham (sans) y Adobe Caslon Pro (serif). Ninguna es licenciable para iOS,
// así que se mapearon a las fuentes del sistema equivalentes.
enum WDLFont {
    /// Serif tipo Caslon: solo para títulos editoriales y nombres propios.
    static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    /// Sans tipo Gotham: etiquetas, botones, metadatos y datos.
    static func sans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

/// Escala tipográfica de 6 pasos con ratio 1.25. Nada de tamaños sueltos.
enum WDLType {
    static let caption = WDLFont.sans(11, weight: .medium)
    static let footnote = WDLFont.sans(13)
    static let body = WDLFont.sans(15)
    static let subhead = WDLFont.sans(17, weight: .semibold)
    static let title = WDLFont.display(21, weight: .bold)
    static let display = WDLFont.display(28, weight: .bold)
}

/// Radios: solo dos, uno para controles y otro para contenedores.
enum WDLRadius {
    static let control: CGFloat = 10
    static let container: CGFloat = 16
}

/// Ritmo de espaciado.
enum WDLSpace {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 20
    static let xl: CGFloat = 32
}
