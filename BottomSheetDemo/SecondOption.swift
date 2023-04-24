//
//  SecondOption.swift
//  BottomSheetDemo
//
//  Created by Camilo Ibarra (External) on 2023-04-24.
//

import SwiftUI

struct BottomSheetView: View {
    var body: some View {
        Home()
    }
}

struct Home: View {
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationView {
            Button {
                showSheet.toggle()
            } label: {
                Text("Present Sheet")
            }
            .navigationTitle("Hald model sheet")
            .halfSheet(showSheet: $showSheet) {
                VStack {
                    Text("Hello 123").font(.title.bold())
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
                    Button(action: {
                    }) {
                        Text("Primary Action")
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.white)
                            .border(Color.black, width: 1)
                    }

                }
                .padding()
            }
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView()
    }
}

extension View {
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()-> SheetView)->some View {
        return self
            .background (
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet)
            )
    }
}

// UIKit integration
struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    var sheetView: SheetView
    @Binding var showSheet: Bool
    
    let controller = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    self.showSheet.toggle()
                }
            }
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
        }
    }
}
