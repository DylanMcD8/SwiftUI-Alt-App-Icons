//
//  AppIconsView.swift
//  Alternate App Icons in SwiftUI
//
//  Created by Dylan McDonald
//  and ChatGPT (basic interface code) on 3/30/25.
//

import SwiftUI

// App icon names used in Assets
let iconNames = ["Mac", "iPhone", "iPad", "Watch", "Vision"]

struct AppIconsView: View {
    @State private var selectedIcon: String? = nil
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(iconNames, id: \ .self) { icon in
                        IconView(iconName: icon + " Icon", isSelected: selectedIcon == icon)
                            .onTapGesture {
                                selectedIcon = icon
                                setAlternateIcon(icon)
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Select App Icon")
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
    
    // Function to set the alternate icon
    func setAlternateIcon(_ iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons else {
            // Alternate app icons are ONLY supported on iOS, iPadOS, and iOS apps on Macs with Apple Silicon (NOT Mac Catalyst)
            print("Alternate icons not supported.")
            return
        }
        
        // If you want to revert to the default icon, call setAlternateIconName(nil)
        // "Mac" is the default icon, so I use nil instead. Setting "Mac" does not work.
        UIApplication.shared.setAlternateIconName(iconName == "Mac" ? nil : iconName) { error in
            if let error = error {
                print("Error setting icon: \(error.localizedDescription)")
            } else {
                print("Success! \(iconName) icon is now set.")
            }
        }
    }
}

struct IconView: View {
    let iconName: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .cornerRadius(16)
                .frame(width: 70, height: 70)
            
            Text(iconName)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 5)
        }
        .frame(maxWidth: .infinity) // Make the cell fill up the available width
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(isSelected ? Color.accent.opacity(0.2) : Color(uiColor: .secondarySystemGroupedBackground)))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.accent : Color.clear, lineWidth: 3)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconsView()
    }
}
