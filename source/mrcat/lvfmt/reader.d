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

module mrcat.lvfmt.reader;

import std.array : appender;
import std.exception;
import std.stdio;

import mrcat.lvfmt.object;
import mrcat.lvfmt.level;

Level!T readLevel(T : BaseObject)(inout string filename) {
    File file = File(filename);
    auto l = new Level!T();

    const int width  = file.rawRead(new int[1])[0];
    const int height = file.rawRead(new int[1])[0];
    const byte bitWidth = file.rawRead(new byte[1])[0];
    if (bitWidth % 8 != 0) throw new Exception("Invalid bit width");

    file.rawRead(new byte[3]); // Reserved header space

    const byte bytes = bitWidth / 8;

    l.map = new long[][height];

    for (int y = 0; y < height; y++) {
        l.map[y] = new long[width];
        for (int x = 0; x < width; x++) {
            byte[] buf = new byte[bytes];
            file.rawRead(buf);

            l.map[y][x] = 0;
            for (int i = 0; i < bytes; i++) {
                l.map[y][x] += buf[i] << (bytes - i - 1) * 8;
            }
        }
    }

    auto objects = appender!(T[])();

    // File pointer operations to check for EOF
    FILE* fp = file.getFP();
    int c = getc(fp);

    while (!file.eof()) {
        ungetc(c, fp);
        T obj = new T;
        obj.deserialize(file);
        objects.put(obj);
        c = getc(fp);
    }

    l.objects = objects[];

    return l;
}

version(unittest) {
    class TestObject : BaseObject {
        override void deserialize(File f) {
            lVal = f.rawRead(new long[1])[0];
        }

        override void serialize(File f) {
            f.rawWrite([lVal]);
        }

        long lVal;
    }
}

unittest {
    auto l = readLevel!TestObject("test/map.lft");
    assert(l.map.length == 0x10);
    assert(l.map[0].length == 0x10);
    assert(l.map[4][2] == 0x05);
    assert(l.objects[0].lVal == 0x10);
    assert(l.objects[1].lVal == 0x1000);
}
