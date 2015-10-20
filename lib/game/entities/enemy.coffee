ig.module(
  'game.entities.enemy'
)
.requires(
    'game.entities.robot'
)
.defines =>
  @EntityEnemy = EntityRobot.extend
    TYPE: ig.Entity.TYPE.B
    checkAgainst: ig.Entity.TYPE.B
    health: 3
    MaxHealth: 3
    angle: 0
    points: 10
    speed: 1
    target: 'EntityPlayer'
    shoots: true 
    ShootTimer: null
    shootSpeed: 2

    init: (x, y, settings) ->
        # @target = settings.target if settings.target
        if (!ig.global.wm)
            @target = ig.game.getEntitiesByType(EntityPlayer)[0]
            @angle = @angleTo(@target) if @target
            if @shoots 
                @ShootTimer = new ig.Timer(5)
            # @getPath(@getPathPosX(), @getPathPosY(), true, [], [])
        @parent(x,y, settings)

    update: () ->
        @followPath(500, true);
        if @path == null
            @currentAnim = @anims.idle
            @getPath(@getPathPosX(), @getPathPosY(), true, [], [])
        else 
            @currentAnim = @anims.walk

        @parent()

    getPathPosX: () ->
        @target.pos.x   

    getPathPosY: () ->
        @target.pos.y

    draw: () ->
        @parent()

    shoot: () ->
        if @ShootTimer.delta() > 0 
            if @target
                nTarget = @target
                if nTarget
                    ig.game.spawnEntity(EntityBullet, @pos.x, @pos.y, {angle: @angleTo(nTarget), enemyType: @enemyType, shootSpeed: @shootSpeed}) if nTarget
            @ShootTimer.reset()
        
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
                @immortal = true
                @immortalTimer.set(3)

    kill: () ->
        @parent()
        ig.game.kills += 1
        ig.game.increasePoints(@points)
