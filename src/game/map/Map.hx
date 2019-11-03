package game.map;

import phaser.geom.Rectangle;

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
