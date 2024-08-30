import SwiftUI

struct MovieListCell: View {
    let movie: MovieViewData
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            AsyncImage(url: movie.imageURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 150)
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .fontWeight(.bold)
                Text(movie.formattedReleaseDate)
            }
            
            Spacer()
        }
    }
}

struct Previews: PreviewProvider {
    static let movie = MovieViewData(
        id: UUID(),
        title: "The Shawshank Redemption",
        releaseDate: Date(timeIntervalSince1970: 759276000),
        imageURL: URL(string: "https://image.tmdb.org/t/p/w185/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg")!,
        overview: "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.")
    
    static var previews: some View {
        MovieListCell(movie: movie)
            .previewLayout(.sizeThatFits)
    }
}


