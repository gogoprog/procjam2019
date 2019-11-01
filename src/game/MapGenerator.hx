package game;

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

    public function setTile(x:Int, y:Int, t:Tile) {
        grid[y][x] = t;
    }
    public function getTile(x:Int, y:Int):Tile {
        return grid[y][x];
    }
}

class MapGenerator {

    public function new() {
    }

    public function generate():Map {
        var map = new Map(128, 64);
        map.setTile(30, 30, Door);
        map.setTile(30, 29, Door);
        map.setTile(1, 1, Room);

        return map;
    }
}
