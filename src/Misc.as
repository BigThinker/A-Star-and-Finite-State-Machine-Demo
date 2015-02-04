package  
{
	import flash.geom.Point;
	import flash.text.*;
	import flash.utils.ByteArray;
	
	/**
	 * Static helper methods.
	 * 
	 * @author Aldo
	 */
	public class Misc 
	{
		/** Use to get an XML object from embedded XML file (via Class type) */
		public static function getXML(file:Class):XML
		{
			var bytes:ByteArray = new file;
			return XML(bytes.readUTFBytes(bytes.length));
		}
		
		/** Block collision. Do these rectangles intersect ? */
		public static function rectOverlap(x1:Number, y1:Number, w1:Number, h1:Number,
								x2:Number, y2:Number, w2:Number, h2:Number):Boolean
		{
			return  x1 < x2 + w2 &&
					x1 + w1 > x2 &&
					y1 < y2 + h2 &&
					y1 + h1 > y2;
		}
		
		/** Returns a random number between two values. */
		public static function between(min:Number, max:Number):Number
		{
			return Math.random() * (max - min) + min;
		}
		
		/** Returns a random int between and including two values. */
		public static function betweenInt(min:int, max:int):int
		{
			return int(Math.random() * (max - min + 1)) + min;
		}
		
		/** Test whether the value is in the range of a minimum and a maximum value. */
		public static function inRange(val:Number, min:Number, max:Number):Boolean
		{
			return val >= min && val <= max;
		}
		
		/** Test if point intersects iwth a rectangle. */
		public static function ptInRect(px:Number, py:Number, 
									rx:Number, ry:Number, rw:Number, rh:Number):Boolean
		{
			return px > rx &&
				   px < rx + rw &&
				   py > ry &&
				   py < ry + rh;
		}
		
		/** Shortcut to create a TextField in a line. */
		public static function text(x:Number = 0, y:Number = 0, 
										text:String = "", 
										size:int = 40, 
										embed:Boolean = true):TextField
		{
			var tf:TextField = new TextField;
			var tformat:TextFormat = new TextFormat("default", size, 0x0);
			
			if (embed) tf.embedFonts = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			tf.defaultTextFormat = tformat;
			
			tf.x = x;
			tf.y = y;
			tf.text = text;
			
			return tf;
		}
		
		/** Returns -1 if number is negative, 1 if number is positive, or 0. */
		public static function sign(value:Number):int
		{
			return value < 0 ? -1 : (value > 0 ? 1 : 0);
		}
		
		/** Use function to linearlly interpolate between 2 points with f. */
		public static function lerp(pt1:Point, pt2:Point, f:Number):Point
		{
			 var x:Number = f * pt1.x + (1 - f) * pt2.x;
			 var y:Number = f * pt1.y + (1 - f) * pt2.y;

			 return new Point(x, y);
		}
	}

}