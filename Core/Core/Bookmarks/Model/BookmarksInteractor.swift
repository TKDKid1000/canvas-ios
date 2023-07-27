//
// This file is part of Canvas.
// Copyright (C) 2023-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import Combine
import CombineExt

public protocol BookmarksInteractor {
    typealias BookmarkID = String
    func getBookmarks() -> AnyPublisher<[BookmarkItem], Error>
    func addBookmark(title: String, route: String) -> AnyPublisher<BookmarkID, Error>
    func deleteBookmark(id: String) -> AnyPublisher<Void, Error>
    func getBookmark(for route: String) -> AnyPublisher<BookmarkItem?, Never>
    func moveBookmark(fromIndex: Int, toIndex: Int) -> AnyPublisher<[BookmarkItem], Error>
}

struct BookmarksInteractorLive: BookmarksInteractor {
    private let api: API

    public init(api: API) {
        self.api = api
    }

    public func getBookmarks() -> AnyPublisher<[BookmarkItem], Error> {
        ReactiveStore(useCase: GetBookmarks())
            .getEntities()
            .eraseToAnyPublisher()
    }

    public func addBookmark(title: String, route: String) -> AnyPublisher<BookmarkID, Error> {
        let bookmark = APIBookmark(name: title, url: route)
        let request = CreateBookmarkRequest(body: bookmark)

        return api.makeRequest(request)
            .tryCompactMap {
                let value = $0.body.id?.value

                if value == nil {
                    throw NSError.instructureError("Failed to extract bookmark ID from response.")
                }

                return value
            }
            .flatMap { bookmarkId in
                // fetch all bookmarks again to include the new one
                self.getBookmarks()
                    .mapToValue(bookmarkId)
            }
            .eraseToAnyPublisher()
    }

    public func deleteBookmark(id: String) -> AnyPublisher<Void, Error> {
        let useCase = DeleteBookmark(id: id)
        return ReactiveStore(useCase: useCase)
            .getEntities()
            .mapToVoid()
            .eraseToAnyPublisher()
    }

    public func getBookmark(for route: String) -> AnyPublisher<BookmarkItem?, Never> {
        let scope = Scope.where(#keyPath(BookmarkItem.url), equals: route, sortDescriptors: [])
        let useCase = LocalUseCase<BookmarkItem>(scope: scope)
        return ReactiveStore(useCase: useCase)
            .getEntities()
            .map { $0.first }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }

    public func moveBookmark(fromIndex: Int, toIndex: Int) -> AnyPublisher<[BookmarkItem], Error> {
        getBookmarks()
            .compactMap {
                $0.count > fromIndex ? $0[fromIndex] : nil
            }
            .flatMap { [api] in
                let request = UpdateBookmarkRequest(id: $0.id, position: toIndex + 1)
                return api.makeRequest(request)
            }
            .flatMap { _ in
                // fetch all bookmarks again to get the new order
                self.getBookmarks()
            }
            .eraseToAnyPublisher()
    }
}
