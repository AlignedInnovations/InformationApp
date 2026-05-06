import SwiftUI

struct ContentView: View {
    @State private var selectedSection: NavSection = .about
    @StateObject private var dataService = HospitalDataService()

    var body: some View {
        HStack(spacing: 0) {
            SidebarView(selected: $selectedSection, hospital: dataService.hospital)
                .frame(width: 280)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Section header
                    HStack(spacing: 14) {
                        Image(systemName: selectedSection.icon)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(selectedSection.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(selectedSection.rawValue)
                                .font(TVFont.title)
                                .foregroundColor(.tvTextPrimary)
                            Text(dataService.hospital.name)
                                .font(TVFont.caption)
                                .foregroundColor(.tvTextMuted)
                        }
                        Spacer()
                        if dataService.isLoading { LiveChip() }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 36)
                    .padding(.bottom, 24)

                    // Panel content
                    Group {
                        switch selectedSection {
                        case .about:
                            AboutContent(hospital: dataService.hospital).padding(.horizontal, 30)
                        case .emergency:
                            EmergencyContent(data: dataService.emergency).padding(.horizontal, 30)
                        case .departments:
                            DepartmentsContent(departments: dataService.departments).padding(.horizontal, 30)
                        case .doctors:
                            DoctorsContent(doctors: dataService.doctors).padding(.horizontal, 30)
                        case .visiting:
                            VisitingContent(entries: dataService.visitingHours).padding(.horizontal, 30)
                        case .contact:
                            ContactContent(hospital: dataService.hospital).padding(.horizontal, 30)
                        case .services:
                            ServicesContent(services: dataService.services).padding(.horizontal, 30)
                        }
                    }
                    .padding(.bottom, 60)
                }
                // focusSection tells tvOS this VStack is a scrollable focus region —
                // the scroll view will automatically follow focus as the remote moves
                // through child views.
                .focusSection()
            }
            .background(Color.tvBackground)
        }
        .background(Color.tvBackground)
        .ignoresSafeArea()
    }
}
