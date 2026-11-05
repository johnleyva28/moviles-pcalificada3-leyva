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
        HStack(spacing: WDLSpace.s) {
            Image(systemName: icon)
                .foregroundStyle(tint)

            Text(toast.message)
                .font(WDLType.footnote)
                .foregroundStyle(Color.wdlPaper)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, WDLSpace.m)
        .padding(.vertical, WDLSpace.m)
        .background(Color.wdlInk, in: RoundedRectangle(cornerRadius: WDLRadius.control))
        .shadow(color: .black.opacity(0.24), radius: 12, y: 5)
        .padding(.horizontal, WDLSpace.l)
    }
}

extension View {
    /// Superpone un toast en la parte superior de la vista.
    func toast(_ toast: Toast?) -> some View {
        overlay(alignment: .top) {
            if let toast {
                ToastView(toast: toast)
                    .padding(.top, WDLSpace.s)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.38, dampingFraction: 0.86), value: toast)
    }
}
