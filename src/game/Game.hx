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

    public var scene:BABYLON.Scene;
    public var currentMap:game.map.Map;

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
        scene.clearColor = new BABYLON.Color4(0.5, 0.5, 0.6, 1);
        Factory.init();

        setupScene();
        setupStates();

        gotoMainMenu();
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

        new JQuery(".play").click(function(e) {
            new js.jquery.JQuery("canvas")[0].requestPointerLock();
            gotoInGame();
        });
    }

    private function setupScene() {
        var entity = new Entity();
        entity.name = "camera";
        entity.add(new Transform3d());
        entity.add(new Camera(new BABYLON.FreeCamera("Camera", BABYLON.Vector3.Zero(), scene), scene));
        entity.add(new Active());
        entity.get(Transform3d).position = new Vector3(0, 50, -90);
        entity.get(Transform3d).lookAt(new Vector3(0, 0, 0));
        entity.get(Camera).o.minZ = 0.1;
        engine.addEntity(entity);
        var entity = new Entity();
        entity.name = "directionalLight";
        var dl = new BABYLON.DirectionalLight("Dir0", new Vector3(-0.1, -2, -1), scene);
        dl.intensity = 0.2;
        entity.add(new Light(dl, scene));
        entity.add(new Transform3d());
        engine.addEntity(entity);
    }

    private function setupStates() {
        createUiState("menu", ".menu");
        createUiState("hud", ".hud");
        var menuState = createState("menu");
        menuState.addInstance(new ArcCamControlSystem());
        var ingameState = createState("ingame");
        ingameState.addInstance(new PlayerSystem());
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

            var y = (map.height - zone.rect.y - zone.rect.height) * s;
            g.fillRect(zone.rect.x * s, y, zone.rect.width * s, zone.rect.height * s);
        }

        for(wall in walls) {
            g.lineBetween(wall.x1 * s, (map.height - wall.y1) * s, wall.x2 * s, (map.height - wall.y2) * s);
        }

        e.get(Transform).scale.setTo(0.25, 0.25);
    }

    public function gotoMainMenu() {
        engine.updateComplete.addOnce(function() {
            changeState("menu");
            changeUiState("menu");
        });
    }

    public function gotoInGame() {
        engine.updateComplete.addOnce(function() {
            changeState("ingame");
            changeUiState("hud");
        });
    }

    static function main():Void {
        new Game();
    }
}
