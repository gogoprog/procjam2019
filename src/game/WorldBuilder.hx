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
            {
                var e = Factory.createFloor(zone.rect.width, zone.rect.height);
                e.get(Transform3d).position.set(offset.x + zone.rect.x, 0, offset.y + zone.rect.y);
                spawnEntity(e);
            }
            {
                // var e = Factory.createLight();
                // e.get(Transform3d).position.set(offset.x + zone.rect.centerX, 0.5, offset.y + zone.rect.centerY);
                // engine.addEntity(e);
                // entities.push(e);
            }
        }

        for(wall in map.walls) {
            var len = wall.getLength();
            var h = 1;
            var e = Factory.createWall(len, h);

            if(wall.x1 == wall.x2) {
                e.get(Transform3d).setRotationFromYawPitchRoll(Math.PI / 2, 0, 0);
                e.get(Transform3d).position.set(offset.x + wall.x1, h/2, offset.y + wall.y1 + len * 0.5);
            } else {
                e.get(Transform3d).position.set(offset.x + wall.x1 + len * 0.5, h/2, offset.y + wall.y1);
            }

            spawnEntity(e);
        }

        {
            var startZone = map.allZones[0];
            var e = Factory.createPlayer();
            e.get(Transform3d).position.set(offset.x + startZone.rect.centerX, 0, offset.y + startZone.rect.centerY);
            spawnEntity(e);
        }
    }

    public function spawnEntity(e:ash.core.Entity) {
        engine.addEntity(e);
        entities.push(e);
    }
}
