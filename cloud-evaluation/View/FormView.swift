//
//  FormView.swift
//  cloud-evaluation
//
//  Created by Victor Batisttete Dias on 15/02/25.
//

import SwiftUI
import CoreData

struct FormView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FormEntity.timestamp, ascending: true)],
        animation: .default)
    private var forms: FetchedResults<FormEntity>

    var body: some View {
        NavigationView {
            List {
                ForEach(forms) { form in
                    NavigationLink(destination: FormEntriesView(form: form)) {
                        VStack(alignment: .leading) {
                            Text(form.title ?? "Untitled Form")
                                .font(.headline)
                            if let timestamp = form.timestamp {
                                Text(timestamp, formatter: itemFormatter)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Forms")
        }
    }

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

}
