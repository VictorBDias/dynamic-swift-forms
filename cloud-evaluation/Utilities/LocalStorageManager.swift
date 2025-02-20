//
//  LocalStorageManager.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 19/02/25.
//

import Foundation

class LocalStorageManager {
    static let shared = LocalStorageManager()
    private init() {}

    private let storageKey = "autosave_form_data"

    /// Save form progress
    func saveFormProgress(for formID: String, data: [String: String]) {
        var savedForms = UserDefaults.standard.dictionary(forKey: storageKey) as? [String: [String: String]] ?? [:]
        savedForms[formID] = data
        UserDefaults.standard.setValue(savedForms, forKey: storageKey)
    }

    /// Retrieve saved form progress
    func getSavedFormProgress(for formID: String) -> [String: String]? {
        let savedForms = UserDefaults.standard.dictionary(forKey: storageKey) as? [String: [String: String]]
        return savedForms?[formID]
    }

    /// Clear saved form progress
    func clearFormProgress(for formID: String) {
        var savedForms = UserDefaults.standard.dictionary(forKey: storageKey) as? [String: [String: String]] ?? [:]
        savedForms.removeValue(forKey: formID)
        UserDefaults.standard.setValue(savedForms, forKey: storageKey)
    }

    /// Check if there is any saved progress
    func hasSavedProgress(for formID: String) -> Bool {
        return getSavedFormProgress(for: formID) != nil
    }
}
