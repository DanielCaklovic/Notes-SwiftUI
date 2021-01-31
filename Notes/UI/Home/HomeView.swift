//
//  ContentView.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import SwiftUI
import CoreData
import Resolver

struct HomeView: View {
    @SwiftUI.Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var homeVM: HomeVM = Resolver.resolve()

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Note.date, ascending: true)],
//        animation: .default)
    var body: some View {
        NavigationView {
            VStack {
                NoteList(notes: $homeVM.notes)
            }
            .navigationBarItems(trailing: (
                NavigationLink(
                    destination: EditNoteView(),
                    label: {
                        Image(systemName: "plus")
                    })
            ))
            .background(Color.red)
            .navigationBarTitle("Notes", displayMode: .inline)
        }
    }

    private func addItem() {
        withAnimation {
//            let newItem = Note(context: viewContext)
//            newItem.date = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct NoteList: View {
    @Binding var notes: [Note]
    
    var body: some View {
        if !notes.isEmpty {
            List {
                ForEach(notes) { item in
                    NoteItemView(item: item)
                }
    //            .onDelete(perform: deleteItems)
            }
        } else {
            Text("You don't have any notes. \nAdd a new note using the + button.")
        }
    }
}

struct HomeView_Previews: PreviewProvider { 
    static var previews: some View {
        HomeView()
    }
}
