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

import Core
import XCTest

class UIBarButtonItemExtensionsTests: XCTestCase {

    func testBackButton() {
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        let backImage = UIImage(systemName: "chevron.backward", withConfiguration: config)

        let testee = UIBarButtonItem.back(target: self, action: #selector(testBackButton))

        XCTAssertEqual(testee.image, backImage)
        XCTAssertEqual(testee.landscapeImagePhone, backImage)
        XCTAssertEqual(testee.target as? UIBarButtonItemExtensionsTests, self)
        XCTAssertEqual(testee.action, #selector(testBackButton))
        XCTAssertEqual(testee.style, .plain)
    }
}
