import SwiftUI

final class NextViewModel: ObservableObject {
    @Published var isActive: Bool = false
    
    func activate() {
        isActive = true
    }
}

struct NextView<Content: View>: View {
//    @ObservedObject var viewModel: NextViewModel
    @Binding var isActive: Bool
    let content: () -> Content
    
    var body: some View {
        NavigationLink(
            isActive: $isActive,
            destination: { content() },
            label: { EmptyView() }
        )
    }
}
