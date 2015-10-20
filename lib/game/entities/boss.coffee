ig.module(
  'game.entities.boss'
)
.requires(
    'game.entities.enemy'
)
.defines =>
  @EntityBoss = EntityEnemy.extend
    size: {x: 210, y: 210}
    health: 25
    MaxHealth: 25
    points: 150
    shoots: true
    animSheet: new ig.AnimationSheet( 'media/grits_boss.png', 220, 220)


    init: (x, y, settings) ->
        @parent(x,y, settings)
        @addAnim( 'walk', 0.1, [0, 1, 2, 2, 1, 0])
        if @shoots 
            @ShootTimer = new ig.Timer(1)

    getPathPosX: () ->
        if @pos.x == 1344
            return 2500
        else 
            1350

    getPathPosY: () ->
        800
