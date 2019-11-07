package game;

import ash.tools.ListIteratingSystem;
import ash.core.*;
import whiplash.phaser.*;
import whiplash.math.*;
import whiplash.babylon.components.*;

class ArcCamControlNode extends Node<ArcCamControlNode> {
    public var transform:Transform3d;
    public var control:ArcCamControl;
}

class ArcCamControlSystem extends ListIteratingSystem<ArcCamControlNode> {
    private var engine:Engine;
    private var angle = 0.0;

    public function new() {
        super(ArcCamControlNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine:Engine) {
        super.addToEngine(engine);
        this.engine = engine;
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    private function updateNode(node:ArcCamControlNode, dt:Float):Void {
        var distance = node.control.distance;

        var s = Math.sin(angle);
        var c = Math.cos(angle);

        var direction = new Vector2(s, -c);

        node.transform.position.set(direction.x * distance, node.control.height, direction.y * distance);

        node.transform.lookAt(Vector3.zero);

        angle += dt / 5;
    }

    private function onNodeAdded(node:ArcCamControlNode) {
    }

    private function onNodeRemoved(node:ArcCamControlNode) {
    }
}


