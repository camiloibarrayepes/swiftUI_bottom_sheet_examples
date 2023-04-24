//
//  ContentView.swift
//  BottomSheetDemo
//
//  Created by Camilo Ibarra (External) on 2023-04-24.
//

import SwiftUI

struct ContentView: View {

    @State var cardShown = false
    @State var cardDismissal = false

    var body: some View {
        NavigationView {
            ZStack {
                Button(action: {
                    cardShown.toggle()
                    cardDismissal.toggle()
                }, label: {
                    Text("Show Card")
                        .bold()
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 30)
                        .background(Color.blue)
                })
                BottomCard(cardShown: $cardShown,
                           cardDismissal: $cardDismissal,
                           height: 400) {
                    CardContent()
                        .padding()
                }
            }
            .animation(.default)
            .background(Color.black)
        }
    }
}

struct CardContent: View {
    var body: some View {
        VStack {
            Text("Header title")
            ScrollView {
                Text(
                """
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the
                industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and
                scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into
                electronic typesetting, remaining essentially unchanged.
                """
                )
            }
            .padding()
            .frame(width: .infinity)
//            .frame(height: 200)
            
            Button("my button") {
                
            }
            
        }
        .frame(width: UIScreen.main.bounds.width, height: 300)
    }
}

struct BottomCard<Content: View>: View {
    let content: Content
    @Binding var cardShown: Bool
    @Binding var cardDismissal: Bool
    let height: CGFloat
    
    init(cardShown: Binding<Bool>,
         cardDismissal: Binding<Bool>,
         height: CGFloat,
         @ViewBuilder content: () -> Content) {
        self.height = height
        _cardShown = cardShown
        _cardDismissal = cardDismissal
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            withAnimation(.easeIn) {
                GeometryReader { _ in
                    EmptyView()
                }
            }
            .background(Color.gray.opacity(0.2))
            .opacity(cardShown ? 1 : 0)
            .onTapGesture {
                cardDismissal.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    cardShown.toggle()
                }
            }
            // Card
            VStack {
                Spacer()
                withAnimation(Animation.default.delay(0.2)) {
                    VStack {
                        content
                        Button(action: {
                            cardShown.toggle()
                        }, label: {
                            Text("Dismissq")
                                .foregroundColor(Color.white)
                                .frame(width: UIScreen.main.bounds.width/2, height: 50)
                                .cornerRadius(8)
                        })
                    }
                    .background(Color.white)
                    .frame(height: height)
                    .offset(y: cardShown && cardDismissal ? 0 : height)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
