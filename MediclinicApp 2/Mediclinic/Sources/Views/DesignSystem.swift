import SwiftUI

// MARK: - Mediclinic Brand Colors
extension Color {
    static let mcBlue       = Color(red: 0.000, green: 0.600, blue: 0.839) // #0099D6
    static let mcBlueDark   = Color(red: 0.000, green: 0.392, blue: 0.627) // #0064A0
    static let mcBlueLight  = Color(red: 0.878, green: 0.953, blue: 0.984) // #E0F3FB
    static let mcGrey       = Color(red: 0.471, green: 0.431, blue: 0.392) // #786E64

    static let tvBackground  = Color(red: 0.953, green: 0.976, blue: 0.992)
    static let tvBackground2 = Color(red: 0.910, green: 0.957, blue: 0.984)
    static let tvCard        = Color.white
    static let tvSurface     = Color.white
    static let tvBorder      = Color(red: 0.000, green: 0.600, blue: 0.839).opacity(0.12)
    static let tvBorderStrong = Color(red: 0.000, green: 0.600, blue: 0.839).opacity(0.22)

    static let tvTextPrimary   = Color(red: 0.118, green: 0.133, blue: 0.161)
    static let tvTextSecondary = Color(red: 0.118, green: 0.133, blue: 0.161).opacity(0.65)
    static let tvTextMuted     = Color(red: 0.118, green: 0.133, blue: 0.161).opacity(0.40)

    static let tvGreen = Color(red: 0.000, green: 0.627, blue: 0.447)
    static let tvAmber = Color(red: 0.835, green: 0.565, blue: 0.000)
    static let tvRed   = Color(red: 0.820, green: 0.133, blue: 0.133)

    // Compatibility aliases
    static let athBlue       = mcBlue
    static let athBlueDark   = mcBlueDark
    static let athTeal       = mcBlue
    static let amcOrange     = mcBlue
    static let amcOrangeDark = mcBlueDark
    static let amcTeal       = mcBlue
    static let mediclinicBlue = mcBlue
}

// MARK: - Mediclinic Logo Icon
struct MediclinicIcon: View {
    var size: CGFloat = 44
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width; let h = sz.height
            let stroke: CGFloat = max(w * 0.09, 3)
            let inner = w * 0.62; let gap = w * 0.18
            let cx = w / 2; let cy = h / 2
            var path = Path()
            path.move(to: CGPoint(x: cx - inner/2 + gap, y: cy - inner/2))
            path.addLine(to: CGPoint(x: cx + inner/2 - gap, y: cy - inner/2))
            path.move(to: CGPoint(x: cx - inner/2 + gap, y: cy + inner/2))
            path.addLine(to: CGPoint(x: cx + inner/2 - gap, y: cy + inner/2))
            path.move(to: CGPoint(x: cx - inner/2, y: cy - inner/2 + gap))
            path.addLine(to: CGPoint(x: cx - inner/2, y: cy + inner/2 - gap))
            path.move(to: CGPoint(x: cx + inner/2, y: cy - inner/2 + gap))
            path.addLine(to: CGPoint(x: cx + inner/2, y: cy + inner/2 - gap))
            ctx.stroke(path, with: .color(.mcGrey), style: StrokeStyle(lineWidth: stroke, lineCap: .round))
            let r = w * 0.135
            ctx.fill(Path(ellipseIn: CGRect(x: cx-r, y: cy-r, width: r*2, height: r*2)), with: .color(.mcBlue))
        }
        .frame(width: size, height: size)
    }
}
typealias HospitalIcon = MediclinicIcon

// MARK: - TV Typography
struct TVFont {
    static let largeTitle = Font.system(size: 52, weight: .bold)
    static let title      = Font.system(size: 38, weight: .medium)
    static let title2     = Font.system(size: 28, weight: .medium)
    static let headline   = Font.system(size: 22, weight: .semibold)
    static let body       = Font.system(size: 18, weight: .regular)
    static let callout    = Font.system(size: 16, weight: .regular)
    static let caption    = Font.system(size: 14, weight: .regular)
    static let micro      = Font.system(size: 12, weight: .regular)
}

// MARK: - Card modifier
struct TVCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.background(Color.tvCard).cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.tvBorder, lineWidth: 0.5))
    }
}
extension View { func tvCard() -> some View { modifier(TVCardStyle()) } }

// MARK: - Status Badge
struct StatusBadge: View {
    let status: DepartmentStatus
    var color: Color {
        switch status {
        case .open: return .tvGreen
        case .busy: return .tvAmber
        case .closed: return .tvRed
        }
    }
    var body: some View {
        Text(status.label).font(TVFont.micro)
            .padding(.horizontal, 12).padding(.vertical, 4)
            .background(color.opacity(0.12)).foregroundColor(color).cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(color.opacity(0.3), lineWidth: 0.5))
    }
}

// MARK: - Live Chip
struct LiveChip: View {
    var body: some View {
        HStack(spacing: 5) {
            Circle().fill(Color.tvGreen).frame(width: 6, height: 6)
            Text("LIVE").font(TVFont.micro).foregroundColor(.tvGreen).tracking(1)
        }
        .padding(.horizontal, 10).padding(.vertical, 4)
        .background(Color.tvGreen.opacity(0.10)).cornerRadius(6)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.tvGreen.opacity(0.3), lineWidth: 0.5))
    }
}

// MARK: - Visual Stat Card
struct VisualStatCard: View {
    let icon: String; let value: String; let label: String
    var iconColor: Color = .mcBlue
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .light))
                .foregroundColor(iconColor)
                .frame(width: 64, height: 64)
                .background(iconColor.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            Text(value).font(TVFont.title2).foregroundColor(.tvTextPrimary).fontWeight(.bold)
            Text(label).font(TVFont.caption).foregroundColor(.tvTextMuted).multilineTextAlignment(.center)
        }
        .padding(.vertical, 22).padding(.horizontal, 16)
        .frame(maxWidth: .infinity).tvCard()
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let icon: String; let label: String; let value: String
    var iconColor: Color = .mcBlue
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(TVFont.caption).foregroundColor(.tvTextMuted)
                Text(value).font(TVFont.body).foregroundColor(.tvTextPrimary)
            }
            Spacer()
        }
        .padding(.horizontal, 20).padding(.vertical, 14).tvCard()
    }
}

// MARK: - Alert Banner
struct AlertBanner: View {
    let message: String
    var dotColor: Color = .mcBlue
    var body: some View {
        HStack(spacing: 10) {
            Circle().fill(dotColor).frame(width: 8, height: 8)
            Text(message).font(TVFont.callout).foregroundColor(.tvTextSecondary)
            Spacer()
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .background(dotColor.opacity(0.08)).cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(dotColor.opacity(0.22), lineWidth: 0.5))
    }
}

// MARK: - Stat Card (compact)
struct StatCard: View {
    let label: String; let value: String; let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(TVFont.micro).foregroundColor(.tvTextMuted).tracking(0.8).textCase(.uppercase)
            Text(value).font(TVFont.title2).foregroundColor(.mcBlue)
            Text(subtitle).font(TVFont.micro).foregroundColor(.tvTextMuted)
        }
        .padding(.horizontal, 20).padding(.vertical, 14).tvCard()
    }
}
