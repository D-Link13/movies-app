import SwiftUI

final class MovieDetailsViewModel: ObservableObject {
    @Published var overview: String = ""
    @Published var navigationTitle: String = ""
}

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        Text(viewModel.overview)
            .padding()
    }
}

#Preview {
    let model = MovieDetailsViewModel()
    model.overview = "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope."
    return MovieDetailsView(viewModel: model)
}
