import SwiftUI

// MARK: - Focusable card wrapper
// Every card that needs to scroll on tvOS must be focusable.
// This modifier scales the card up and adds shadow when the remote focuses it.
struct TVFocusCard: ViewModifier {
    @Environment(\.isFocused) private var isFocused
    func body(content: Content) -> some View {
        content
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(color: .mcBlue.opacity(isFocused ? 0.28 : 0), radius: isFocused ? 18 : 0, y: isFocused ? 6 : 0)
            .animation(.easeOut(duration: 0.15), value: isFocused)
    }
}
extension View {
    func tvFocusCard() -> some View { modifier(TVFocusCard()) }
}

// MARK: - About
struct AboutContent: View {
    let hospital: HospitalInfo
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(hospital.tagline)
                .font(TVFont.title2)
                .foregroundColor(.mcBlue)
                .fontWeight(.medium)

            HStack(spacing: 16) {
                FocusableStatCard(icon: "bed.double.fill",      value: "\(hospital.beds)",        label: "Licensed Beds")
                FocusableStatCard(icon: "stethoscope",          value: "\(hospital.specialists)+", label: "Specialists")
                FocusableStatCard(icon: "calendar.badge.clock", value: "\(hospital.established)",  label: "Established", iconColor: .mcBlueDark)
                FocusableStatCard(icon: "cross.fill",           value: "24 / 7",                   label: "Emergency",   iconColor: .tvRed)
            }

            AlertBanner(message: "All Mediclinic hospitals are fully equipped with modern diagnostic and surgical facilities.",
                        dotColor: .mcBlue)
        }
    }
}

// Focusable version of VisualStatCard
struct FocusableStatCard: View {
    let icon: String; let value: String; let label: String
    var iconColor: Color = .mcBlue
    @Environment(\.isFocused) private var isFocused
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
        .frame(maxWidth: .infinity)
        .tvCard()
        .tvFocusCard()
        .focusable()
    }
}

// MARK: - Emergency
struct EmergencyContent: View {
    let data: EmergencyData
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 16) {
                FocusableStatCard(icon: "clock.fill",      value: "\(data.waitMinutes) min", label: "Current Wait",     iconColor: .tvAmber)
                FocusableStatCard(icon: "person.3.fill",   value: "\(data.patientsWaiting)", label: "Patients Waiting", iconColor: .mcBlue)
                FocusableStatCard(icon: "cross.case.fill", value: "24 / 7",                  label: "Always Open",      iconColor: .tvRed)
            }

            VStack(spacing: 10) {
                TriageBand(color: .tvRed,      level: "Immediate",                      desc: "Life-threatening")
                TriageBand(color: .tvAmber,    level: "\(data.orangeWaitMinutes) min",  desc: "Urgent")
                TriageBand(color: .tvGreen,    level: "\(data.yellowWaitMinutes) min",  desc: "Semi-urgent")
                TriageBand(color: .tvTextMuted, level: "\(data.greenWaitMinutes) min",  desc: "Non-urgent")
            }

            AlertBanner(message: "Life-threatening emergencies — call 112 immediately.", dotColor: .tvRed)
        }
    }
}

struct TriageBand: View {
    let color: Color; let level: String; let desc: String
    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 4).fill(color).frame(width: 6, height: 36)
            Text(desc).font(TVFont.body).foregroundColor(.tvTextSecondary)
            Spacer()
            Text(level).font(TVFont.headline).foregroundColor(color)
        }
        .padding(.horizontal, 18).padding(.vertical, 12)
        .tvCard()
        .tvFocusCard()
        .focusable()
    }
}

// MARK: - Departments (icon grid)
struct DepartmentsContent: View {
    let departments: [Department]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(departments) { DeptCard(dept: $0) }
        }
    }
}

struct DeptCard: View {
    let dept: Department
    @Environment(\.isFocused) private var isFocused
    var statusColor: Color {
        switch dept.status {
        case .open: return .tvGreen; case .busy: return .tvAmber; case .closed: return .tvRed
        }
    }
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: dept.icon)
                .font(.system(size: 28, weight: .light))
                .foregroundColor(isFocused ? .white : .mcBlue)
                .frame(width: 58, height: 58)
                .background(isFocused ? Color.mcBlue : Color.mcBlue.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            Text(dept.name)
                .font(TVFont.callout)
                .foregroundColor(.tvTextPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            if let floor = dept.floor {
                Text(floor).font(TVFont.micro).foregroundColor(.tvTextMuted)
            }

            HStack(spacing: 4) {
                Circle().fill(statusColor).frame(width: 6, height: 6)
                Text(dept.status.label).font(TVFont.micro).foregroundColor(statusColor)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .tvCard()
        .tvFocusCard()
        .focusable()
    }
}

// MARK: - Doctors
struct DoctorsContent: View {
    let doctors: [Doctor]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(doctors) { DoctorCard(doctor: $0) }
        }
    }
}

