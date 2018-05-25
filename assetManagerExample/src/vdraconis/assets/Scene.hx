package vdraconis.assets;
import gl.GlStage;
import openfl.display.Stage;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DTriangleFace;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import renderer.Renderer;
import renderer.TextureManager;
import swfdata.atlas.TextureStorage;

class Scene extends EventDispatcher {
    static var _inited:Bool = false;
    static public var assetsManager(default, null):AssetsManager;

    public var glStage(default, null):GlStage;

    var _stage:Stage;
    var _context3D:Context3D;


    public function new(stage:Stage) {
        super();
        // TODO проверить что сцена единственная. и не очищен инстанс
        if (_inited) throw "Scene already created";
        _stage = stage;
        _stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        _stage.stage3Ds[0].addEventListener(ErrorEvent.ERROR, onContextCreatedError);
        _stage.stage3Ds[0].requestContext3D("auto");
        _inited = true;
    }

    public function dispose():Void {
        if (!_inited) return;
        _stage.stage3Ds[0].removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        _stage.stage3Ds[0].removeEventListener(ErrorEvent.ERROR, onContextCreatedError);
        _stage.removeEventListener(Event.RESIZE, onResize);
        _stage.removeEventListener(Event.ENTER_FRAME, onUpdate);

        // TODO - подумать, нужно ли удалять ВСЕ загруженные текстуры в менеджерах ресурсов
        //assetsManager.dispose();

        glStage.destroy();
        _context3D.dispose();

        _inited = false;

    }

    private function onContextCreatedError(e:ErrorEvent):Void
    {
        trace(e);
    }

    @:access(_internal)
    private function onContextCreated(e:Event):Void
    {
        _context3D = _stage.stage3Ds[0].context3D;

        @:privateAccess _context3D.__vertexConstants = new lime.utils.Float32Array(4 * Renderer.MAX_VERTEX_CONSTANTS);
        @:privateAccess _context3D.__fragmentConstants = new lime.utils.Float32Array(4 * Renderer.MAX_VERTEX_CONSTANTS);

        // TODO если выставлен флаг ресайзабл
        _stage.addEventListener(Event.RESIZE, onResize);


        _context3D.configureBackBuffer(_stage.stageWidth, _stage.stageHeight, 0, true);
        _context3D.setCulling(Context3DTriangleFace.NONE);

        //#if debug
        //	context3D.enableErrorChecking = true;
        //#end

        _context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);

        var textureManager:TextureManager = new TextureManager(_context3D);
        var textureStorage:TextureStorage = new TextureStorage();

        glStage = new GlStage(_stage, _context3D, textureStorage);

        assetsManager = new AssetsManager(textureStorage, textureManager);
        _stage.addEventListener(Event.ENTER_FRAME, onUpdate);

        dispatchEvent(new Event(Event.INIT));
    }

    private function onResize(e:Event):Void {
        // TODO если выставлен флаг фуллскрин
        _context3D.configureBackBuffer(_stage.stageWidth, _stage.stageHeight, 0, true);
    }

    private function onUpdate(e:Event):Void
    {
        glStage.update();
    }

}
