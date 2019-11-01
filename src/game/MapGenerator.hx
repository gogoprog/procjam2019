package game;

import phaser.geom.Rectangle;

enum Tile {
    Empty;
    Room;
    Door;
    Corridor;
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
        var lastType:Tile = Corridor;
        var lastRectangle:Rectangle;

        while(rects.length < 8) {
            var r = Std.random(2);
            lastRectangle = rects[rects.length - 1];

            switch(r) {
                case 0: {
                    var rect = getRandomRectangle(map, 48, 48);

                    if(!collides(rect, rects)) {
                        map.fillTiles(rect, Room);
                        rects.push(rect);
                    }
                }

                case 1: {
                    var r2:Bool = Std.random(2) == 0;
                    var rect = getRandomRectangle(map, r2 ? 4 : 48, r2 ? 48:4);

                    if(lastRectangle != null) {
                        var c = untyped Phaser.Geom.Intersects.RectangleToRectangle(rect, lastRectangle);

                        if(c) {
                            map.fillTiles(rect, Room);
                            rects.push(rect);
                        }
                    }
                }
            }
        }

        return map;
    }

    static private function getRandomInt(min, max):Int {
        return min + Std.random(max - min);
    }

    static private inline function getRandomRectangle(map, maxWidth, maxHeight):Rectangle {
        var x = Std.random(map.width - 2);
        var y = Std.random(map.height - 2);
        var w = Std.random(cast Math.min(maxWidth, map.width - x));
        var h = Std.random(cast Math.min(maxHeight, map.height - y));
        var rect = new Rectangle(x, y, w, h);
        return rect;
    }

    static private inline function getRandomCorridor(map, parent:Rectangle) {
        var r = Std.random(2);

        if(r==0) {
        } else {
        }
    }


    static private function collides(rect:Rectangle, rects:Array<Rectangle>):Bool {
        for(other_rect in rects) {
            if(untyped Phaser.Geom.Intersects.RectangleToRectangle(rect, other_rect)) {
                return true;
            }
        }

        return false;
    }
}
