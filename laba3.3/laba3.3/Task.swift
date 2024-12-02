import Foundation

enum TaskStatus: String, Codable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"
}

// Модель Task, яка представляє завдання.
struct Task: Identifiable, Codable {
    var id = UUID()
    let name: String
    let description: String
    let date: Date
    //var isCompleted: Bool = false
    var status: TaskStatus = .notStarted  // Статус завдання
    

    // Ініціалізатор
       init(id: UUID = UUID(), name: String, description: String, date: Date, status: TaskStatus = .notStarted) {
           self.id = id
           self.name = name
           self.description = description
           self.date = date
           self.status = status
       }
   }
