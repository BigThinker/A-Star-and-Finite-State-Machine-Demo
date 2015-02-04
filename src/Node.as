package  
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * Node class represents a Node in the scene.
	 * It has properties to be edited by Shortest Path algorithm. 
	 * It has connection array containing other nodes that it is connected to, 
	 * and it also has a label that displays the name and type of the node.
	 * 
	 * @author Aldo
	 */
	public class Node extends Sprite
	{
		// variables used for shortest path algorithm calculation.
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var parentNode:Node;
		public var traversable:Boolean = true;
		
		// array to save all connections (other nodes) that the node has.
		private var mConnections:Array;
		private var mType:String;
		private var mLabel:TextField;
		
		/** Create a new <code>Node</code> at the position (<code>x</code>, <code>y</code>). */
		public function Node(name:String, x:Number, y:Number) 
		{
			// set position.
			this.x = x;
			this.y = y;
			this.alpha = Editor.NODE_UNKNOWN_ALPHA;
			
			// set name.
			this.name = name;
			
			createGraphic();
			setRandomType();
			createLabel();
			
			// initialize connections array.
			mConnections = [];
		}
		
		// create a simple circle representing the node.
		private function createGraphic():void 
		{
			graphics.beginFill(Editor.NODE_COLOR);
			graphics.drawCircle(0, 0, Editor.NODE_RADIUS);
			graphics.endFill();
		}
		
		private function setRandomType():void
		{
			// set random type.
			mType = Constants.NODE_TYPES[Misc.betweenInt(0, Constants.NODE_TYPES.length - 1)];
		}
		
		private function createLabel():void
		{
			// attach a label to the Node in order to show the name and the type of the node.
			mLabel = new TextField();
			mLabel.defaultTextFormat = new TextFormat(Editor.FONT_NAME, Editor.NODE_LABEL_TEXT_SIZE, Editor.TEXT_COLOR);
			mLabel.text = name + " " + mType;
			mLabel.selectable = false;
			mLabel.x = x - width + Editor.NODE_LABEL_OFFSET.x;
			mLabel.y = y + Editor.NODE_LABEL_OFFSET.y;
		}
		
		/** Use function to add a new connection to the node. */
		public function addConection(otherNode:Node, gfx:Graphics):void
		{
			// check if the node already has this connection.
			if (!hasConnection(otherNode))
			{
				// if not, push it to the connections array.
				mConnections.push(otherNode);
				
				// also save the same reference to the other node.
				otherNode.addConection(this, gfx);
				
				// draw a line between them, representing the connection.
				gfx.lineStyle(1, Editor.CONNECTION_COLOR);
				gfx.moveTo(x, y);
				gfx.lineTo(otherNode.x, otherNode.y);
				gfx.endFill();
			}
		}
		
		/** 
		 * Use this function to see whether the node is connected to another node.
		 * Returns true if they are connected.
		 */
		public function hasConnection(otherNode:Node):Boolean
		{
			return mConnections.indexOf(otherNode) != -1;
		}
		
		/** Use this function to get the type of this node. */
		public function get type():String
		{
			return mType;
		}
		
		/** Function used by the Pathfinder to do calculations. */
		public function get connections():Array
		{
			return mConnections;
		}
		
		/** Use to grab a reference of the label. */
		public function get label():TextField
		{
			return mLabel;
		}
	}

}