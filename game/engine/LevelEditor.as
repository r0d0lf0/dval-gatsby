package editor{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.net.FileReference;
	import fl.data.DataProvider;
	import editor.ui.DialogBase;
	import editor.ui.DialogBoolean;
	import editor.ui.DialogMapSettings;
	import editor.ui.DialogSelect;
	import editor.ui.DialogBrushTexture;
	import editor.GridCell;
	import system.MapObject;
	// add Map, instead of all custom control
	//import system.Map;
	import system.behaviors.BehaviorBlock;
	import lib.TextLoader;
	import lib.TextParser;
	//when Map is used, use this
	//import lib.ImageLoader;
	
	public class LevelEditor extends MovieClip{
		// globals ?? maybe move to MapLayout Object
		var navWidth:uint = 320;//this is lame
		var navHeight:uint = 120;//these should come from the navHolder
		var holdWidth:uint = 3840;//and these should be variable when
		var holdHeight:uint = 1440;//mapObjects are layed out that far;
		//selected map item
		var selectM:Sprite;
		var MoffsetX:int;
		var MoffsetY:int;
		//List of map objects in Map
		var bs:Array = new Array();
		//list of map objects in Navigation Panel
		var ms:Array = new Array();
		//some test vars
		var behavArray = new Array({item:0,label:' '},{item:1,label:'floor'},{item:2,label:'block'},{item:3,label:'move_vert'},{item:4,label:'door'});
		/*
		var objProps = new Array(
		[0,0,0,0,null],
		[2,2,0,0,null],
		[1,2,2,0,null],
		[4,4,0,2,null],
		[1,2,3,0,null],
		[4,4,1,2,'3x']
		);*/
		var objProps = new Array();
		// navigation window display
		var mapNav:MovieClip = new MovieClip();
		//external settings
		var defaultFile:String = "maps/atticMap2.txt";
		var savedMap:TextLoader = new TextLoader();
		var MapList:String = "settings/MapList.txt";
		var savedList:TextLoader = new TextLoader();
		var BackgroundList:String = "settings/BackgroundList.txt";
		var backgroundList:TextLoader = new TextLoader();
		var TextureList:String = "settings/TextureList.txt";
		var textureList:TextLoader = new TextLoader();
		//brushes
		var brushDefs:String = "settings/BrushDefs.txt";
		var brushMap:TextLoader = new TextLoader();
		//display helpers
		var willum:Shape = new Shape();
		//map settings
		var mapName:String;
		var mapBG:String;
		var mapTexture:String;
		var mapBGTiled:Boolean = false;
		var mapTileSize:uint = 8;
		var mapDisplayScale:uint = 2;
		//var mapHolder:Map = new Map();
		//
		public function LevelEditor():void{
			navWidth = navMini.width-1;//this is lame
			navHeight = navMini.height-1;//these should come from the navHolder
			holdWidth = 3840;//and these should be variable when
			holdHeight = 1440;//mapObjects are layed out that far;
			//main level buttons
			make_btn.addEventListener(MouseEvent.CLICK, makeHandler);
			load_btn.addEventListener(MouseEvent.CLICK, loadHandler);
			save_btn.addEventListener(MouseEvent.CLICK, saveHandler);
			new_btn.addEventListener(MouseEvent.CLICK, newHandler);
			map_btn.addEventListener(MouseEvent.CLICK, mapBtnHandler);
			tile_btn.addEventListener(MouseEvent.CLICK, tileBtnHandler);
			//tile properties panel
			propertyPanel.ID_ns.addEventListener(Event.CHANGE,swapBrushes);
			propertyPanel.delMapObj_btn.addEventListener(MouseEvent.CLICK, deleteBtnHandler);
			propertyPanel.action_cb.dataProvider = new DataProvider(behavArray);
			propertyPanel.action_cb.addEventListener(Event.CHANGE,propUpdateBehavior);
			propertyPanel.xTxt.addEventListener(Event.CHANGE,propUpdateX);
			propertyPanel.yTxt.addEventListener(Event.CHANGE,propUpdateY);
			//VOs that need load listeners
			savedMap.addEventListener(Event.COMPLETE, parseMap);
			savedList.addEventListener(Event.COMPLETE, parseList);
			backgroundList.addEventListener(Event.COMPLETE, backgroundImageList);
			textureList.addEventListener(Event.COMPLETE, textureImageList);
			brushMap.addEventListener(Event.COMPLETE, populateLibrary);
			//buttn labels
			make_btn.label = "Show Map";
			new_btn.label = "New";
			load_btn.label = "Load";
			save_btn.label = "Save";
			map_btn.label = "Map";
			tile_btn.label = "Tiles";
			reset_btn.label = "Reset";
			//style defaults
			maptext.backgroundColor = 0xEDEDED;
			maptext.text = "";
			mapNav.name = "mapNav";
			mapNav.x = navMini.x;
			mapNav.y = navMini.y;
			//the little box in the nav pane
			willum.name = "willum";
			willum.graphics.lineStyle(1,0xFFFFFF,0.6);
			willum.graphics.drawRect(0,0,40,30);
			//load map from template
			//where does texture get loaded from?
			//mapHolder.addEventListener(Event.COMPLETE,mapThingy);
			//mapHolder.getMap(defaultFile);
			populateNavGrid();
			//populateLibrary();
			brushMap.loadFile(brushDefs);
		}
		
		//
		//**************************************************************************//
		//Map load and display handlers
		//**************************************************************************//
		//called from mapLoader
		function parseMap(evt:Event){
			trace(evt.target);
			mapHolder.parseMapData(evt);
			activateSavedMap();
		}
		/*//
		function mapThingy(evt:Event):void{
			trace(evt.target);
			populateSavedMap();
		}
		//*/
		function activateSavedMap():void{
			for(var c in mapHolder.objectArray){
				if(mapHolder.objectArray[c] is MapObject){
					mapHolder.objectArray[c].addEventListener(MouseEvent.MOUSE_DOWN, selectedMapItem);
					
						
					var marker:MapObject = new MapObject(mapHolder.objectArray[c].w, mapHolder.objectArray[c].h);
					marker.scaleX = .09;
					marker.scaleY = .09;
					marker.ID = mapHolder.objectArray[c].ID;
					marker.x = mapHolder.objectArray[c].x*0.09;
					marker.y = mapHolder.objectArray[c].y*0.09;
					ms.push(marker);
					trace('naved');
					mapNav.addChild(ms[ms.length-1]);
				}
			}
		}
		//
		function clearMap():void{
			//clear map
			for(var c in mapHolder.objectArray){
				mapHolder.removeChild(mapHolder.objectArray[c]);
			}
			//clear nav
			for(var h in ms){
				if(ms[h] is MapObject){
					mapNav.removeChild(ms[h]);
				}
			}
			//reset both
			mapHolder.objectArray = new Array();
			
			ms = new Array();
		}
		//
		//**************************************************************************//
		//Map editing handlers
		//**************************************************************************//
		//
		function selectedMapItem(evt:MouseEvent) {
			// simplify path
			var t = evt.target;
			selectM = t;
			// create visual
			MoffsetX = (evt.target.mouseX)+1;
			MoffsetY = (evt.target.mouseY)+1;
			trace("X: "+MoffsetX+"\nY: "+MoffsetY);
			
			t.x = mapHolder.mouseX-(MoffsetX);
			t.y = mapHolder.mouseY-(MoffsetY);
			// follow mouse
			t.addEventListener(Event.ENTER_FRAME, moveSelectedMapItem);
			t.addEventListener(MouseEvent.MOUSE_UP, unSelectedMapItem);
		}
		
		//
		function unSelectedMapItem(evt:MouseEvent) {
			// simplify path
			var t = evt.target;
			// follow mouse
			t.removeEventListener(Event.ENTER_FRAME, moveSelectedMapItem);
			//for each block move the marker as well
			//var tempX = evt.target.mouseX;
			//var tempY = evt.target.mouseX;
			for(var i:int=0; i<mapHolder.objectArray.length; i++){
				if(t == mapHolder.objectArray[i]){
					//trace(mapHolder.objectArray[i]+'True')
					ms[i].x = (mapHolder.mouseX-(MoffsetX))*0.09;
					ms[i].y = (mapHolder.mouseY-(MoffsetY))*0.09;
				}
			}
			//update properties panel
			updateProperties(t);
		}
		//
		function moveSelectedMapItem(evt:Event) {
			var t = evt.target;
			t.x = mapHolder.mouseX-(MoffsetX);
			t.y = mapHolder.mouseY-(MoffsetY);
			if(!t.hitTestObject(mapMask)){
				t.removeEventListener(Event.ENTER_FRAME, moveSelectedMapItem);
				t.x = selectM.x;
				t.y = selectM.y;
			}
		}
		//**************************************************************************//
		//Navigation handlers
		//**************************************************************************//
		//
		function populateNavGrid():void {
			for (var h:uint=0; h<4; h++) {
				for (var w:uint=0; w<8; w++) {
					//trace(h+"_"+w);
					var cell:GridCell = new GridCell();
					cell.x = (cell.width)*w;
					cell.y = (cell.height)*h;
					cell.mouseEnabled = false;
					mapNav.addChild(cell);
					//trace(cell.width-1); 
				}
			}
			//mapNav.mask = navMask;
			mapNav.mouseChildren = false;
			mapNav.addChild(willum);
			addChild(mapNav);
			mapNav.addEventListener(MouseEvent.MOUSE_DOWN, startNav);
			mapNav.addEventListener(MouseEvent.MOUSE_UP, stopNav);
		}
		//
		function startNav(evt:MouseEvent){
			mapNav.addEventListener(Event.ENTER_FRAME,mapToNav);
		}
		//
		function stopNav(evt:MouseEvent){
			mapNav.removeEventListener(Event.ENTER_FRAME, mapToNav);
			//mapNav.removeEventListener(MouseEvent.MOUSE_UP, stopNav);
		}
		//updates position of map to corrispond with nav
		function mapToNav(evt){
			var t = evt.target;
			var divW = navWidth/holdWidth;
			var divH = navHeight/holdHeight;
			if(!t.hitTestObject(mapNav)){
				mapNav.removeEventListener(Event.ENTER_FRAME, mapToNav);
			}
			var willum = mapNav.getChildByName("willum");
			willum.x = t.mouseX-20;
			willum.y = t.mouseY-15;
			var Posx = Math.floor((t.mouseX-32)/divW);
			var Posy = Math.floor((t.mouseY-18)/divH);
			mapHolder.x = Posx*-1;
			mapHolder.y = Posy*-1;
		}
		
		//
		//**************************************************************************//
		//Library Items handlers
		//**************************************************************************//
		// library populated with MapObjects.  So Cute!
		// library is populated after BrushDefs loads
		function populateLibrary(evt:Event) {
			//trace(evt.target.data);
			objProps = TextParser.textToArray(evt.target.data)
			// array to replace dynamic array
			var libArray:Array = new Array();
			// for each item in library array...
			for (var i:int=1; i<objProps.length; i++) {
				// add it to the library and set object props
				libArray[i] = new MapObject(objProps[i][0],objProps[i][1]);
				libArray[i].ID = i;
				libArray[i].x = 12;
				libArray[i].y =(48*i);
				libArray[i].init = 1;//?needed?
				libArray[i].addEventListener(MouseEvent.MOUSE_DOWN, selectedLibItem);
				// add to display
				libraryHolder.addChild(libArray[i]);
			}
		}
		//
		function selectedLibItem(evt:MouseEvent) {
			// simplify path
			var t = evt.target;
			// create visual green
			var tmp:MapObject = new MapObject(t.w, t.h);
			tmp.ID = t.ID;
			tmp.x = stage.mouseX-(tmp.width/2);
			tmp.y = stage.mouseY-(tmp.height/2);
			// follow mouse
			tmp.addEventListener(Event.ENTER_FRAME, moveSelectedLibItem);
			tmp.addEventListener(MouseEvent.MOUSE_UP, unSelectedLibItem);
			// add to display
			stage.addChild(tmp);
		}
		//
		function moveSelectedLibItem(evt:Event) {
			evt.target.x = stage.mouseX-(evt.target.width/2);
			evt.target.y = stage.mouseY-(evt.target.height/2);
		}
		//
		function unSelectedLibItem(evt:MouseEvent) {
			// simplify path
			var t = evt.target;
			// don't follow mouse
			t.removeEventListener(Event.ENTER_FRAME, moveSelectedLibItem);
			t.removeEventListener(MouseEvent.MOUSE_UP, unSelectedLibItem);
			//if in the editing area: add New map object
			if(t.hitTestObject(mapMask)){
				var block:MapObject = new BehaviorBlock(t.w, t.h);
				block.ID = t.ID;
				block.x = mapHolder.mouseX-(t.width/2);
				block.y = mapHolder.mouseY-(t.height/2);
				block.addEventListener(MouseEvent.MOUSE_DOWN, selectedMapItem);
				mapHolder.objectArray[mapHolder.objectArray.length] = block;
				mapHolder.addChild(mapHolder.objectArray[mapHolder.objectArray.length-1]);
				updateProperties(mapHolder.objectArray[mapHolder.objectArray.length-1]);
				selectM=mapHolder.objectArray[mapHolder.objectArray.length-1];
				
				var marker:MapObject = new MapObject(t.w, t.h);
				marker.scaleX = .05;
				marker.scaleY = .05;
				marker.ID = t.ID;
				marker.x = (mapHolder.mouseX-(t.width/2))*0.09;
				marker.y = (mapHolder.mouseY-(t.height/2))*0.09;
				ms[ms.length] = marker;
				mapNav.addChild(ms[ms.length-1]);
			}
			stage.removeChild(t);
		}
		//
		//**************************************************************************//
		//Properties Panel text and number stepper handlers
		//**************************************************************************//
		//
		//set properties text 
		function updateProperties(item:*):void{
			if(item === null){
				propertyPanel.objNameTxt.text = "";
				propertyPanel.hTxt.text = "";
				propertyPanel.wTxt.text = "";
				propertyPanel.xTxt.text = "";
				propertyPanel.yTxt.text = "";
				propertyPanel.ID_ns.value = 0;
				propertyPanel.action_cb.selectedIndex = 0;
			}else{
				propertyPanel.objNameTxt.text = item.name;
				propertyPanel.hTxt.text = String(Math.floor(item.height)*.5);
				propertyPanel.wTxt.text = String(Math.floor(item.width)*.5);
				propertyPanel.xTxt.text = String(Math.floor(item.x)*.5);
				propertyPanel.yTxt.text = String(Math.floor(item.y)*.5);
				propertyPanel.ID_ns.value = item.ID;
				propertyPanel.action_cb.selectedIndex = item.init;
			}
		}
		//
		function propUpdateBehavior(evt:Event):void{
			var t = selectM;
			
			for(var r=0; r<mapHolder.objectArray.length; r++){
				if(mapHolder.objectArray[r] == t){
					t.init = evt.target.selectedItem.item;
				}
			}
		}
		//
		function propUpdateX(evt:Event):void{
			var t = selectM;
			
			for(var r=0; r<mapHolder.objectArray.length; r++){
				if(mapHolder.objectArray[r] == t){
					t.x = Number(evt.target.text);
				}
			}
		}
		//
		function propUpdateY(evt:Event):void{
			var t = selectM;
			
			for(var r=0; r<mapHolder.objectArray.length; r++){
				if(mapHolder.objectArray[r] == t){
					t.y = Number(evt.target.text);
				}
			}
		}
		//
		function swapBrushes(evt:Event):void{
			var t = selectM;
			var tx = selectM.x;
			var ty = selectM.y;
			var ind = 0;
			for(var r =0; r<mapHolder.objectArray.length;r++){
				if(mapHolder.objectArray[r] == t){
					ind = r;
					trace('shovel');
				}
			}
			//I don' tremember what this does
			//but it is very important
			var swapItem = new BehaviorBlock(objProps[uint(evt.target.value)][0],objProps[uint(evt.target.value)][1]);
			swapItem.ID = uint(evt.target.value);
			mapHolder.removeChild(mapHolder.objectArray[ind]);
			swapItem.x = tx;
			swapItem.y = ty;
			swapItem.init = mapHolder.objectArray[ind].init;
			swapItem.addEventListener(MouseEvent.MOUSE_DOWN, selectedMapItem);
			mapHolder.objectArray[ind] = swapItem;
			mapHolder.addChild(mapHolder.objectArray[ind]);
			selectM = mapHolder.objectArray[ind];
			
			mapNav.removeChild(ms[ind]);
					var marker:MapObject = new MapObject(objProps[uint(evt.target.value)][0],objProps[uint(evt.target.value)][1]);
					marker.scaleX = .09;
					marker.scaleY = .09;
					marker.ID = mapHolder.objectArray[ind].ID;
					marker.x = mapHolder.objectArray[ind].x*0.09;
					marker.y = mapHolder.objectArray[ind].y*0.09;
					ms[ind] = marker;
					trace('naved');
					mapNav.addChild(ms[ind]);
		}
		//
		//**************************************************************************//
		//Properties Panel Buttons
		//**************************************************************************//
		function deleteBtnHandler(mevt:MouseEvent):void{
			//
			var t = selectM;
			//var ind = 0;
			for(var r =0; r<mapHolder.objectArray.length;r++){
				if(mapHolder.objectArray[r] == t){
					//ind = r;
					trace('shovel');
					mapHolder.removeChild(mapHolder.objectArray[r]);
					mapNav.removeChild(ms[r]);
					//**************
					mapHolder.objectArray.splice(r,1);
					ms.splice(r,1);
				}
			}
			updateProperties(null);
		}
		//
		function makeHandler(mevt:MouseEvent):void {
			maptext.text = "";
			trace("hi");
			for(var i=0; i<mapHolder.objectArray.length; i++){
				var tmp:String = "["+mapHolder.objectArray[i].ID+","+Math.round(mapHolder.objectArray[i].x)+","+Math.round(mapHolder.objectArray[i].y)+","+mapHolder.objectArray[i].init+"]";
				maptext.appendText(tmp);
			}
		}
		
		//**************************************************************************//
		//Actions Buttons
		//**************************************************************************//
		function saveHandler(mevt:MouseEvent):void {
			//save
			//if AIR do SYS save
			//if web do PHP save
		}
		//
		function newHandler(mevt:MouseEvent):void {
			addChild(new DialogBoolean("Really?", "This will erase current map.\nAll unsaved data will be lost.\nDo you want to continue?", newResult));
		}
		//
		function newResult(evt:Boolean):void {
			if(evt){
				clearMap();
				trace('made new map');
			}else{
				trace('new map canceled');
			}
		}
		//
		function loadHandler(mevt:MouseEvent):void {
			addChild(new DialogBoolean("Load Saved Map", "This will replace current map.\nAll unsaved data will be lost.\nDo you want to continue?", checkLoadMap));
		}
		//
		function parseList(evt:Event):void {
			var mapList = TextParser.textToArray(evt.target.data);
			var colList = new Array(["0","Map"],["1","Date"]);
			addChild(new DialogSelect("Choose Map",mapList, loadResult,colList));
		}
		//
		function checkLoadMap(evt:Boolean):void {
			//make list load call
			if(evt){
				savedList.loadFile(MapList);
			}
		}
		//
		function loadResult(evt:*):void {
			if(evt !== false){
				clearMap();
				savedMap.loadFile(evt[2]);
				trace('map Loaded @: '+evt[2]);
			}else{
				trace('map load canceled');
			}
		}
		
		//**************************************************************************//
		//Settings Buttons
		//**************************************************************************//
		function mapBtnHandler(mevt:MouseEvent):void {
			addChild(new DialogMapSettings("Map Properties", mapPropertiesHandler,mapBG,mapTexture,mapTileSize,mapDisplayScale));
		}
		//
		function tileBtnHandler(mevt:MouseEvent):void{
			addChild(new DialogBrushTexture("Brush Textures", TileOKFUnc));
		}
		//
		function TileOKFUnc(evt:*):void{
			trace("OK: "+evt);
		}
		//
		//the function called by imageList.loadFile(TextureList);
		//opens the image select with callback
		function backgroundImageList(evt:Event):void {
			var imageList = TextParser.textToArray(evt.target.data);
			var colList = new Array(["0","Image"],["1","Date"]);
			addChild(new DialogSelect("Choose BGImage",imageList, bgSelectResult,colList));
		}
		//
		//opens the image select with callback
		function textureImageList(evt:Event):void {
			var imageList = TextParser.textToArray(evt.target.data);
			var colList = new Array(["0","Image"],["1","Date"]);
			addChild(new DialogSelect("Choose Texture Map",imageList, texSelectResult,colList));
		}
		//
		function mapPropertiesHandler(evt:*):void {
			if(evt){
				switch (evt.name){
					case "bgChange_btn":
						backgroundList.loadFile(BackgroundList);
						break;
					case "textureChange_btn":
						textureList.loadFile(TextureList);
						break;
					case "tileSize_ns":
						mapTileSize = evt.value;
						trace(mapTileSize);
						break;
					case "bitScale_ns":
						mapDisplayScale = evt.value;
						trace(evt.value);
						break;
				}
			}
			trace(mapTileSize);
		}
		//
		function bgSelectResult(evt:*):void {
			if(evt){
				mapBG = evt[0];
				trace('swapped images');
			}else{
				trace('didn\'t swapped images');
			}
			addChild(new DialogMapSettings("Map Properties", mapPropertiesHandler,mapBG,mapTexture,mapTileSize,mapDisplayScale));
		}
		//
		function texSelectResult(evt:*):void {
			if(evt){
				mapTexture = evt[0];
				trace('swapped images');
			}else{
				trace('didn\'t swapped images');
			}
			addChild(new DialogMapSettings("Map Properties", mapPropertiesHandler,mapBG,mapTexture,mapTileSize,mapDisplayScale));
		}
		//
		function imageUploadResult(evt:*):void {
			if(evt !== false){
				trace(evt);
				trace('uploaded images');
			}else{
				trace('didn\'t uploaded images');
			}
			addChild(new DialogMapSettings("Map Properties", mapPropertiesHandler,mapBG,mapTexture,mapTileSize,mapDisplayScale));
		}
	}
}
