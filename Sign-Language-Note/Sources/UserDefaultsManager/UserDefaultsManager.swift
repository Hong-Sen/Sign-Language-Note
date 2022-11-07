//
//  UserDefaultsManager.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2022/11/07.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    func save(_ notes: [NoteModel]) {
        let data = notes.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: "notes")
    }

    func load() -> [NoteModel] {
        guard let encodedData = UserDefaults.standard.array(forKey: "notes") as? [Data] else {
            return []
        }

        return encodedData.map { try! JSONDecoder().decode(NoteModel.self, from: $0) }
    }
}
