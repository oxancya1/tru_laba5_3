import SwiftUI

struct SettingsView: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        NavigationView {
            Form {
                Toggle("Theme", isOn: $isDarkMode)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            .toolbar {
                // Додаємо заголовок у верхню панель
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.headline)
                }
            }
        }
    }
}
