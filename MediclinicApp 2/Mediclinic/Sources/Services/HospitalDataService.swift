import Foundation
import Combine

@MainActor
class HospitalDataService: ObservableObject {
    @Published var hospital: HospitalInfo      = .current
    @Published var emergency: EmergencyData    = .sample
    @Published var departments: [Department]   = Department.sample
    @Published var doctors: [Doctor]           = Doctor.sample
    @Published var visitingHours: [VisitingHoursEntry] = VisitingHoursEntry.sample
    @Published var services: [PatientService]  = PatientService.sample
    @Published var isLoading: Bool             = false
}
