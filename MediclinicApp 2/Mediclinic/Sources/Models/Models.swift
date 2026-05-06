import Foundation

// MARK: - Hospital Info
struct HospitalInfo {
    let name: String
    let tagline: String
    let address: String
    let gps: String
    let phone: String
    let emergency: String
    let pharmacy: String
    let beds: Int
    let specialists: Int
    let established: Int

    static let current = HospitalInfo(
        name:        "Mediclinic",
        tagline:     "Passion. People. Progress.",
        address:     "Replace with hospital address",
        gps:         "Replace with GPS coordinates",
        phone:       "Replace with main number",
        emergency:   "Replace with emergency number",
        pharmacy:    "Replace with pharmacy number",
        beds:        240,
        specialists: 180,
        established: 1983
    )
}

// MARK: - Department
enum DepartmentStatus { case open, busy, closed }
extension DepartmentStatus {
    var label: String {
        switch self { case .open: return "Open"; case .busy: return "Busy"; case .closed: return "Closed" }
    }
}

struct Department: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let floor: String?
    let phone: String?
    var status: DepartmentStatus = .open
}

extension Department {
    static let sample: [Department] = [
        Department(name: "Emergency",            icon: "cross.case.fill",      floor: "Ground Floor", phone: nil,           status: .open),
        Department(name: "Cardiology",           icon: "heart.fill",           floor: "Level 2",      phone: nil,           status: .open),
        Department(name: "Orthopaedics",         icon: "figure.walk",          floor: "Level 3",      phone: nil,           status: .busy),
        Department(name: "Maternity",            icon: "figure.2.and.child.holdinghands", floor: "Level 4", phone: nil,      status: .open),
        Department(name: "Oncology",             icon: "waveform.path.ecg",    floor: "Level 5",      phone: nil,           status: .open),
        Department(name: "Radiology & Imaging",  icon: "rays",                 floor: "Level 1",      phone: nil,           status: .open),
        Department(name: "ICU",                  icon: "waveform.path",        floor: "Level 2",      phone: nil,           status: .busy),
        Department(name: "Physiotherapy",        icon: "figure.strengthtraining.traditional", floor: "Level 1", phone: nil, status: .open),
        Department(name: "Pathology Lab",        icon: "testtube.2",           floor: "Ground Floor", phone: nil,           status: .open),
        Department(name: "Pharmacy",             icon: "pill.fill",            floor: "Ground Floor", phone: nil,           status: .open),
    ]
}

// MARK: - Doctor
enum DoctorStatus { case onDuty, inTheatre, offDuty }

struct Doctor: Identifiable {
    let id = UUID()
    let name: String
    let specialty: String
    var status: DoctorStatus = .onDuty
    var location: String?
    var availableAt: String?
}

extension Doctor {
    static let sample: [Doctor] = [
        Doctor(name: "Dr. A. Smith",    specialty: "Cardiologist",     status: .onDuty,    location: "Cardiology Ward"),
        Doctor(name: "Dr. B. Jones",    specialty: "Orthopaedic Surgeon", status: .inTheatre, availableAt: "14:00"),
        Doctor(name: "Dr. C. Williams", specialty: "Oncologist",       status: .onDuty,    location: "Level 5"),
        Doctor(name: "Dr. D. Brown",    specialty: "Obstetrician",     status: .onDuty,    location: "Maternity"),
        Doctor(name: "Dr. E. Taylor",   specialty: "Intensivist",      status: .inTheatre, availableAt: "15:30"),
        Doctor(name: "Dr. F. Anderson", specialty: "Radiologist",      status: .onDuty,    location: "Radiology"),
        Doctor(name: "Dr. G. Thomas",   specialty: "Physiotherapist",  status: .offDuty,   availableAt: "Tomorrow 08:00"),
        Doctor(name: "Dr. H. Jackson",  specialty: "Pathologist",      status: .onDuty,    location: "Lab"),
    ]
}

// MARK: - Visiting Hours
struct VisitingHoursEntry: Identifiable {
    let id = UUID()
    let ward: String
    let hours: String
    let notes: String?
}

extension VisitingHoursEntry {
    static let sample: [VisitingHoursEntry] = [
        VisitingHoursEntry(ward: "General Wards",    hours: "15:00 – 16:00  |  19:00 – 20:00", notes: "Max 2 visitors"),
        VisitingHoursEntry(ward: "Maternity",        hours: "10:00 – 11:00  |  15:00 – 16:00", notes: "Partner only outside hours"),
        VisitingHoursEntry(ward: "ICU / High Care",  hours: "12:00 – 13:00  |  17:00 – 18:00", notes: "Next of kin only"),
        VisitingHoursEntry(ward: "Paediatrics",      hours: "10:00 – 12:00  |  15:00 – 17:00", notes: "Parents unrestricted"),
        VisitingHoursEntry(ward: "Oncology",         hours: "10:00 – 20:00",                    notes: "Quiet times 13:00 – 14:00"),
        VisitingHoursEntry(ward: "Day Surgery",      hours: "Arranged with nursing staff",      notes: nil),
    ]
}

// MARK: - Patient Services
struct PatientService: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let hours: String
    let description: String
    var status: DepartmentStatus = .open
}

extension PatientService {
    static let sample: [PatientService] = [
        PatientService(name: "Pharmacy",           icon: "pill.fill",           hours: "07:00 – 22:00", description: "Prescription & OTC medicines",   status: .open),
        PatientService(name: "Cafeteria",          icon: "fork.knife",          hours: "06:30 – 20:00", description: "Hot meals, snacks & beverages",   status: .open),
        PatientService(name: "Patient WiFi",       icon: "wifi",                hours: "24 hours",      description: "Free throughout the hospital",    status: .open),
        PatientService(name: "Chaplaincy",         icon: "heart.circle.fill",   hours: "08:00 – 17:00", description: "Spiritual care & counselling",    status: .open),
        PatientService(name: "Social Work",        icon: "person.2.fill",       hours: "08:00 – 16:00", description: "Discharge planning & support",    status: .open),
        PatientService(name: "Parking",            icon: "car.fill",            hours: "24 hours",      description: "Covered & open parking available", status: .open),
        PatientService(name: "ATM",                icon: "banknote.fill",       hours: "24 hours",      description: "Located near main entrance",      status: .open),
        PatientService(name: "Gift Shop",          icon: "gift.fill",           hours: "09:00 – 18:00", description: "Flowers, gifts & magazines",      status: .open),
    ]
}

// MARK: - Emergency Data
struct EmergencyData {
    var waitMinutes: Int
    var patientsWaiting: Int
    var orangeWaitMinutes: Int
    var yellowWaitMinutes: Int
    var greenWaitMinutes: Int

    static let sample = EmergencyData(waitMinutes: 18, patientsWaiting: 7,
                                      orangeWaitMinutes: 20, yellowWaitMinutes: 45, greenWaitMinutes: 90)
}
