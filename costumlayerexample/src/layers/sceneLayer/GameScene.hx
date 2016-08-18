package layers.sceneLayer;

import layers.MouseData;
import openfl.Assets;
import openfl.display3D.Context3DTextureFormat;
import openfl.geom.Rectangle;
import renderer.Renderer;
import swfdata.atlas.GLSubTexture;
import swfdata.atlas.GLTextureAtlas;

class GameScene extends Scene
{
	var assetsLoader:AssetsLoader;
	var background:InfinityBackground;
	
	public function new(assetsLoader:AssetsLoader) 
	{
		super();
		
		this.assetsLoader = assetsLoader;
		
		makeScene();
	}
	
	override public function update():Void 
	{
		background.render(renderer);
		
		super.update();
	}
	
	override public function initialize(renderer:Renderer, mouseData:MouseData):Void 
	{
		super.initialize(renderer, mouseData);
		
		var atlas:GLTextureAtlas = new GLTextureAtlas("BG_Texture", Assets.getBitmapData("img/bg_tile_pattern.png", true), Context3DTextureFormat.BGRA, 0);		
		var bgTexture:GLSubTexture = cast(atlas.createSubTexture(0, new Rectangle(0, 0, 256, 256), 1, 1));
		background = new InfinityBackground(bgTexture, mouseData);
		atlas.uploadToGpu();
	}
	
	function makeScene() 
	{
		for(i in -48...48)
		{
			if (i % 2 == 0)
				continue;
				
			for (j in 0...6)
			{
				var tree:Actor = makeTree();
				tree.position.setTo( -48 + j * 4, i);
				
				addActor(tree);
			}
		}
		
		for(i in -26...46)
		{
			if (i % 2 == 0)
				continue;
				
			for (j in 0...6)
			{
				var tree:Actor = makeTree();
				tree.position.setTo( i, -47 + j * 4);
				
				addActor(tree);
			}
		}
		
		for (i in -25...44)
		{
			if (i % 5 != 0)
				continue;
				
			var bath:Actor = new Actor(assetsLoader.linkagesMap["bath"], assetsLoader.atlasMap["bath"]);
			bath.position.setTo( i, -23);
			
			addActor(bath);
		}
		
		for (i in 0...8)
		{
			for (j in 0...1)
			{
				var fountain:Actor = new Actor(assetsLoader.linkagesMap["valentine2016_kisses"], assetsLoader.atlasMap["valentine2016_kisses"]);
				fountain.position.setTo(-25 + i * 5, -15 + j * 5);
				
				addActor(fountain);
			}
		}
		
		for (i in 0...14)
		{
			for (j in 0...5)
			{
				var lemure:Actor = new Actor(assetsLoader.linkagesMap["bull_smith"], assetsLoader.atlasMap["bull_smith"]);
				
				lemure.position.setTo( -15 + i * 4, -10 + j * 4);
				
				addActor(lemure);
			}
		}
		
		for (i in 0...7)
		{
			for (j in 0...4)
			{
				var circus:Actor = new Actor(assetsLoader.linkagesMap["circus"], assetsLoader.atlasMap["circus"]);
				
				circus.position.setTo( -24 + i * 10, 10 + j * 10);
				
				addActor(circus);
			}
		}
	}
	
	private var treesList:Array<String> = [
											"albion_mirabelle_2_touchable", "cypress_2", "cypress_3", "cypress_4", "pinetree_1", "pinetree_2", "pinetree_3", "pinetree_4",
											"chestnut_tree_1", "chestnut_tree_2", "chestnut_tree_3", "chestnut_tree_4", "albion_mirabelle_2"
										  ];
										  
										  
	function makeTree():Actor
	{
		var treeId:String = treesList[Math.floor(Math.random() * treesList.length)];
		var tree:Actor = new Actor(assetsLoader.linkagesMap[treeId], assetsLoader.atlasMap[treeId]);
		//tree.view.gotoAndStopAll(0);
		tree.isPlay = false;
		
		return tree;
	}
}