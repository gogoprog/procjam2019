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

        new js.jquery.JQuery(".root").on("click", lockPointer);
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
        new js.jquery.JQuery(".root").off("click", lockPointer);
    }

    private function updateNode(node:PlayerNode, dt:Float):Void {
        var t = node.transform;
        var player = node.player;
        var keys = whiplash.Input.keys;

        {
            var d = player.direction;

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
                // var requestedPosition = t.position + worldDir * 5 * dt;
                var speed:Float = 5;

                if(keys["Shift"]) {
                    speed = 0.5;
                }

                tryMove(node, worldDir * speed * dt);
            }
        }
        {
            var move = whiplash.Input.mouseMove;
            player.pitch += move.y * 0.001;
            player.yaw += move.x * 0.001;

            t.setRotationFromYawPitchRoll(player.yaw, player.pitch, 0);
        }
        {
            cameraTransform.position.set(t.position.x, t.position.y + 0.5, t.position.z);
            cameraTransform.rotation.copyFrom(t.rotation);
        }

        if(keys["Escape"]) {
            Game.instance.gotoMainMenu();
        }
    }

    private function onNodeAdded(node:PlayerNode) {
    }

    private function onNodeRemoved(node:PlayerNode) {
    }

    private function lockPointer(?e) {
        new js.jquery.JQuery("canvas")[0].requestPointerLock();
    }

    private function tryMove(node:PlayerNode, displacement:Vector3) {
        var map = Game.instance.currentMap;
        var walls = map.walls;
        var offset = new Vector2(map.width, map.height) * -0.5;
        var currentPos = node.transform.position;
        var playerCurrentMapPos = new Vector2(currentPos.x - offset.x, currentPos.z - offset.y);
        var playerMapPos:Vector2 = null;
        var mapDisplacement = new Vector2(displacement.x, displacement.z);
        var playerEndMapPos = playerCurrentMapPos + mapDisplacement;
        var collides = false;
        var collidingWall:game.map.Wall = null;
        var nearest = new Vector2();
        var count = 1;

        for(i in 0...count) {
            var f = (i+1)/count;
            playerMapPos = playerCurrentMapPos + mapDisplacement * f;
            var playerCircle = new phaser.geom.Circle(playerMapPos.x, playerMapPos.y, Config.playerRadius);

            for(wall in walls) {
                var r = untyped Phaser.Geom.Intersects.LineToCircle(wall, playerCircle, nearest);

                if(r) {
                    collidingWall = wall;
                    collides = true;
                    break;
                }
            }

            if(collides) {
                break;
            }
        }

        if(!collides) {
            node.transform.position += displacement;
        } else {
            var normal:Vector2 = playerMapPos - nearest;
            normal.normalize();
            playerMapPos = playerEndMapPos;
            var i = 0;

            while(collides) {
                collides = false;
                playerMapPos += normal * 0.01;
                var playerCircle = new phaser.geom.Circle(playerMapPos.x, playerMapPos.y, Config.playerRadius);

                for(wall in walls) {
                    var r = untyped Phaser.Geom.Intersects.LineToCircle(wall, playerCircle);

                    if(r) {
                        collides = true;
                        break;
                    }
                }

                ++i;

                if(i > 100) {
                    return;
                }
            }

            node.transform.position.set(playerMapPos.x + offset.x, 0, playerMapPos.y + offset.y);
        }
    }
}


