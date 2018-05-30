package vdraconis.assets;
import openfl.geom.Matrix;
import swfdata.DisplayObjectData;
import swfdata.MovieClipData;
import swfdata.SpriteData;

class AssetContainer extends SpriteData {

    public var bundleName(default, null): String;
    public var linkageName(default, null): String;
    public var content(default, null):DisplayObjectData;
    public var mc(default, null):MovieClipData;

    var _assetsManager:AssetsManager;

    public function new(resourceName:String, linkageName:String = null) {
        super();
        this.bundleName = resourceName;
        this.linkageName = linkageName;
        // TODO нужен IoC для assetsManager
        _assetsManager = Scene.assetsManager;
        transform = new Matrix();
        load();
    }

    function load() {
        _assetsManager.load(bundleName, linkageName, onComplete, onError);
    }

    function onComplete(_):Void {
        var key = getHash();
        //TODO разобраться с клонами
        content = _assetsManager.linkagesMap[key].clone();
        addDisplayObject(content);
        if (Std.is(content, MovieClipData)){
           // TODO не хочет проигрываться
            mc = cast content;
            mc.play();
        }
    }

    function onError(_):Void {
        trace("Error onError");
    }

    public function getHash() : String {
        return (this.bundleName != null ? this.bundleName : "") + (linkageName != null ? "#" + linkageName : "");
    }

}