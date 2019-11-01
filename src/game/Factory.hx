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
        e.get(Transform).scale.setTo(0.5, 0.5);
        return e;
    }
}
