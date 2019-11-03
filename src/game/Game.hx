package game;

import js.Lib;
import js.jquery.*;
import js.Browser.document;
import js.Browser.window;
import phaser.Game;
import phaser.Phaser;
import ash.core.Entity;
import ash.core.Engine;
import ash.core.Node;
import whiplash.*;
import whiplash.math.*;
import whiplash.phaser.*;
import whiplash.common.components.Active;

class Game extends Application {
    private var mapGen:game.map.Generator = new game.map.Generator();
    private var currentMap:game.map.Map;

    public function new() {
        super(1024, 600, ".root");
    }

    override function preload():Void {
        super.preload();
        Factory.preload(whiplash.Lib.phaserScene);
    }

    override function create():Void {
        var game = whiplash.Lib.phaserGame;
        game.sound.pauseOnBlur = false;
        AudioManager.init(whiplash.Lib.phaserScene);


        generateMap();
    }

    override function onGuiLoaded():Void {
        super.onGuiLoaded();

        new JQuery(".gen").click(function(e) {
            generateMap();
        });
    }

    public function generateMap() {
        var map  = mapGen.generate();
        drawMap(map);
        currentMap = map;
    }

    public function drawMap(map:game.map.Map) {
        engine.removeAllEntities();
        {
            var e = Factory.createGraphics();
            engine.addEntity(e);
            var g = e.get(Graphics);
            var s = Config.tileSize;
            var walls:Array<game.map.Wall> = map.walls;

            for(zone in map.allZones) {
                switch(zone.type) {
                    case First:
                        g.fillStyle(0xaaffaa, 1);

                    case Room:
                        g.fillStyle(0xffffaa, 1);

                    case Door:
                        g.fillStyle(0xffaaaa, 1);
                }

                g.fillRect(zone.rect.x * s, zone.rect.y * s, zone.rect.width *s, zone.rect.height * s);
            }

            for(wall in walls) {
                g.lineBetween(wall.x1 * s, wall.y1 * s, wall.x2 * s, wall.y2 * s);
            }
        }
    }

    static function main():Void {
        new Game();
    }
}
