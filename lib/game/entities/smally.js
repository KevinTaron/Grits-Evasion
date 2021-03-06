// Generated by CoffeeScript 1.6.2
(function() {
  var _this = this;

  ig.module('game.entities.smally').requires('game.entities.enemy').defines(function() {
    return _this.EntitySmally = EntityEnemy.extend({
      size: {
        x: 35,
        y: 35
      },
      health: 1,
      MaxHealth: 1,
      points: 5,
      shoots: false,
      animSheet: new ig.AnimationSheet('media/grits_enemy_small.png', 35, 35),
      init: function(x, y, settings) {
        return this.parent(x, y, settings);
      },
      getPathPosX: function() {
        return ig.game.mapSize.x * Math.random();
      },
      getPathPosY: function() {
        return ig.game.mapSize.y * Math.random();
      }
    });
  });

}).call(this);
