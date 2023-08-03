import SwiftUI

struct XDismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle((Color.black.opacity(0.15)))

            Image(systemName: "xmark")
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .foregroundColor(.white)
                .imageScale(.medium)
                .frame(width: 44, height: 44)
        }
    }
}

struct XDismissButton_Previews: PreviewProvider {
    static var previews: some View {
        XDismissButton()
    }
}
