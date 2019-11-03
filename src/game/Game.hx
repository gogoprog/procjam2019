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
import whiplash.babylon.components.*;

class Game extends Application {
    static public var instance:Game;

    private var mapGen:game.map.Generator = new game.map.Generator();
    private var worldBuilder:game.WorldBuilder;
    private var currentMap:game.map.Map;

    public var scene:BABYLON.Scene;

    public function new() {
        super(1024, 600, ".root");
        instance = this;
    }

    override function preload():Void {
        super.preload();
        Factory.preload(whiplash.Lib.phaserScene);
    }

    override function create():Void {
        var game = whiplash.Lib.phaserGame;
        game.sound.pauseOnBlur = false;
        AudioManager.init(whiplash.Lib.phaserScene);

        worldBuilder = new game.WorldBuilder(whiplash.Lib.ashEngine);
        scene = new BABYLON.Scene(whiplash.Lib.babylonEngine);
        Factory.init();
        var entity = new Entity();
        entity.add(new Transform3d());
        entity.add(new Camera(new BABYLON.FreeCamera("Camera", BABYLON.Vector3.Zero(), scene), scene));
        entity.add(new Active());
        entity.get(Transform3d).position = new Vector3(0, 100, -100);
        entity.get(Transform3d).lookAt(new Vector3(0, 0, 0));
        engine.addEntity(entity);
        var entity = new Entity();
        entity.add(new Light(new BABYLON.PointLight("Omni0", BABYLON.Vector3.Zero(), scene), scene));
        entity.add(new Transform3d());
        entity.get(Transform3d).position = new BABYLON.Vector3(0, 100, -100);
        engine.addEntity(entity);

        generateMap();
    }

    override function update(time, delta) {
        super.update(time, delta);

        if(scene != null) {
            scene.render();
        }
    }

    override function onGuiLoaded():Void {
        super.onGuiLoaded();

        new JQuery(".gen").click(function(e) {
            generateMap();
        });
    }

    public function generateMap() {
        var map  = mapGen.generate();
        drawMiniMap(map);
        currentMap = map;
        worldBuilder.build(map);
    }

    public function drawMiniMap(map:game.map.Map) {
        {
            var e = engine.getEntityByName("minimap");

            if(e != null) {
                engine.removeEntity(e);
            }
        }
        var e = Factory.createGraphics();
        e.name = "minimap";
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

        e.get(Transform).scale.setTo(0.25, 0.25);
    }

    static function main():Void {
        new Game();
    }
}
