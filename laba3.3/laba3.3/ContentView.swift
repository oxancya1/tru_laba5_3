import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()

    var body: some View {
        VStack {
            // Заголовок "Tasks" посередині екрану
            Spacer()
            HStack {
                Spacer()
                Text("Tasks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                Spacer()
            }
            Spacer()

            // Текстове поле для назви задачі
            TextField("Task Name", text: $viewModel.name)
                .textFieldStyle(CustomTextFieldStyle())
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)

            // Текстове поле для опису задачі
            TextField("Description", text: $viewModel.description)
                .textFieldStyle(CustomTextFieldStyle())
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)

            // Кнопка для вибору дати
            Button(action: {
                viewModel.isDatePickerVisible.toggle()
            }) {
                HStack {
                    Text("Due Date: \(viewModel.dateFormatter.string(from: viewModel.date))")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: viewModel.isDatePickerVisible ? "chevron.up" : "chevron.down")
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color.pink.opacity(0.1))
                .cornerRadius(8)
                .shadow(radius: 5)
            }
            .padding(.horizontal)

            // Вибір дати, якщо дата- picker активний
            if viewModel.isDatePickerVisible {
                DatePicker("Select a date", selection: $viewModel.date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }

            // Кнопка для додавання задачі
            Button(action: viewModel.addTask) {
                Text("Add Task")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            
            
            
            
            
            
            // **Кнопки для сортування**
            HStack {
                // Кнопка для сортування за датою
                Button(action: {
                    viewModel.sortTasksByDate()
                }) {
                    Text("Sort by Date")
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }

                // Кнопка для сортування за статусом
                Button(action: {
                    viewModel.sortTasksByStatus()
                }) {
                    Text("Sort by Status")
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            
            
            
            
            
            

            // Список задач
            List {
                ForEach(viewModel.tasks) { task in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(task.name)
                                .font(.headline)
                                .strikethrough(task.status == .completed)
                            Text(task.description)
                                .font(.subheadline)
                            Text("\(task.date, formatter: viewModel.dateFormatter)")
                                .font(.footnote)
                                .foregroundColor(viewModel.dateColor(for: task))

                            Text("Status: \(task.status.rawValue)")
                                .font(.subheadline)
                                .foregroundColor(task.status == .completed ? .green : task.status == .inProgress ? .orange : .red)
                        }
                        Spacer()

                        // Кнопка для зміни статусу
                        Button(action: {
                            viewModel.toggleTaskStatus(task)
                        }) {
                            Text("Change Status")
                                .font(.subheadline)
                                .padding(6)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }

                        // Кнопка для видалення задачі
                        Button(action: {
                            if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                viewModel.deleteTask(at: IndexSet([index]))
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle()) // Для збереження кнопки без стандартних стилів
                    }
                    .padding(8)
                }
                .onDelete(perform: viewModel.deleteTask)
            }
            .frame(maxHeight: 500)

            // Spacer між контентом і кнопкою Settings
            Spacer()

            // Кнопка для налаштувань внизу
            Button(action: openSetting) {
                HStack {
                    Text("Settings")
                        .foregroundColor(.white)
                    Image(systemName: viewModel.isSettingsVisible ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
                .padding(8)
                .background(Color.black)
                .cornerRadius(8)
            }
            .frame(width: 120, height: 40)
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color.gray.opacity(0.05)) // Легкий фон для всього екрану
        .cornerRadius(20)
        .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
        .sheet(isPresented: $viewModel.isSettingsVisible) {
            SettingsView(isDarkMode: $viewModel.isDarkMode)
        }
        .onAppear {
            viewModel.loadTasks()
        }
    }

    
    
    private func openSetting() {
        withAnimation {
            viewModel.isSettingsVisible.toggle()
        }
    }
}

