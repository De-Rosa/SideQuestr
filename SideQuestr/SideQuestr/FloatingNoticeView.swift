import SwiftUI

struct FloatingNotice: View {
    @Binding var showingNotice: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "checkmark")
                .foregroundColor(.white)
                .font(.system(size: 48, weight: .regular))
                .padding(EdgeInsets(top: 20, leading: 5, bottom: 5, trailing: 5))
            Text("Quest 2 Complete")
                .foregroundColor(.white)
                .font(.callout)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
        }
        .background(Color.noticeColor.opacity(0.75))
        .cornerRadius(5)
        .frame(maxWidth: 200) // Optional: set a max width for the notice
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showingNotice = false
            })
        })
    }
}

extension Color {
    static let noticeColor = Color(red: 0.0, green: 0.5, blue: 0.0) // Custom snackbar color
}
