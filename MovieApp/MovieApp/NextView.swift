import SwiftUI

final class NextViewModel: ObservableObject {
    @Published var isActive: Bool = false
    
    func activate() {
        isActive = true
    }
}

struct NextView<Content: View>: View {
    @ObservedObject var viewModel: NextViewModel
    let content: () -> Content
    
    var body: some View {
        NavigationLink(
            isActive: $viewModel.isActive,
            destination: { content() },
            label: { EmptyView() }
        )
    }
}
