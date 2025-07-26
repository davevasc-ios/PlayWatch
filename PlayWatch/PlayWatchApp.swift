//
//  PlayWatchApp.swift
//  PlayWatch
//
//  Created by David on 17/3/24.
//

import SwiftUI
import SwiftData

@main
struct PlayWatchApp: App {
    
    @State private var appViewModel: AppViewModel
    private let modelContainer: ModelContainer
    
    init() {
        do {
            // 2. Define el esquema y la configuración de la base de datos.
            let schema = Schema([
                SettingsModel.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            // 3. Crea las dependencias en orden, de menor a mayor nivel.
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let storageUtility = StorageUtility(context: container.mainContext)
            let viewModel = AppViewModel.production(storageUtility: storageUtility)
            
            // 4. Asigna los objetos creados a las propiedades de la App.
            //    Usamos _appViewModel porque es un @State.
            self.modelContainer = container
            self._appViewModel = State(initialValue: viewModel)
            
        } catch {
            // Un fatalError aquí es apropiado, porque si la base de datos
            // no se puede crear, la aplicación no puede funcionar.
            fatalError("No se pudo crear el ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if appViewModel.settingsModelLogic.initializationState == .loaded {
                GeometryReader { geometry in
                    TabBarView()
                        .environment(\.locale, appViewModel.settingsModelLogic.appLocale)
                        .environment(\.screenSize, geometry.size)
                        .environment(appViewModel)
                }
            } else {
                ProgressView()
                    .onAppear() {
                        appViewModel.settingsModelLogic.on(.initialize)
                    }
            }
        }
        .modelContainer(modelContainer)
    }
}
