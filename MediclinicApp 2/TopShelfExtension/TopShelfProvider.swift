import TVServices
import SwiftUI

@objc(MCTopShelfContentProvider)
class MCTopShelfContentProvider: NSObject, TVTopShelfViewProvider {
    var topShelfView: some View {
        MCTopShelfView()
    }
}

struct MCTopShelfView: View {
    var body: some View {
        HStack(spacing: 40) {
            // Logo mark
            Canvas { ctx, sz in
                let w = sz.width; let h = sz.height
                let stroke: CGFloat = max(w * 0.10, 5)
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
                ctx.stroke(path, with: .color(.white.opacity(0.9)),
                           style: StrokeStyle(lineWidth: stroke, lineCap: .round))
                let r = w * 0.14
                ctx.fill(Path(ellipseIn: CGRect(x: cx-r, y: cy-r, width: r*2, height: r*2)),
                         with: .color(.white))
            }
            .frame(width: 90, height: 90)

            VStack(alignment: .leading, spacing: 10) {
                Text("Mediclinic")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                Text("Passion. People. Progress.")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.white.opacity(0.80))
            }
            Spacer()
        }
        .padding(60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.000, green: 0.600, blue: 0.839),
                    Color(red: 0.000, green: 0.392, blue: 0.627)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}
