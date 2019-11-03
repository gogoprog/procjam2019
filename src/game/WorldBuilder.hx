package game;

import whiplash.math.*;
import whiplash.babylon.components.*;

class WorldBuilder {
    private var engine:ash.core.Engine;
    private var entities:Array<ash.core.Entity> = [];

    public function new(engine) {
        this.engine = engine;
    }

    public function build(map:game.map.Map) {
        for(e in entities) {
            engine.removeEntity(e);
        }

        var offset = new Vector2(map.width, map.height) * -0.5;

        for(zone in map.allZones) {
            var e = Factory.createFloor(zone.rect.width, zone.rect.height);
            e.get(Transform3d).position.set(offset.x + zone.rect.x, 0, offset.y + zone.rect.y);
            engine.addEntity(e);
            entities.push(e);
        }
    }
}
