//
// This file is part of Canvas.
// Copyright (C) 2022-present  Instructure, Inc.
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

import Foundation

public struct APIDashboardCardPositions: Codable {
    public typealias CourseCode = String
    public typealias Position = Int
    public let dashboard_positions: [CourseCode: Position]
}

public struct PutDashboardCardPositionsRequest: APIRequestable {
    public typealias Response = APINoContent

    public var path: String { "users/self/dashboard_positions" }
    public var method: APIMethod { .put }
    public let body: APIDashboardCardPositions?
}
