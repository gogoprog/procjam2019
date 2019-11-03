package game.map;

class Wall extends phaser.geom.Line {
    public function new(?a, ?b, ?c, ?d) {
        super(a, b, c, d);
    }

    public function getLength() {
        var dx = x2 - x1;
        var dy = y2 - y1;
        return Math.sqrt(dx * dx + dy * dy);
    }
}