struct DoctorCard: View {
    let doctor: Doctor
    @Environment(\.isFocused) private var isFocused
    var statusColor: Color {
        switch doctor.status {
        case .onDuty: return .tvGreen; case .inTheatre: return .tvAmber; case .offDuty: return .tvRed
        }
    }
    var statusText: String {
        switch doctor.status {
        case .onDuty:    return doctor.location ?? "On duty"
        case .inTheatre: return "In theatre" + (doctor.availableAt.map { " · \($0)" } ?? "")
        case .offDuty:   return doctor.availableAt.map { "Returns \($0)" } ?? "Off duty"
        }
    }
    private var initials: String {
        doctor.name.replacingOccurrences(of: "Dr. ", with: "")
            .split(separator: " ").prefix(2).compactMap { $0.first }.map(String.init).joined()
    }
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isFocused ? Color.mcBlue : Color.mcBlue.opacity(0.12))
                    .frame(width: 52, height: 52)
                Text(initials)
                    .font(TVFont.callout)
                    .foregroundColor(isFocused ? .white : .mcBlue)
                    .fontWeight(.semibold)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name).font(TVFont.callout).foregroundColor(.tvTextPrimary)
                Text(doctor.specialty).font(TVFont.caption).foregroundColor(.tvTextMuted)
                HStack(spacing: 5) {
                    Circle().fill(statusColor).frame(width: 6, height: 6)
                    Text(statusText).font(TVFont.caption).foregroundColor(statusColor)
                }
            }
            Spacer()
        }
        .padding(16)
        .tvCard()
        .tvFocusCard()
        .focusable()
    }
}

// MARK: - Visiting Hours
struct VisitingContent: View {
    let entries: [VisitingHoursEntry]
    var body: some View {
        VStack(spacing: 10) {
            ForEach(entries) { VisitingRow(entry: $0) }
        }
    }
}

struct VisitingRow: View {
    let entry: VisitingHoursEntry
    @Environment(\.isFocused) private var isFocused
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "clock")
                .font(.system(size: 18))
                .foregroundColor(isFocused ? .white : .mcBlue)
                .frame(width: 38, height: 38)
                .background(isFocused ? Color.mcBlue : Color.mcBlue.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(entry.ward).font(TVFont.body).foregroundColor(.tvTextPrimary)
                if let notes = entry.notes {
                    Text(notes).font(TVFont.caption).foregroundColor(.tvTextMuted)
                }
            }
            Spacer()
            Text(entry.hours)
                .font(TVFont.callout)
                .foregroundColor(.mcBlue)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 18).padding(.vertical, 14)
        .tvCard()
        .tvFocusCard()
        .focusable()
    }
}

// MARK: - Contact
struct ContactContent: View {
    let hospital: HospitalInfo
    var body: some View {
        VStack(spacing: 12) {
            FocusableInfoRow(icon: "phone.fill",         label: "Main Reception",       value: hospital.phone)
            FocusableInfoRow(icon: "cross.case.fill",    label: "Emergency",            value: hospital.emergency, iconColor: .tvRed)
            FocusableInfoRow(icon: "pill.fill",          label: "After-hours Pharmacy", value: hospital.pharmacy)
            FocusableInfoRow(icon: "mappin.circle.fill", label: "Address",              value: hospital.address)
            FocusableInfoRow(icon: "location.fill",      label: "GPS",                  value: hospital.gps)
        }
    }
}

struct FocusableInfoRow: View {
    let icon: String; let label: String; let value: String
    var iconColor: Color = .mcBlue
    @Environment(\.isFocused) private var isFocused
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(isFocused ? .white : iconColor)
                .frame(width: 40, height: 40)
                .background(isFocused ? iconColor : iconColor.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(TVFont.caption).foregroundColor(.tvTextMuted)
                Text(value).font(TVFont.body).foregroundColor(.tvTextPrimary)
            }
            Spacer()
        }
        .padding(.horizontal, 20).padding(.vertical, 14)
        .tvCard()
        .tvFocusCard()
        .focusable()
    }
}

// MARK: - Patient Services (icon grid)
struct ServicesContent: View {
    let services: [PatientService]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(services) { ServiceCard(service: $0) }
        }
    }
}

struct ServiceCard: View {
    let service: PatientService
    @Environment(\.isFocused) private var isFocused
    var statusColor: Color {
        switch service.status {
        case .open: return .tvGreen; case .busy: return .tvAmber; case .closed: return .tvRed
        }
    }
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: service.icon)
                .font(.system(size: 28, weight: .light))
                .foregroundColor(isFocused ? .white : .mcBlue)
                .frame(width: 58, height: 58)
                .background(isFocused ? Color.mcBlue : Color.mcBlue.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            Text(service.name)
                .font(TVFont.callout)
                .foregroundColor(.tvTextPrimary)
                .multilineTextAlignment(.center)

            Text(service.hours)
                .font(TVFont.micro)
                .foregroundColor(.tvTextMuted)

            HStack(spacing: 4) {
                Circle().fill(statusColor).frame(width: 5, height: 5)
                Text(service.status.label).font(TVFont.micro).foregroundColor(statusColor)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .tvCard()
        .tvFocusCard()
        .focusable()
    }
}

// MARK: - Legacy panel wrappers
struct AboutPanel: View {
    let hospital: HospitalInfo; let departments: [Department]
    var body: some View { AboutContent(hospital: hospital).padding(30) }
}
struct EmergencyPanel: View {
    let data: EmergencyData
    var body: some View { EmergencyContent(data: data).padding(30) }
}
struct DepartmentsPanel: View {
    let departments: [Department]
    var body: some View { DepartmentsContent(departments: departments).padding(30) }
}
struct DoctorsPanel: View {
    let doctors: [Doctor]
    var body: some View { DoctorsContent(doctors: doctors).padding(30) }
}
struct VisitingHoursPanel: View {
    let entries: [VisitingHoursEntry]
    var body: some View { VisitingContent(entries: entries).padding(30) }
}
struct ContactPanel: View {
    let hospital: HospitalInfo
    var body: some View { ContactContent(hospital: hospital).padding(30) }
}
struct ServicesPanel: View {
    let services: [PatientService]
    var body: some View { ServicesContent(services: services).padding(30) }
}
