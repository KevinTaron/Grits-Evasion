ig.module(
  'game.entities.smally'
)
.requires(
    'game.entities.enemy'
)
.defines =>
  @EntitySmally = EntityEnemy.extend
    size: {x: 35, y: 35}
    health: 1
    MaxHealth: 1
    points: 5
    shoots: false
    animSheet: new ig.AnimationSheet( 'media/grits_enemy_small.png', 35, 35)

    init: (x, y, settings) ->
        @parent(x,y, settings)

    getPathPosX: () ->
        ig.game.mapSize.x * Math.random()

    getPathPosY: () ->
        ig.game.mapSize.y * Math.random()
