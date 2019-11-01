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
        var mapRect = new Rectangle(0, 0, w, h);
        var lastType:Tile = Corridor;
        var lastRectangle:Rectangle = null;

        while(rects.length < 8) {
            var r = Std.random(2);
            var rect:Rectangle = null;
            var type:Tile = null;
            lastRectangle = rects[rects.length - 1];

            if(lastType == Corridor) {
                rect = getRandomRectangle(map, 48, 48);
                type = Room;
            } else {
                if(lastRectangle != null) {
                    rect = getRandomCorridor(map, lastRectangle);
                    type = Corridor;
                }
            }

            if(rect != null) {
                if(untyped Phaser.Geom.Rectangle.ContainsRect(mapRect, rect)) {
                    if(!collides(rect, rects)) {
                        map.fillTiles(rect, Room);
                        rects.push(rect);
                        lastType = type;
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
        var w = getRandomInt(8, maxWidth);
        var h = getRandomInt(8, maxHeight);
        var rect = new Rectangle(x, y, w, h);
        return rect;
    }

    static private inline function getRandomCorridor(map, parent:Rectangle) {
        var r = Std.random(2);
        var r2 = Std.random(2);
        var x:Int;
        var y:Int;
        var w:Int;
        var h:Int;

        if(r==0) {
            x = getRandomInt(cast parent.left, cast parent.right);
            w = getRandomInt(2, 4);
            h = getRandomInt(8, 36);

            if(r2==0) {
                y = cast parent.top - h - 1;
            } else {
                y = cast parent.bottom + 1;
            }
        } else {
            y = getRandomInt(cast parent.top, cast parent.bottom);
            h = getRandomInt(2, 4);
            w = getRandomInt(8, 36);

            if(r2==0) {
                x = cast parent.left - w - 1;
            } else {
                x = cast parent.right + 1;
            }
        }

        var rect = new Rectangle(x, y, w, h);
        return rect;
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
