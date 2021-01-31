//
//  NoteCellView.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Foundation
import SwiftUI
import Combine

struct NoteItemView: View {
    
    var item: Note
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title ?? "")
                Text(item.date?.toStringDate() ?? "")
            }
            .background(Color.blue)
            Spacer()
        }
        .padding()
    }
}

struct NoteItemView_Previews: PreviewProvider {
    static var previews: some View {
        NoteItemView(item: Note())
    }
}
