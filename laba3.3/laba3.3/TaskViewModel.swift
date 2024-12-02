import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var isDatePickerVisible = false
    @Published var isSettingsVisible = false
    @Published var isDarkMode = false

    private let fileManager = FileManager.default
    public let dateFormatter: DateFormatter

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        loadTasks()
    }

    // Додавання нового завдання
    func addTask() {
        let newTask = Task(name: name, description: description, date: date)
        tasks.append(newTask)
        name = ""
        description = ""
        date = Date()
        saveTasks()
    }

    // Завантаження завдань із файлу
    internal func loadTasks() {
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("tasks.json")

            if fileManager.fileExists(atPath: fileURL.path) {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let data = try Data(contentsOf: fileURL)
                    tasks = try decoder.decode([Task].self, from: data)
                } catch {
                    print("Помилка при завантаженні JSON файлу: \(error)")
                }
            }
        }
    }

    // Збереження завдань у файл
    internal func saveTasks() {
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("tasks.json")

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            do {
                let data = try encoder.encode(tasks)
                try data.write(to: fileURL)
            } catch {
                print("Помилка при збереженні JSON файлу: \(error)")
            }
        }
    }

    // Видалення завдання
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }

    // Метод для зміни статусу виконання завдання
    func toggleTaskStatus(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            // Перемикаємо статус
            switch tasks[index].status {
            case .notStarted:
                tasks[index].status = .inProgress
            case .inProgress:
                tasks[index].status = .completed
            case .completed:
                tasks[index].status = .notStarted
            }
            saveTasks() // Зберігаємо зміни
        }
    }

    // Метод для визначення кольору для дати завдання
    func dateColor(for task: Task) -> Color {
        return task.date < Date() ? .red : .primary
    }
    
    
    
    
    
    // Сортування за датою
    func sortTasksByDate() {
        tasks.sort { $0.date < $1.date }
    }

    // Сортування за статусом
    func sortTasksByStatus() {
        tasks.sort {
            switch ($0.status, $1.status) {
            case (.notStarted, .notStarted), (.inProgress, .inProgress), (.completed, .completed):
                return false
            case (.notStarted, _):
                return true
            case (.inProgress, .completed):
                return true
            case (.completed, .notStarted):
                return false
            case (.inProgress, .notStarted):
                return false
            case (.completed, .inProgress):
                return false
            }
        }
    }
}
