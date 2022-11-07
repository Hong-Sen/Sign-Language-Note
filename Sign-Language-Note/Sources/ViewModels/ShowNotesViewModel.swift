//
//  ShowNotesViewModel.swift
//  Sign-Language-Note
//
//  Created by 홍세은 on 2022/11/07.
//

import Foundation

class ShowNotesViewModel {
    static let shared = ShowNotesViewModel()
    private init() {}
    var onUpdated: () -> Void = {}
    
    var noteList: [NoteModel] = []
    {
        didSet {
            onUpdated()
        }
    }
    
    func fetchNoteList() {
        noteList = UserDefaultsManager.shared.load()
    }
}
