//
//  FormDetailView.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 14/02/25.
//

import SwiftUI

struct FormDetailView: View {
    let form: FormEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(form.title ?? "Untitled Form")
                .font(.largeTitle)
                .bold()
            
            if let timestamp = form.timestamp {
                Text("Created on \(timestamp, formatter: itemFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            List {
                Section(header: Text("Fields")) {
                    ForEach(form.fieldsArray, id: \.uuid) { field in
                        Text(field.label ?? "Unnamed Field")
                    }
                }

                Section(header: Text("Sections")) {
                    ForEach(form.sectionsArray, id: \.uuid) { section in
                        Text(section.title ?? "Untitled Section")
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Form Details")
    }
}

extension FormEntity {
    var fieldsArray: [FieldEntity] {
        (fields as? Set<FieldEntity>)?.sorted { $0.label ?? "" < $1.label ?? "" } ?? []
    }
    
    var sectionsArray: [SectionEntity] {
        (sections as? Set<SectionEntity>)?.sorted { $0.index < $1.index } ?? []
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
