// Generated by CoffeeScript 1.6.2
(function() {
  var _this = this;

  ig.module('game.entities.boss').requires('game.entities.enemy').defines(function() {
    return _this.EntityBoss = EntityEnemy.extend({
      size: {
        x: 210,
        y: 210
      },
      health: 25,
      MaxHealth: 25,
      points: 150,
      shoots: true,
      animSheet: new ig.AnimationSheet('media/grits_boss.png', 220, 220),
      init: function(x, y, settings) {
        this.parent(x, y, settings);
        this.addAnim('walk', 0.1, [0, 1, 2, 2, 1, 0]);
        if (this.shoots) {
          return this.ShootTimer = new ig.Timer(1);
        }
      },
      getPathPosX: function() {
        if (this.pos.x === 1344) {
          return 2500;
        } else {
          return 1350;
        }
      },
      getPathPosY: function() {
        return 800;
      }
    });
  });

}).call(this);
