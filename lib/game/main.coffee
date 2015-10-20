ig.module( 
    'game.main' 
)
.requires(
    'impact.game',
    'impact.font',
    'game.levels.main',
    'game.levels.level2',
    'game.entities.player',
    'game.entities.smally',
    # 'impact.debug.debug',
    'plugins.astar-for-entities',
    'plugins.impact-storage',
    'game.levels.boss1'
    'game.levels.boss2'
)
.defines =>
    @GritsEvasion = ig.Game.extend
        font: new ig.Font( 'media/04b03.font.png' ),
        mapSize: {x: 0, y: 0}
        currentLevel: LevelMain,
        # currentLevel: LevelLevel2,
        # currentLevel: LevelBoss2
        enemysLevel: []
        Points: 0
        playerHealth: 3
        kills: 0
        spawnTimer: new ig.Timer()
        Player: null
        storage: new ig.Storage()
        SpawnSound: new ig.Sound( 'sound/spawn0.ogg' )
        ready: true

        init: () ->
            ig.music.add('sound/bg_game.ogg', 'bgmusic')
            ig.music.volume = 0.3
            ig.music.play('bgmusic')
            @storage = new ig.Storage()
            ig.input.initMouse()
            ig.input.bind(ig.KEY.P, "pause")

            @loadLevel( @currentLevel )
            sampleMap = ig.game.backgroundMaps[0]
            sampleMap.preRender = true
            @mapSize.x = sampleMap.width * sampleMap.tilesize
            @mapSize.y = sampleMap.height * sampleMap.tilesize

            @getLevelSettings()

        update: () ->
            if !@ready
                @pauseGame()
            else 
                @parent()
                if @kills >= @KillsToBoss
                    @changeLevel()

                if @spawnTimer.delta() > 0
                    @spawn()
                    @spawnTimer.reset()

                if ig.input.pressed("pause") 
                    @pauseGame()

                player = @getEntitiesByType( EntityPlayer )[0]
                if player 
                    plPosX = player.pos.x - ig.system.width/2
                    plPosY = player.pos.y - ig.system.height/2
                    if plPosX > 0 && plPosX < (@mapSize.x - ig.system.width) 
                        @screen.x = plPosX
                    if plPosY > 0 && plPosY < (@mapSize.y - ig.system.height) 
                        @screen.y = plPosY
                    
        spawn: () ->
            player = @getEntitiesByType( EntityPlayer )[0]
            if Math.round(Math.random()) == 1 
                spawnPosX = player.pos.x - ((Math.random()*500)+200)
            else 
                spawnPosX = player.pos.x + ((Math.random()*500)+200)

            if Math.round(Math.random()) == 1 
                spawnPosY = player.pos.y - ((Math.random()*500)+200)
            else 
                spawnPosY = player.pos.y + ((Math.random()*500)+200)

            if spawnPosX < 0 
                spawnPosX *= -1 
            if spawnPosY < 0
                spawnPosY *= -1

            enem = Math.random() * 10

            for k, value of @enemysProb
                if enem < value
                    enem = k
                    break

            enem = @enemysLevel.length-1 if enem > @enemysLevel.length-1
            spawnEnemy = @enemysLevel[enem]
            ig.game.spawnEntity(spawnEnemy, spawnPosX , spawnPosY, {target: player})
            @SpawnSound.volume = 0.4
            @SpawnSound.play() 


        draw: () ->
            @parent()

        getLevelSettings: () ->
            @Player = @getEntitiesByType( EntityPlayer )[0]
            @enemysLevel = @getEnemys(@currentLevel.properties.Enemyss)
            @enemysProb = @getEnemysProb(@currentLevel.properties.EnemysProb)
            @KillsToBoss = @currentLevel.properties.KillsToBoss
            @NextLevel = @currentLevel.properties.NextLevel
            if @currentLevel.properties.BossLevel == 'true'
                @spawnTimer.set(2)
                @spawnTimer.pause()
            else 
                @spawnTimer.set(parseInt(@currentLevel.properties.SpawnTimer))

            @getReady(@currentLevel.properties.Name)


        getEnemys: (enemyss) ->
            enemys = []
            while (enemyss.search /,/) != -1
                enem = enemyss.replace /,.*/, ''
                enemys.push enem 
                enemyss = enemyss.replace /\w*\,/, ''

            enemys.push enemyss
            return enemys

        getEnemysProb: (enemyss) ->
            enemys = []
            while (enemyss.search /,/) != -1
                enem = enemyss.replace /,.*/, ''
                enemys.push enem 
                enemyss = enemyss.replace /\w*\,/, ''

            enemys.push enemyss
            return enemys


        changeLevel: () ->
            @kills = 0
            if next == "End"
                @gameEnd("beat")
            else 
                next = eval('{' + @NextLevel + '}')
                @currentLevel = next
                @getLevelSettings()
                @loadLevel(next)

        setPlayerHealth: (health) ->
            @playerHealth = health

        getPlayerHealth: () ->
            @playerHealth

        increasePoints: (points) ->
            @Points += points
            jQuery('#points').html(@Points)

        pauseGame: () ->
            jQuery('#pauseScreen').show()
            if !@ready
                jQuery('.ready').show()
                jQuery('.paused').hide()
                @getReady()
                ig.system.stopRunLoop.call(ig.system)
            else
                ig.system.stopRunLoop.call(ig.system)
                jQuery('.ready').hide()
                jQuery('.paused').show()
            ig.music.stop('bgmusic') if !ig.music.currentTrack.paused

        resumeGame: () ->
            jQuery('#pauseScreen').hide()
            ig.system.startRunLoop.call(ig.system)
            ig.music.play('bgmusic')

        getReady: () ->
            if !@ready
                @rdy = new ig.Timer()
                @rdy.set( 3 )
                jQuery('canvas').delay(3000)


        gameEnd: (status) ->
            ig.system.stopRunLoop.call(ig.system)
            jQuery('.score').html(ig.game.Points)
            if ig.game.storage.get("highscore") == null
                ig.game.storage.set("highscore", ig.game.Points) 
            else 
                ig.game.storage.setHighest("highscore", ig.game.Points) 
            jQuery('.highscore').html(localStorage.highscore) if localStorage.highscore
            ig.music.stop('bgmusic') if !ig.music.currentTrack.paused

            if status == "dead"
                jQuery('.gameover').show("drop", {direction: "top"}, "slow")
            else
                jQuery('.gameend').show("drop", {direction: "top"}, "slow")


    # ig.main( '#canvas', GritsEvasion, 60, window.innerWidth, window.innerHeight, 1 )


