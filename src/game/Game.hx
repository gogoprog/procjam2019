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
        var offset = Config.gridOffset;

        for(y in 0...map.height) {
            for(x in 0...map.width) {
                var t = map.getTile(x, y);
                var e:Entity = null;

                if(t != null) {
                    switch(t) {
                        case First: {
                            e = Factory.createTile();
                            engine.addEntity(e);
                            e.get(Sprite).tint = 0xaaffaa;
                        }

                        case Door: {
                            e = Factory.createTile();
                            engine.addEntity(e);
                            e.get(Sprite).tint = 0xffaaaa;
                        }

                        case Room: {
                            e = Factory.createTile();
                            engine.addEntity(e);
                            e.get(Sprite).tint = 0xffffaa;
                        }
                    }
                }

                if(e!=null) {
                    e.get(Transform).position.setTo(offset.x + Config.tileSize*x, offset.y + Config.tileSize*y);
                }
            }
        }

        {
            var e = Factory.createGraphics();
            engine.addEntity(e);
            var g = e.get(Graphics);
            var walls:Array<game.map.Wall> = map.walls;

            for(wall in walls) {
                g.lineBetween(wall.x1 * Config.tileSize, wall.y1 * Config.tileSize, wall.x2 * Config.tileSize, wall.y2 * Config.tileSize);
            }
        }
    }

    static function main():Void {
        new Game();
    }
}
