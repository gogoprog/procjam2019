package game;

import phaser.geom.Rectangle;

enum Tile {
    Empty;
    First;
    Room;
    Door;
    Corridor;
}

class Map {
    public var grid:Array<Array<Tile>>;
    public var width:Int;
    public var height:Int;
    public var rect:Rectangle;
    public var rects:Array<Rectangle>;

    public function new(w, h) {
        this.width = w;
        this.height = h;
        this.rect = new Rectangle(0, 0, w, h);
        grid = new Array<Array<Tile>>();

        for(y in 0...height) {
            grid[y] = new Array<Tile>();
        }

        rects = [];
    }

    public inline function setTile(x:Int, y:Int, t:Tile) {
        grid[y][x] = t;
    }
    public inline function getTile(x:Int, y:Int):Tile {
        return grid[y][x];
    }

    public function addRect(rect:Rectangle, t:Tile) {
        var sx = Std.int(rect.x);
        var sy = Std.int(rect.y);

        for(y in 0...Std.int(rect.height)) {
            for(x in 0...Std.int(rect.width)) {
                setTile(sx+x, sy+y, t);
            }
        }

        rects.push(rect);
    }

    public function getLastRect():Rectangle {
        return rects[rects.length-1];
    }

}

class MapGenerator {

    public function new() {
    }

    public function generate():Map {
        var w = 128;
        var h = 64;
        var map = new Map(w, h);

        while(map.rects.length < 1) {
            var rect = getRandomRectangle(map, 32, 32);
            tryAdd(map, rect, First);
        }

        while(step(map)) {
        }

        for(i in 0...8) {
            var startRectangle = map.rects[Std.random(map.rects.length)];
            var started = step(map, startRectangle);

            if(started) {
                while(step(map)) {
                }
            }
        }

        return map;
    }

    public function step(map, lastRectangle:Rectangle = null) {
        var r = Std.random(2);
        var rect:Rectangle = null;
        var added = false;
        var count = 0;

        if(lastRectangle == null) {
            lastRectangle = map.getLastRect();
        }

        if(r == 0) {
            while(!added && count < 1024) {
                rect = getRandomRoom(map, lastRectangle);
                added = tryAdd(map, rect, Room);
                ++count;
            }
        } else {
            while(!added && count < 1024) {
                rect = getRandomCorridor(map, lastRectangle);
                added = tryAdd(map, rect, Corridor);
                ++count;
            }
        }

        return added;
    }

    static private function tryAdd(map, rect, tile:Tile) {
        if(untyped Phaser.Geom.Rectangle.ContainsRect(map.rect, rect)) {
            if(!isValid(rect, map.getLastRect(), map.rects)) {
                map.addRect(rect, tile);
                return true;
            }
        }

        return false;
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
            w = getRandomInt(1, 4);
            h = getRandomInt(6, 36);

            if(r2==0) {
                y = cast parent.top - h;
            } else {
                y = cast parent.bottom;
            }
        } else {
            y = getRandomInt(cast parent.top, cast parent.bottom);
            h = getRandomInt(1, 4);
            w = getRandomInt(6, 36);

            if(r2==0) {
                x = cast parent.left - w;
            } else {
                x = cast parent.right;
            }
        }

        var rect = new Rectangle(x, y, w, h);
        return rect;
    }


    static private inline function getRandomRoom(map, parent:Rectangle) {
        var r = Std.random(2);
        var x:Int;
        var y:Int;
        var w:Int;
        var h:Int;
        w = getRandomInt(6, 32);
        h = getRandomInt(6, 32);

        if(parent.width < parent.height) {
            x = Std.int(parent.x) - getRandomInt(0, w - Std.int(parent.width));

            if(r==0) {
                y = cast parent.y - h;
            } else {
                y = cast parent.bottom;
            }
        } else {
            y = Std.int(parent.y) - getRandomInt(0, h - Std.int(parent.height));

            if(r==0) {
                x = cast parent.x - w;
            } else {
                x = cast parent.right;
            }
        }

        var rect = new Rectangle(x, y, w, h);
        return rect;
    }

    static private function collides(rect:Rectangle, rects:Array<Rectangle>):Bool {
        for(other_rect in rects) {
            if(intersects(rect, other_rect)) {
                return true;
            }
        }

        return false;
    }

    static private function isValid(rect:Rectangle, parent:Rectangle, rects:Array<Rectangle>):Bool {
        for(other_rect in rects) {
            if(other_rect != parent) {
                if(intersectsOrTouches(rect, other_rect)) {
                    return true;
                }
            }
        }

        return false;

    }

    static private function intersects(rectA:Rectangle, rectB:Rectangle) {
        return !(rectA.right <= rectB.x || rectA.bottom <= rectB.y || rectA.x >= rectB.right || rectA.y >= rectB.bottom);
    }


    static private function intersectsOrTouches(rectA:Rectangle, rectB:Rectangle) {
        return !(rectA.right < rectB.x || rectA.bottom < rectB.y || rectA.x > rectB.right || rectA.y > rectB.bottom);
    }
}
