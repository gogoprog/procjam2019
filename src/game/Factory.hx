package game;

import ash.core.Entity;
import whiplash.phaser.*;
import whiplash.babylon.components.*;
import whiplash.math.*;

class Factory {
    static public var floorMaterial:BABYLON.StandardMaterial;

    static public function preload(scene:phaser.Scene) {
    }

    static public function init() {
        var scene = Game.instance.scene;
        floorMaterial = new BABYLON.StandardMaterial("floor", scene);
        floorMaterial.diffuseTexture = new BABYLON.Texture("../data/textures/floor.png", scene);
        floorMaterial.specularColor = new BABYLON.Color3(0, 0, 0);
        floorMaterial.emissiveColor = new BABYLON.Color3(0.2, 0.2, 0.2);
    }

    static public function createTile() {
        var e = new Entity();
        e.add(new Sprite("square"));
        e.add(new Transform());
        var s = Config.tileSize / e.get(Sprite).displayWidth;
        e.get(Transform).scale.setTo(s, s);
        e.get(Sprite).setOrigin(0.5, 0.5);
        return e;
    }

    static public function createGraphics() {
        var e = new Entity();
        e.add(new Transform());
        e.add(new Graphics());
        var g = e.get(Graphics);
        g.lineStyle(2, 0x000000, 1.0);
        return e;
    }

    static public function createFloor(w, h) {
        var e = new Entity();
        e.add(new Transform3d());
        var m = BABYLON.MeshBuilder.CreateGround("plane", {width:w, height:h }, Game.instance.scene);
        e.add(new Mesh(m, Game.instance.scene));
        m.material = floorMaterial;
        return e;
    }
}
