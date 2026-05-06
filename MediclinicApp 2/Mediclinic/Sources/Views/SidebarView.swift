import SwiftUI

enum NavSection: String, CaseIterable {
    case about      = "About"
    case emergency  = "Emergency"
    case departments = "Departments"
    case doctors    = "Doctors"
    case visiting   = "Visiting Hours"
    case contact    = "Contact"
    case services   = "Services"

    var icon: String {
        switch self {
        case .about:       return "house.fill"
        case .emergency:   return "cross.case.fill"
        case .departments: return "building.2.fill"
        case .doctors:     return "stethoscope"
        case .visiting:    return "clock.fill"
        case .contact:     return "phone.fill"
        case .services:    return "list.star"
        }
    }

    var accentColor: Color {
        switch self {
        case .emergency: return .tvRed
        default:         return .mcBlue
        }
    }
}

struct SidebarView: View {
    @Binding var selected: NavSection
    let hospital: HospitalInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Logo + name header
            VStack(alignment: .leading, spacing: 8) {
                MediclinicIcon(size: 48)
                Text(hospital.name)
                    .font(TVFont.headline)
                    .foregroundColor(.mcBlue)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 24)
            .padding(.top, 36)
            .padding(.bottom, 28)

            Divider().background(Color.tvBorder).padding(.horizontal, 16)

            // Nav items
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 4) {
                    ForEach(NavSection.allCases, id: \.self) { section in
                        SidebarItem(section: section, isSelected: selected == section)
                            .onTapGesture { selected = section }
                    }
                }
                .padding(.vertical, 12)
            }

            Spacer()
        }
        .background(Color.tvCard)
        .overlay(
            Rectangle()
                .frame(width: 0.5)
                .foregroundColor(Color.tvBorder),
            alignment: .trailing
        )
    }
}

struct SidebarItem: View {
    let section: NavSection
    let isSelected: Bool
    @Environment(\.isFocused) private var isFocused

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: section.icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(isSelected || isFocused ? .white : section.accentColor)
                .frame(width: 36, height: 36)
                .background(isSelected || isFocused ? section.accentColor : section.accentColor.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 9))

            Text(section.rawValue)
                .font(TVFont.body)
                .foregroundColor(isSelected || isFocused ? .mcBlue : .tvTextSecondary)
                .fontWeight(isSelected || isFocused ? .semibold : .regular)

            Spacer()

            if isSelected {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.mcBlue)
                    .frame(width: 3, height: 24)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isSelected ? Color.mcBlue.opacity(0.08) : (isFocused ? Color.mcBlue.opacity(0.05) : Color.clear))
        .cornerRadius(10)
        .padding(.horizontal, 8)
        .scaleEffect(isFocused ? 1.03 : 1.0)
        .animation(.easeOut(duration: 0.12), value: isFocused)
        .focusable()
    }
}
