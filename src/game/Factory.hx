package game;

import ash.core.Entity;
import whiplash.phaser.*;
import whiplash.babylon.components.*;
import whiplash.math.*;

class Factory {
    static public var floorMaterial:BABYLON.StandardMaterial;
    static public var metalMaterial:BABYLON.StandardMaterial;

    static public function preload(scene:phaser.Scene) {
    }

    static public function init() {
        var scene = Game.instance.scene;
        floorMaterial = new BABYLON.StandardMaterial("floor", scene);
        floorMaterial.diffuseTexture = new BABYLON.Texture("../data/textures/floor.png", scene);
        floorMaterial.bumpTexture = new BABYLON.Texture("../data/textures/floor_n.png", scene);
        floorMaterial.specularColor = new BABYLON.Color3(0, 0, 0);
        floorMaterial.emissiveColor = new BABYLON.Color3(0.2, 0.2, 0.2);
        floorMaterial.maxSimultaneousLights = 10;
        metalMaterial = new BABYLON.StandardMaterial("metal", scene);
        metalMaterial.diffuseTexture = new BABYLON.Texture("../data/textures/wall.png", scene);
        metalMaterial.bumpTexture = new BABYLON.Texture("../data/textures/wall_n.png", scene);
        metalMaterial.specularColor = new BABYLON.Color3(0, 0, 0);
        metalMaterial.emissiveColor = new BABYLON.Color3(0.2, 0.2, 0.2);
        metalMaterial.maxSimultaneousLights = 10;
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
        var m = BABYLON.MeshBuilder.CreateTiledGround("floor", {xmin:0, zmin:0, xmax:w, zmax:h, subdivisions: {w:w, h:h}}, Game.instance.scene);
        e.add(new Mesh(m, Game.instance.scene));
        m.material = floorMaterial;
        return e;
    }

    static public function createWall(s, h) {
        var e = new Entity();
        e.add(new Transform3d());
        var uvs = new BABYLON.Vector4(0, 0, s, h);
        var options = {
            sideOrientation: BABYLON.Mesh.DOUBLESIDE,
            width: s,
            height: h,
            frontUVs: uvs,
            backUVs: uvs
        };
        var m = BABYLON.MeshBuilder.CreatePlane("wall", options, Game.instance.scene);
        e.add(new Mesh(m, Game.instance.scene));
        m.material = metalMaterial;
        return e;
    }

    static public function createLight() {
        var scene = Game.instance.scene;
        var e = new Entity();
        e.add(new Transform3d());
        e.add(new Light(new BABYLON.PointLight("light", BABYLON.Vector3.Zero(), scene), scene));
        e.get(Light).o.diffuse = new BABYLON.Color3(1, 0, 0);
        return e;
    }

    static public function createPlayer() {
        var scene = Game.instance.scene;
        var e = new Entity();
        e.name = "player";
        e.add(new Transform3d());
        var m = BABYLON.MeshBuilder.CreateSphere("-", {diameter:1, segments:16}, scene);
        e.add(new Mesh(m, Game.instance.scene));
        e.add(new Player());
        return e;
    }
}
