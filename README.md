# Level Format

[![Build Status](https://travis-ci.org/TheOnlyMrCat/levelformat.svg?branch=master)](https://travis-ci.org/TheOnlyMrCat/levelformat)
[![Dub package](https://img.shields.io/dub/dt/level_format)](https://code.dlang.org/packages/level_format)

This is a simple library which provides an interface to a custom file format designed for levels in 2D games.
At the moment, the file format can only be reasonably used in a hexadecimal editor, as it is a binary format,
as opposed to a text format.

## Basic usage

A typical file looks like this:

```text
Header

Map

Objects
```

### Header section

The header section consists of two little-endian integers, one byte, and three more unused bytes. The integers
are the dimensions for the map, the first being the width, the second being the height. The next byte denotes
the size in bits of each map cell, the maximum being 64 bits.
