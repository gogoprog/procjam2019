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
import game.MapGenerator;

class Game extends Application {

    private var mapGen:MapGenerator = new MapGenerator();

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


        var map  = mapGen.generate();
        drawMap(map);

    }

    public function drawMap(map) {
        engine.removeAllEntities();

        for(y in 0...map.height) {
            for(x in 0...map.width) {
                var t = map.getTile(x, y);
                var e:Entity = null;

                if(t != null) {
                    switch(t) {
                        case Empty: {
                        }

                        case Door: {
                            e = Factory.createTile();
                            engine.addEntity(e);
                            e.get(Sprite).tint = 0xff0000;
                        }

                        case Room: {
                            e = Factory.createTile();
                            engine.addEntity(e);
                        }
                    }
                }

                if(e!=null) {
                    e.get(Transform).position.setTo(16*x, 16*y);
                }
            }
        }
    }

    static function main():Void {
        new Game();
    }
}
