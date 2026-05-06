import SwiftUI

struct WelcomeView: View {
    let hospital: HospitalInfo

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.mcBlue, Color.mcBlueDark],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Logo + Name
                VStack(spacing: 20) {
                    // Mediclinic logo on blue bg — use white frame
                    Canvas { ctx, sz in
                        let w = sz.width; let h = sz.height
                        let stroke: CGFloat = max(w * 0.09, 4)
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
                        ctx.stroke(path, with: .color(.white.opacity(0.85)),
                                   style: StrokeStyle(lineWidth: stroke, lineCap: .round))
                        let r = w * 0.135
                        ctx.fill(Path(ellipseIn: CGRect(x: cx-r, y: cy-r, width: r*2, height: r*2)),
                                 with: .color(.white))
                    }
                    .frame(width: 100, height: 100)

                    Text(hospital.name)
                        .font(TVFont.largeTitle)
                        .foregroundColor(.white)

                    Text(hospital.tagline)
                        .font(TVFont.title2)
                        .foregroundColor(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // Quick-access info
                HStack(spacing: 40) {
                    QuickStat(icon: "phone.fill",     value: hospital.phone,     label: "Reception")
                    QuickStat(icon: "cross.case.fill", value: hospital.emergency, label: "Emergency")
                    QuickStat(icon: "pill.fill",       value: hospital.pharmacy,  label: "Pharmacy")
                }
                .padding(.bottom, 60)
            }
        }
    }
}

struct QuickStat: View {
    let icon: String; let value: String; let label: String
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white.opacity(0.85))
            Text(value)
                .font(TVFont.callout)
                .foregroundColor(.white)
                .fontWeight(.medium)
            Text(label)
                .font(TVFont.caption)
                .foregroundColor(.white.opacity(0.60))
        }
    }
}
