package game;

import whiplash.math.Vector2;

class Config {
    public static var tileSize:Float = 8;
    public static var halfTileSize:Float = tileSize / 2;
    public static var gridOffset = new Vector2(tileSize/2, tileSize/2);
    public static var playerRadius:Float = 0.15;
}
