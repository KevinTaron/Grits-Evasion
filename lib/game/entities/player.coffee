ig.module(
  'game.entities.player'
)
.requires(
    'game.entities.robot'
    'game.entities.enemy'
)
.defines =>
  @EntityPlayer = EntityRobot.extend
    type: ig.Entity.TYPE.A
    checkAgainst: ig.Entity.TYPE.B
    enemyType: ig.Entity.TYPE.B
    collides: ig.Entity.COLLIDES.ACTIVE
    target: 'EntityEnemy'
    shoots: true
    ShootTimer: new ig.Timer()
    health: 3
    MaxHealth: 3

    init: (x, y, settings) ->
        @parent(x,y, settings)
        @ShootTimer.set(1)
        if !ig.global.wm
            @health = ig.game.getPlayerHealth()

    update: () ->
        mx = (ig.input.mouse.x + ig.game.screen.x);
        my = (ig.input.mouse.y + ig.game.screen.y);
        r = Math.atan2(my-@pos.y, mx-@pos.x);

        deltaY = Math.sin(r) * (100 * @speed);
        deltaX = Math.cos(r) * (100 * @speed);

        if mx < @pos.x + 3 and mx > @pos.x and my < @pos.y + 3 and my > @pos.y - 3
            @currentAnim = @anims.idle
            @vel.x = 0
            @vel.y = 0
        else
            if @immortal then @currentAnim = @anims.walkblink else @currentAnim = @anims.walk;
            @maxVel.x = @vel.x = @accel.x = deltaX
            @vel.y = deltaY
        @parent()

    check: (other) ->
        @receiveDamage(1, other)
        @parent()

    receiveDamage: (amount, from) ->
        @parent(amount, from)
        ig.game.setPlayerHealth(@health)

    draw: () ->
        x = @pos.x + @size.x/2
        y = @pos.y + @size.y/2
            
        @drawLine( 'green', x, y, x + @vel.x, y + @vel.y )
        @parent()

    drawLine: ( color, sx, sy, dx, dy ) ->
        ig.system.context.strokeStyle = color
        ig.system.context.lineWidth = 1.0

        ig.system.context.beginPath()
        ig.system.context.moveTo(
            ig.system.getDrawPos(sx - ig.game.screen.x),
            ig.system.getDrawPos(sy - ig.game.screen.y)
        )

        ig.system.context.lineTo( 
            ig.system.getDrawPos(dx - ig.game.screen.x),
            ig.system.getDrawPos(dy - ig.game.screen.y)
        )
        ig.system.context.stroke()
        ig.system.context.closePath()

    kill: () ->
        @parent()
        ig.game.gameEnd("dead")