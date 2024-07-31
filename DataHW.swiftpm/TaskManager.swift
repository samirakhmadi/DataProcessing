//
//  TaskManager.swift
//  DataHW
//
//  Created by Samir on 30.07.2024.
//

import Foundation

class TaskManager {
    private let queue = DispatchQueue(label: "taskQueue", attributes: .concurrent)
    private let semaphore = DispatchSemaphore(value: 1)
    private var tasks: [() async -> Void] = []

    func addTask(_ task: @escaping () async -> Void) {
        queue.async {
            self.semaphore.wait()
            self.tasks.append(task)
            self.semaphore.signal()
        }
    }

    func executeTasks() async {
        await withTaskGroup(of: Void.self) { group in
            semaphore.wait()
            for task in tasks {
                group.addTask {
                    await task()
                }
            }
            tasks.removeAll()
            semaphore.signal()
            
            for await _ in group {
                print("Task completed")
            }
        }
    }
}

