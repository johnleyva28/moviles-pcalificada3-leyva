import SwiftUI

enum ToastKind {
    case error
    case success
}

struct Toast: Equatable {
    var message: String
    var kind: ToastKind = .error
}

/// Aviso flotante que aparece sobre la pantalla y se descarta solo.
struct ToastView: View {
    let toast: Toast

    private var icon: String {
        switch toast.kind {
        case .error: "exclamationmark.triangle.fill"
        case .success: "checkmark.circle.fill"
        }
    }

    private var tint: Color {
        switch toast.kind {
        case .error: .wdlError
        case .success: .wdlBrightGreen
        }
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(tint)

            Text(toast.message)
                .font(WDLFont.sans(14, weight: .medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(Color.wdlInk, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.28), radius: 14, y: 6)
        .padding(.horizontal, 24)
    }
}

extension View {
    /// Superpone un toast en la parte superior de la vista.
    func toast(_ toast: Toast?) -> some View {
        overlay(alignment: .top) {
            if let toast {
                ToastView(toast: toast)
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.38, dampingFraction: 0.86), value: toast)
    }
}
