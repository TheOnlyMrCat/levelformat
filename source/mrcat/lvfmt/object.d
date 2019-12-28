// Level Format: A basic API for 2D tile-based games
// Copyright (C) 2019  TheOnlyMrCat
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

module mrcat.lvfmt.object;

import std.stdio;

interface BaseObject {
    /// Create from serialized file data.
    /// The file will be initialized to the start of the object's data
    void deserialize(File f);

    /// Write data about the object to a file
    void serialize(File f);
}