//////////////////////////////////////////////////////////
//Modify this somehow to alternately load textures.
// i.e. I should be able to load all brush shapes as white geoms,
// or I should be able to load them as mapped textures.
//Secondly, scale should be adjustable. Then I can load an
// untextured, smaller version into the navigation panel. maybe
// also use this for some level effects, like:
// 'drink me -> shrink', 'eat me -> grow'
// 


package engine{

	import flash.events.Event;
	//import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.display.Stage;
	import engine.actors.MapObject;
	import system.TextParser;
	import system.TextLoader;
	import system.ImageLoader;
	import engine.actors.Block;


	dynamic public class Map extends MovieClip {
		
		public var objectArray:Array = new Array();
		
		public var mapData:TextLoader = new TextLoader();
		public var parsedMap:TextParser = new TextParser();
		public var bounds:int;
		public var imgLdr:ImageLoader = new ImageLoader(imgLoadSuccess,imgLoadFail);
		public var mapName:String = '';
		public var mapBG:String = '';
		public var mapTexture:String = '';
		public var mapTileSize:uint = 8;
		public var mapDisplayScale:uint = 2;
		public var hero = 'ff';
		//eventually object deffinitions from 
		//BrushDefs instead of static array
		//brushes
		var brushDefs:String = "settings/BrushDefs.txt";
		var brushMap:TextLoader = new TextLoader();
		public var objProps = new Array(
		[0,0,0,0,0],
		[2,2,0,0,0],
		[1,2,2,0,0],
		[4,4,0,2,0],
		[1,2,3,0,0],
		[4,4,1,2,'3x']//animation
		);
		//
		public function Map() {
			//trace("game loaded");
			if (stage != null) {
				buildMap();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		private function addedToStage(evt) {
			buildMap();
		}
		public function buildMap() {
			//mapData.addEventListener(Event.COMPLETE, parseMapData);
			//TODO:  use text loader instead of objects on stage
			for(var n=0; n<this.numChildren; n++){
				trace(this.getChildAt(n));
				objectArray.push(this.getChildAt(n));
			}
			trace(this.numChildren);
			//objectArray.push(stage.getChildAt(1));
			//objectArray.push(stage.getChildAt(2));
		}
		public function getMap(level:String) {
			mapData.loadFile(level);
		}
		// parse map to flash object
		public function parseMapData(evt:Event) {
			//display array of objects returned from processing
			//displayMap(TextParser.textToArray(evt.target.data));
		}
		//show the background image
		public function imgLoadSuccess(evt:*){
			var img:Bitmap = new Bitmap(evt.target.content.bitmapData);
			//img.scaleX = 2;
			//img.scaleY = 2;
			addChildAt(img,0);
		}
		public function imgLoadFail(evt:*){
			trace(evt.text);
		}
		//add objects to stage
		public function displayMap(mapObj:Array) {
			//trace(mapObj);
			for (var i=0; i<mapObj.length; i++) {
			//trace(mapObj[i]+",\n");
				//
				if(mapObj[i] == 'header'){
					//
				}else if(mapObj[i] == 'name'){
					mapName = mapObj[++i];
				}else if(mapObj[i] == 'desc'){
					mapBG = mapObj[++i];
					//imgLdr.load('textures/'+mapBG);
				}else if(mapObj[i] == 'texture'){
					mapTexture = mapObj[++i];
				}else if(mapObj[i] == 'bgImage'){
					mapTileSize = mapObj[++i];
				}else if(mapObj[i] == '/header'){
					//
				}else{
					var uri:String = ''
					/*if(mapObj[i][0] == 0){
						continue;
					}else if(mapObj[i][0] == 1){
						uri = "plat_sm.png";
					}else if(mapObj[i][0] == 2){
						uri = "wall_l.png";
					}else if(mapObj[i][0] == 3){
						uri = "plat_lg.png";
					}*/
					
					//write map objects to array in global memory
					//objectArray is complete list of objects in map
					objectArray.push(new Block(objProps[mapObj[i][0]][0],objProps[mapObj[i][0]][1],"textures/"+uri));
					var tmpX:int = Math.round(mapObj[i][1]);
					var tmpY:int = Math.round(mapObj[i][2]);
					objectArray[objectArray.length-1].x = tmpX;
					objectArray[objectArray.length-1].y = tmpY;
					this.addChild(objectArray[objectArray.length-1]);
				}
			}
			//**********************
			//TODO: Fix getLeftBound
			//**********************
			//this.bounds = getLeftBound(objectArray);
			this.bounds = 800;
			trace("map loaded: "+mapName);
			//??really
			dispatchEvent(new Event("complete"));
		}
		//****************************************
		//TODO: fix this
		// so it works with current map model
		// needs to remove or check for header tags
		//****************************************
		// find the farthest platform, 
		// possible example of how to get additional info about Array
		// should still be done in wrapper or extention,  maybe one that impliments stats classes.
		private function getLeftBound(objList:Array):int {
			var grtst:int = Math.round(objList[0][1])+Math.round(objProps[objList[0][0]][0]*32);
			for (var obj in objList) {
				//trace(Math.round(objProps[objList[obj][0]][0]));
				if (Math.round(objList[obj][1])+Math.round(objProps[objList[obj][0]][0]*32) > grtst) {
					grtst = Math.round(objList[obj][1])+Math.round(objProps[objList[obj][0]][0]*32);
				}
			}
			trace("Rightmost landing point: "+grtst);
			return grtst;
		}
	}
}