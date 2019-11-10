package game;

import ash.tools.ListIteratingSystem;
import ash.core.*;
import whiplash.babylon.components.*;

class PlayerNode extends Node<PlayerNode> {
    public var transform:Transform3d;
    public var player:Player;
}

class PlayerSystem extends ListIteratingSystem<PlayerNode> {
    private var engine:Engine;
    private var camera:Entity;
    private var cameraTransform:Transform3d;

    public function new() {
        super(PlayerNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine:Engine) {
        super.addToEngine(engine);
        this.engine = engine;
        camera = engine.getEntityByName("camera");
        cameraTransform = camera.get(Transform3d);
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    private function updateNode(node:PlayerNode, dt:Float):Void {
        var t = node.transform;

        {
            var d = node.player.direction;
            var keys = whiplash.Input.keys;

            d.set(0, 0, 0);

            if(keys["a"]) {
                d.x -= 1;
            }

            if(keys["d"]) {
                d.x += 1;
            }

            if(keys["w"]) {
                d.z = 1;
            }

            if(keys["s"]) {
                d.z -= 1;
            }

            d.normalize();

            if(d.getLength() > 0) {
                t.position += d * 5 * dt;
            }
        }
        {
            cameraTransform.position.set(t.position.x, t.position.y + 0.5, t.position.z);
            cameraTransform.rotation.copyFrom(t.rotation);
        }
    }

    private function onNodeAdded(node:PlayerNode) {
    }

    private function onNodeRemoved(node:PlayerNode) {
    }
}


