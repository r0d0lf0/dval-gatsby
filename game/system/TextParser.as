//basically a text to flash array
//takes [0,1,2][0,1,2][0,1,2] and returns native new Array((0,1,2),(0,1,2),(0,1,2))
//limitations: none yet
// 
package system{
	public class TextParser {
		
		public static var openBrkt:int = 0;
		public static var closeBrkt:int = 0;
		public static var startPropArray:int = 0;
		public static var endPropArray:int = 0;
		public static var objList:Array = new Array();
		public static var loop:Boolean = true;
		
		//recursive function for turning .txt file to flash object
		public static function textToArray(txtData:String):Array {
			if(!loop){
				resetPointer();
				loop = true;
			}
			// if data string has an "[" after a "]" ...
			// so, if  "]"=0 we still have "[" after the first nothing
			if (txtData.indexOf("[", closeBrkt) != -1) {
				// start with that opening bracket
				openBrkt = txtData.indexOf("[", closeBrkt);
				// find the closing bracket
				closeBrkt = txtData.indexOf("]", openBrkt);
				// push group "[0,1,2]" to array as one item
				objList.push(txtData.substring(openBrkt, closeBrkt+1));
				// call until end of string params "[" and "]"
				textToArray(txtData);
				// if we're done making the array...
			} else {
				for (var q=0; q<objList.length; q++) {
					// remove "[" and "]" for each item
					startPropArray = objList[q].indexOf("[")+1;
					endPropArray = objList[q].indexOf("]");
					objList[q] = objList[q].substring(startPropArray, endPropArray);
					// turn the group into its own array
					objList[q] = objList[q].split(",");
				}
			}
			// return data as multi-dimensional array object
			loop = false;
			return objList;
		}
		
		private static function resetPointer():void{
			openBrkt = 0;
			closeBrkt = 0;
			startPropArray = 0;
			endPropArray = 0;
			objList = new Array();
		}
	}
}