//
//  LanguageView.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
//

import SwiftUI

struct LanguageView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(LocaleManager.self) private var languageManager

    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(AppLanguage.allCases) { lang in
                    Button {
                        languageManager.appLanguage = lang
                        dismiss()
                    } label: {
                        HStack {
//                            Text(lang.emoji)
                            Text(lang.rawValue)
                        }
                        .font(.title2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(.horizontal)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    LanguageView()
}
