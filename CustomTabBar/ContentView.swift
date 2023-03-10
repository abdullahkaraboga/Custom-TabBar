//
//  ContentView.swift
//  CustomTabBar
//
//  Created by Abdullah Karaboğa on 27.01.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        Home()
    }

    struct Home: View {

        @State var selectedTab = "Home"
        var edges = UIApplication.shared.windows.first?.safeAreaInsets
        @Namespace var animation
        @StateObject var modelData = ModelView()

        fileprivate func extractedFunc() -> Text {
            return Text("Search")
        }
        
        var body: some View {

            VStack(spacing: 0) {
                GeometryReader { _ in

                    ZStack {
                        NavigationView {
                            ScrollView {
                                ForEach(1...30, id: \.self) { i in
                                    NavigationLink(destination: Text("List item : \(i)")) {
                                        VStack(alignment: .leading) {
                                            Text("List item : \(i)")
                                                .padding(.all, 8)
                                                .foregroundColor(.black)
                                            Divider()
                                        }
                                    }
                                }
                                    .padding(.bottom)
                            }
                                .navigationBarHidden(true)
                        }
                            .opacity(selectedTab == "Home" ? 1 : 0)

                        extractedFunc()
                            .opacity(selectedTab == "Search" ? 1 : 0)

                        Text("Options")
                            .opacity(selectedTab == "Options" ? 1 : 0)
                    }
                }
                    .onChange(of: selectedTab) { (_) in
                    switch (selectedTab) {
                    case "Search": if !modelData.isSearchLoad { modelData.searchLoad() }
                    case "Options": if !modelData.isOptionsLoad { modelData.optionsLoad() }
                    default: ()
                    }

                }


                HStack(spacing: 0) {
                    ForEach(tabs, id: \.self) { tab in

                        TabButton(title: tab, selectedTab: $selectedTab, animation: animation)

                        if tab != tabs.last {
                            Spacer(minLength: 0)
                        }
                    }
                }
                    .padding(.horizontal, 30)
                    .padding(.bottom, edges?.bottom == 0 ? 15 : edges?.bottom)
                    .background(Color.white)
            }
                .ignoresSafeArea(.all, edges: .bottom)
                .background(Color.black.opacity(0.06).ignoresSafeArea(.all, edges: .all))
        }

    }

    struct TabButton: View {
        var title: String
        @Binding var selectedTab: String
        var animation: Namespace.ID

        var body: some View {
            Button(action: {
                withAnimation { selectedTab = title }
            }) {
                VStack(spacing: 6) {

                    ZStack {
                        CustomShape()
                            .fill(Color.clear)
                            .frame(width: 45, height: 6)
                        if selectedTab == title {
                            CustomShape()
                                .fill(Color.yellow)
                                .frame(width: 45, height: 6)
                                .matchedGeometryEffect(id: "Tab_Change", in: animation)
                        }
                    }
                        .padding(.bottom, 10)


                    Image(title)
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(selectedTab == title ? Color(.black) : Color.black.opacity(0.5))
                        .frame(width: 20, height: 20)
                    Text(title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black.opacity(selectedTab == title ? 0.6 : 0.2))
                }
            }
        }
    }

    struct CustomShape: Shape {
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
            return Path(path.cgPath)
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

let tabs = ["Home", "Search", "Options"]

class ModelView: ObservableObject {
    @Published var isSearchLoad = false
    @Published var isOptionsLoad = false

    init() {
        print("Home Data Loaded")
    }

    func searchLoad() {
        print("Search load")
        isSearchLoad = true
    }

    func optionsLoad() {
        print("Options load")
        isOptionsLoad = true
    }

}
