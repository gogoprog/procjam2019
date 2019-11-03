package game;

import phaser.geom.Rectangle;
import whiplash.math.Vector2;

enum ZoneType {
    First;
    Room;
    Door;
}

class Wall extends phaser.geom.Line {
    public function new(?a, ?b, ?c, ?d) {
        super(a, b, c, d);
    }
}

class Zone {
    public var parent:Zone = null;
    public var children:Array<Zone> = [];
    public var type:ZoneType;
    public var rect:Rectangle;

    public function new() {
    }
}

class Map {
    public var grid:Array<Array<ZoneType>>;
    public var width:Int;
    public var height:Int;
    public var rect:Rectangle;
    public var rects:Array<Rectangle>;
    public var walls:Array<Wall>;
    public var rootZone:Zone = null;
    public var lastZone:Zone = null;
    public var allZones:Array<Zone>;

    public function new(w, h) {
        this.width = w;
        this.height = h;
        this.rect = new Rectangle(0, 0, w, h);
        grid = new Array<Array<ZoneType>>();

        for(y in 0...height) {
            grid[y] = new Array<ZoneType>();
        }

        rects = [];
        allZones = [];
    }

    public inline function setTile(x:Int, y:Int, t:ZoneType) {
        grid[y][x] = t;
    }

    public inline function getTile(x:Int, y:Int):ZoneType {
        if(grid[y] != null) {
            var v = grid[y][x];
            return v;
        }

        return null;
    }

    public function addZone(parent:Zone, rect:Rectangle, t:ZoneType) {
        var sx = Std.int(rect.x);
        var sy = Std.int(rect.y);

        for(y in 0...Std.int(rect.height)) {
            for(x in 0...Std.int(rect.width)) {
                setTile(sx+x, sy+y, t);
            }
        }

        rects.push(rect);
        {
            lastZone = new Zone();
            lastZone.rect = rect;
            lastZone.parent = parent;
            lastZone.type = t;

            if(parent == null) {
                rootZone = lastZone;
            } else {
                parent.children.push(lastZone);
            }

            allZones.push(lastZone);
        }
    }

    public function getLastZone():Zone {
        return lastZone;
    }

    public function getRandomZone():Zone {
        return allZones[Std.random(allZones.length)];
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
            var rect = getRandomRectangle(map, 20, 20);
            tryAdd(map, rect, null, First);
        }

        while(addRoom(map)) {
        }

        for(i in 0...8) {
            var started = addRoom(map, map.getRandomZone());

            if(started) {
                while(addRoom(map)) {
                }
            }
        }

        computeWalls(map);

        return map;
    }

    public function addRoom(map:Map, parentZone:Zone = null) {
        var r = Std.random(2);
        var rect:Rectangle = null;
        var added = false;
        var count = 0;

        if(parentZone == null) {
            parentZone = map.getLastZone();
        }

        if(r == 0) {
            while(!added && count < 1024) {
                rect = getRandomRoom(map, parentZone.rect);
                added = tryAdd(map, rect, parentZone, Room);
                ++count;
            }
        } else {
            while(!added && count < 1024) {
                rect = getRandomCorridor(map, parentZone.rect);
                added = tryAdd(map, rect, parentZone, Room);
                ++count;
            }
        }

        return added;
    }

    public function computeWalls(map:Map) {
        map.walls = [];

        for(rect in map.rects) {
            var wall:Wall = null;
            var x:Int;
            var y:Int;
            function validateWall() {
                if(wall != null) {
                    if(wall.x1 != wall.x2 || wall.y1 != wall.y2) {
                        map.walls.push(wall);
                    }

                    wall = null;
                }
            }
            function process(checkx, checky, dx, dy) {
                if(wall == null) {
                    wall = new Wall(x, y, x, y);
                }

                if(map.getTile(x + checkx, y + checky) == null) {
                    wall.x2 += dx;
                    wall.y2 += dy;
                } else {
                    validateWall();
                }
            }
            {
                x = cast rect.x;
                y = cast rect.y;

                for(i in 0...cast rect.width) {
                    x = cast rect.x + i;
                    process(0, -1, 1, 0);
                }

                validateWall();
            }
            {
                x = cast rect.x;
                y = cast rect.bottom;

                for(i in 0...cast rect.width) {
                    x = cast rect.x + i;
                    process(0, 0, 1, 0);
                }

                validateWall();
            }
            {
                x = cast rect.x;
                y = cast rect.y;

                for(i in 0...cast rect.height) {
                    y = cast rect.y + i;
                    process(-1, 0, 0, 1);
                }

                validateWall();
            }
            {
                x = cast rect.right;
                y = cast rect.y;

                for(i in 0...cast rect.height) {
                    y = cast rect.y + i;
                    process(0, 0, 0, 1);
                }

                validateWall();
            }
        }
    }

    static private function tryAdd(map:Map, rect:Rectangle, parent:Zone, tile:ZoneType) {
        if(untyped Phaser.Geom.Rectangle.ContainsRect(map.rect, rect)) {
            if(!isValid(rect, parent, map.rects)) {
                map.addZone(parent, rect, tile);
                return true;
            }
        }

        return false;
    }

    static private function getRandomInt(min, max):Int {
        return min + Std.random(max - min + 1);
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
            w = getRandomInt(1, Std.int(Math.min(4, parent.width)));
            x = getRandomInt(cast parent.left, cast parent.right - w);
            h = getRandomInt(6, 36);

            if(r2==0) {
                y = cast parent.top - h;
            } else {
                y = cast parent.bottom;
            }
        } else {
            h = getRandomInt(1, Std.int(Math.min(4, parent.height)));
            y = getRandomInt(cast parent.top, cast parent.bottom - h);
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

    static private function isValid(rect:Rectangle, parent:Zone, rects:Array<Rectangle>):Bool {
        for(other_rect in rects) {
            if(parent == null || other_rect != parent.rect) {
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
