ig.module(
    'game.entities.robot'
)
.requires(
    'impact.entity',
    'game.entities.bullet',
    'game.entities.healthbar'
)
.defines =>
  @EntityRobot = ig.Entity.extend
    type: ig.Entity.TYPE.B
    enemyType: ig.Entity.TYPE.A
    collides: ig.Entity.COLLIDES.PASSIVE
    size: {x: 70, y: 70}
    animSheet: new ig.AnimationSheet( 'media/grits_player.png', 70, 70)
    speed: 1
    weaponType: 1
    immortal: false
    immortalTimer: new ig.Timer()
    ShootTimer: new ig.Timer()
    bounciness: 0
    shoots: false
    health: 1
    MaxHealth: @health

    init: (x, y, settings) ->
        @addAnim( 'idle', 1, [0])
        @addAnim( 'walk', 0.1, [0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 0])
        @addAnim( 'walkblink', 0.1, [0, 10, 1, 2, 10, 3, 4, 10, 5, 6, 10, 7, 8, 10, 7, 6, 10, 5, 4, 10, 3, 2, 10, 1, 0])
        @addAnim( 'blink', 0.3, [0, 10])
        if( !ig.global.wm )
            ig.game.spawnEntity(EntityHealthbar,@pos.x , @pos.y,{ Unit: @ });
        @parent(x,y, settings)
        
    update: () ->
        if @shoots
            @shoot()
        if @immortalTimer.delta() > 0 
            @immortal = false
            @immortalTimer.pause()
            # @currentAnim = @anims.idle
        @parent();

    collideWith: (other, axis) ->
        if !@immortal
            if other instanceof EntityBullet
                @receiveDamage(1, other)
                @currentAnim = @anims.blink
                @immortal = true
                @immortalTimer.set(0.2) 
            else if other instanceof EntityPlayer            
                @receiveDamage(1, other)
                @currentAnim = @anims.blink


    shoot: () ->
        if @ShootTimer.delta() > 0 
            if @target
                targets = ig.game.getEntitiesByType(@target)
                nTarget = @getNextTarget(targets)
                if nTarget 
                    if (@pos.y + ig.system.height/2 > nTarget.pos.y) && (@pos.y - ig.system.height/2 < nTarget.pos.y) && (@pos.x + ig.system.width/2 > nTarget.pos.x) && (@pos.x - ig.system.width/2 < nTarget.pos.x) 
                        ig.game.spawnEntity(EntityBullet, @pos.x, @pos.y, {angle: @angleTo(nTarget), owner: @type, enemyType: @enemyType, weaponType: @weaponType}) if nTarget
                        @ShootTimer.reset()

    getNextTarget: (targets) ->
        if targets.length > 0
            nextTarget = targets[0]
            for target in targets
                if @distanceTo(nextTarget) > @distanceTo(target)
                    nextTarget = target
        nextTarget

    receiveDamage: (amount, from) ->
        if !@immortal
            @parent(amount, from)
            @immortal = true
            @immortalTimer.set(3)
