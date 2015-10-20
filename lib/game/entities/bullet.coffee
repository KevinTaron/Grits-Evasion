ig.module(
    'game.entities.bullet'
)
.requires(
   'impact.entity'
   'game.entities.explosion'
)
.defines =>
  @EntityBullet = ig.Entity.extend
    type: ig.Entity.TYPE.B
    checkAgainst: ig.Entity.TYPE.B
    collides: ig.Entity.COLLIDES.NEVER
    target: 'EntityEnemy'
    size: {x: 64, y: 60}
    angle: 90
    speed: 5
    health: 1
    weaponType: 1
    ShootSound: new ig.Sound( 'sound/grenade_shoot0.ogg' )

    animSheet: new ig.AnimationSheet( 'media/shoot.png', 84, 80)

    init: (x, y, settings) ->
        @weaponType = settings.weaponType if settings.weaponType
        @angle = settings.angle if settings.angle
        @type = settings.owner if settings.owner
        @checkAgainst = settings.enemyType
        @speed = settings.shootSpeed if settings.shootSpeed
        @parent(x,y, settings)
        @offset.x = 10
        @offset.y = 10
        @addAnim( 'idle', 1, [0])
        @addAnim( 'explosion', 0.3, [1,2,3,3,2,1])
        @ShootSound.volume = 0.4
        @ShootSound.play() 

    update: () ->
        deltaY = Math.sin(@angle) * (100 * this.speed);
        deltaX = Math.cos(@angle) * (100 * this.speed);

        @maxVel.x = @vel.x = @accel.x = deltaX;
        @maxVel.y = @vel.y = @accel.y = deltaY;

        @parent()

    collideWith: (other, axis) ->
        @receiveDamage(1, other)

    check: (other) ->
        if !(other instanceof EntityBullet)
            @collides = ig.Entity.COLLIDES.ACTIVE

    kill: () ->
        ig.game.spawnEntity(EntityExplosion, @pos.x, @pos.y, null)
        @ShootSound.stop() 
        @parent()

    handleMovementTrace: (res) ->
        if res.collision.x || res.collision.y
            @receiveDamage(1, res)
        @parent(res)

