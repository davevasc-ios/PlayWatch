//
//  AccountView.swift
//  PlayWatch
//
//  Created by David on 18/11/25.
//

import SwiftUI

struct AccountView: View {
        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 20) {
                    // Contenido de tu sheet aquí
                    List {
                        Text("Perfil")
                        Text("Configuración")
                        Text("Cerrar Sesión")
                        Text("...en construcción...")
                    }
                    .scrollContentBackground(.hidden)
                }
                .navigationTitle(Text(Localizable.Account.title))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
    }

#Preview {
    AccountView()
}
