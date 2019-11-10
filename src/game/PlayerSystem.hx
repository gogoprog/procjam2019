package game;

import ash.tools.ListIteratingSystem;
import ash.core.*;
import whiplash.babylon.components.*;
import whiplash.math.*;

class PlayerNode extends Node<PlayerNode> {
    public var transform:Transform3d;
    public var player:Player;
    public var mesh:Mesh;
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
        lockPointer();
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    private function updateNode(node:PlayerNode, dt:Float):Void {
        var t = node.transform;
        var player = node.player;

        {
            var d = player.direction;
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
                var localMat = untyped node.mesh.o._localWorld;
                var worldDir:Vector3 = Vector3.TransformNormal(d, localMat);
                worldDir.y = 0;
                worldDir.normalize();
                t.position += worldDir * 5 * dt;
            }
        }
        {
            var move = whiplash.Input.mouseMove;
            player.pitch += move.y * 0.01;
            player.yaw += move.x * 0.01;

            t.setRotationFromYawPitchRoll(player.yaw, player.pitch, 0);

        }
        {
            cameraTransform.position.set(t.position.x, t.position.y + 0.5, t.position.z);
            cameraTransform.rotation.copyFrom(t.rotation);
        }

        if(whiplash.Input.mouseButtons[0]) {
            lockPointer();
        }
    }

    private function onNodeAdded(node:PlayerNode) {
    }

    private function onNodeRemoved(node:PlayerNode) {
    }

    private function lockPointer() {
        new js.jquery.JQuery("canvas")[0].requestPointerLock();
    }
}


