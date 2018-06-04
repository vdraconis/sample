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

    public function new(bundleName:String, linkageName:String = null) {
        super();
        this.bundleName = bundleName;
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
            mc = cast content;
            mc.gotoAndPlay(Std.int(Math.random() * mc.framesCount));
        }
    }

    function onError(_):Void {
        trace("Error onError");
    }

    public function getHash() : String {
        return (this.bundleName != null ? this.bundleName : "") + (linkageName != null ? "#" + linkageName : "");
    }

}