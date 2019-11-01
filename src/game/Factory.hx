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
        return e;
    }
}
