package game;

import whiplash.babylon.components.*;

class WorldBuilder {
    private var engine:ash.core.Engine;

    public function new(engine) {
        this.engine = engine;
    }

    public function build(map:game.map.Map) {
        var s = Config.tileSize;

        for(zone in map.allZones) {
            var e = Factory.createFloor(zone.rect.width, zone.rect.height);
            e.get(Transform3d).position.set(zone.rect.x * s, 0, zone.rect.y * s);
            engine.addEntity(e);
        }
    }
}
