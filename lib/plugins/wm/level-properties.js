ig.module(
    'plugins.wm.level-properties'
)
.defines(function(){
wm.LevelProperties = ig.Class.extend({
    properties: {},

    background: null,

    init: function() {
        $('.headerFloat').prepend('<input type="button" id="levelPropertiesButton" value="Properties" class="button" style="margin-right: 10px;"/>');
        var div = $('<div id="levelProperties"></div>');
        div.append('<h2>Level Properties</h2>');
        div.append('<input type="button" id="levelPropertiesCloseButton" value="close" class="button"/>');
        
        var inputdiv = $('<dl id="propertyInput"></dl>');
        inputdiv.append('<dt>Key:</dt><dd><input type="text" class="text" id="propertyKey" /></dd>');
        inputdiv.append('<dt>Value:</dt><dd><input type="text" class="text" id="propertyValue" /></dd>');
        div.append(inputdiv);
        div.append($('<div id="propertyDefinitions"></div>'));


        $('body').append(div);
        $('body').append('<div id="bg" class="modalDialogBackground"></div>');

        $('#levelPropertiesButton').bind('click', this.showUI.bind(this));
        $('#levelPropertiesCloseButton').bind('click', this.closeUI);
        
        $('#propertyKey').bind('keydown', function(ev){ 
            if( ev.which == 13 ){ 
                $('#propertyValue').focus(); 
                return false;
            }
            return true;
        });

        $('#propertyValue').bind('keydown', this.setLevelProperty.bind(this));
    },

    clear: function() {
        this.properties = {};
    },

    setLevelProperty: function(ev) {
        if(ev.which != 13) {
            return true;
        }

        var key = $('#propertyKey').val();
        var value = $('#propertyValue').val();
        var floatVal = parseFloat(value);
        if( value == floatVal ) {
            value = floatVal;
        }

        if(value == null || value == '') {
            this.remove(key);
        } else {
            this.set(key, value);
        }


        ig.game.setModified();
        $('#propertyKey').val('');
        $('#propertyValue').val('');
        $('#propertyValue').blur();
        this.refreshUI();

        $('#propertyKey').focus(); 

        return false;
    },

    remove: function(key) {
        console.log('test');
        if (key in this.properties) {
            console.log('ok');
            delete this.properties[key];
        }
    },

    set: function(key, val) {
        this.properties[key] = val;
    },

    add: function(key, val) {
        this.set(key, val);
    },

    getSaveData: function() {
        return this.properties;
    },

    refreshUI: function() {
        var html = this.loadPropertiesRecursive(this.properties);
        $('#propertyDefinitions').html(html);

        $('.propertyDefinition').bind( 'mouseup', this.selectProperty );
    },

    loadPropertiesRecursive: function( properties, path ) {
        path = path || "";
        var html = "";
        for( var key in properties ) {
            var value = properties[key];
            if( typeof(value) == 'object' ) {
                html += this.loadPropertiesRecursive( value, path + key + "." );
            }
            else {
                html += '<div class="propertyDefinition"><span class="key">'+path+key+'</span>:<span class="value">'+value+'</span></div>';
            }
        }
        
        return html;
    },

    selectProperty: function( ev ) {
        $('#propertyKey').val( $(this).children('.key').text() );
        $('#propertyValue').val( $(this).children('.value').text() );
        $('#propertyValue').select();
    },

    showUI: function(ev) {
        this.refreshUI();
        $('#bg').fadeIn();
        $('#levelProperties').fadeIn();
        return false;
    },

    closeUI: function(ev) {
        $('#bg').fadeOut();
        $('#levelProperties').fadeOut();
        return false;
    }
})
});