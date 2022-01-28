//
//  ContentView.swift
//  MyAsset
//
//  Created by UAPMobile on 2022/01/27.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .asset  // default 값은 asset
    
    enum Tab {
        case asset
        case recommend
        case alert
        case setting
    }
    
    var body: some View {
        TabView(selection: $selection) {
            AssetView() // Asset view
                .tabItem {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("자산")
                }
                .tag(Tab.asset)
            
            Color.blue
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .tabItem {
                    Image(systemName: "hand.thumbsup.fill")
                    Text("추천")
                }
                .tag(Tab.recommend)
            
            Color.yellow
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("알림")
                }
                .tag(Tab.alert)
            
            Color.gray
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("설정")
                }
                .tag(Tab.setting)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
