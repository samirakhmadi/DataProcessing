import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, SwiftUI!")
            .padding()
            .onAppear {
                Task {
                    await runTasks()
                }
            }
    }
    
    func exampleTask(id: Int) async {
        print("Starting task \(id)")
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000) // Задержка 2 секунды
        } catch {
            print("Task \(id) failed with error: \(error)")
        }
        print("Task \(id) completed")
    }

    func runTasks() async {
        let taskManager = TaskManager()
        
        for i in 1...5 {
            taskManager.addTask {
                await exampleTask(id: i)
            }
        }
        
        await taskManager.executeTasks()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


