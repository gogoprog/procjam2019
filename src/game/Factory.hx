package game;

import ash.core.Entity;
import whiplash.phaser.*;
import whiplash.math.*;

class Factory {
    static public function preload(scene:phaser.Scene) {
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
}
