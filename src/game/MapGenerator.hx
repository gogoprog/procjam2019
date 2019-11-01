package game;

import phaser.geom.Rectangle;

enum Tile {
    Empty;
    Room;
    Door;
}

class Map {
    public var grid:Array<Array<Tile>>;
    public var width:Int;
    public var height:Int;

    public function new(w, h) {
        this.width = w;
        this.height = h;
        grid = new Array<Array<Tile>>();

        for(y in 0...height) {
            grid[y] = new Array<Tile>();
        }
    }

    public inline function setTile(x:Int, y:Int, t:Tile) {
        grid[y][x] = t;
    }
    public inline function getTile(x:Int, y:Int):Tile {
        return grid[y][x];
    }

    public function fillTiles(rect:Rectangle, t:Tile) {
        var sx = Std.int(rect.x);
        var sy = Std.int(rect.y);

        for(y in 0...Std.int(rect.height)) {
            for(x in 0...Std.int(rect.width)) {
                setTile(sx+x, sy+y, t);
            }
        }
    }

}

class MapGenerator {

    public function new() {
    }

    public function generate():Map {
        var w = 128;
        var h = 64;
        var rects = new Array<Rectangle>();
        var map = new Map(w, h);

        for(i in 0...4) {
            var rect = getRandomRectangle(map);
            map.fillTiles(rect, Room);
            trace(rect);
        }

        return map;
    }

    static private inline function getRandomRectangle(map):Rectangle {
        var x = Std.random(map.width - 2);
        var y = Std.random(map.height - 2);
        var w = Std.random(map.width - x);
        var h = Std.random(map.height - y);
        var rect = new Rectangle(x, y, w, h);
        return rect;
    }
}
