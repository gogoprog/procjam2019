package game.map;

import phaser.geom.Rectangle;

class Zone {
    public var parent:Zone = null;
    public var children:Array<Zone> = [];
    public var type:ZoneType;
    public var rect:Rectangle;

    public function new() {
    }
}

