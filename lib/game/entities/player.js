// Generated by CoffeeScript 1.6.2
(function() {
  var _this = this;

  ig.module('game.entities.player').requires('game.entities.robot', 'game.entities.enemy').defines(function() {
    return _this.EntityPlayer = EntityRobot.extend({
      type: ig.Entity.TYPE.A,
      checkAgainst: ig.Entity.TYPE.B,
      enemyType: ig.Entity.TYPE.B,
      collides: ig.Entity.COLLIDES.ACTIVE,
      target: 'EntityEnemy',
      shoots: true,
      ShootTimer: new ig.Timer(),
      health: 3,
      MaxHealth: 3,
      init: function(x, y, settings) {
        this.parent(x, y, settings);
        this.ShootTimer.set(1);
        if (!ig.global.wm) {
          return this.health = ig.game.getPlayerHealth();
        }
      },
      update: function() {
        var deltaX, deltaY, mx, my, r;

        mx = ig.input.mouse.x + ig.game.screen.x;
        my = ig.input.mouse.y + ig.game.screen.y;
        r = Math.atan2(my - this.pos.y, mx - this.pos.x);
        deltaY = Math.sin(r) * (100 * this.speed);
        deltaX = Math.cos(r) * (100 * this.speed);
        if (mx < this.pos.x + 3 && mx > this.pos.x && my < this.pos.y + 3 && my > this.pos.y - 3) {
          this.currentAnim = this.anims.idle;
          this.vel.x = 0;
          this.vel.y = 0;
        } else {
          if (this.immortal) {
            this.currentAnim = this.anims.walkblink;
          } else {
            this.currentAnim = this.anims.walk;
          }
          this.maxVel.x = this.vel.x = this.accel.x = deltaX;
          this.vel.y = deltaY;
        }
        return this.parent();
      },
      check: function(other) {
        this.receiveDamage(1, other);
        return this.parent();
      },
      receiveDamage: function(amount, from) {
        this.parent(amount, from);
        return ig.game.setPlayerHealth(this.health);
      },
      draw: function() {
        var x, y;

        x = this.pos.x + this.size.x / 2;
        y = this.pos.y + this.size.y / 2;
        this.drawLine('green', x, y, x + this.vel.x, y + this.vel.y);
        return this.parent();
      },
      drawLine: function(color, sx, sy, dx, dy) {
        ig.system.context.strokeStyle = color;
        ig.system.context.lineWidth = 1.0;
        ig.system.context.beginPath();
        ig.system.context.moveTo(ig.system.getDrawPos(sx - ig.game.screen.x), ig.system.getDrawPos(sy - ig.game.screen.y));
        ig.system.context.lineTo(ig.system.getDrawPos(dx - ig.game.screen.x), ig.system.getDrawPos(dy - ig.game.screen.y));
        ig.system.context.stroke();
        return ig.system.context.closePath();
      },
      kill: function() {
        this.parent();
        return ig.game.gameEnd("dead");
      }
    });
  });

}).call(this);
