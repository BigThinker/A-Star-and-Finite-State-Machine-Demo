package  
{
	import flash.filters.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Class containing properties to 'edit' the project (functionality wise and visually).
	 * 
	 * @author Aldo
	 */
	public class Editor 
	{
		// =================================================================================================
		// FUNCTIONAL
		// =================================================================================================
		
		/** Flag to test automated AI with state machines (+shortest path) or shortest path algorithm only. */
		public static var USE_FSM:Boolean = true;
		
		/** Maximum number of connections that a <code>Node</code> can have. */
		public static const MAX_CONNECTIONS:uint = 2;
		
		// States threshold values (divide by 30, which is framerate, to know how long it lasts in seconds to hit threshold.
		public static var HUNGER_THRESHOLD:int = 135;
		public static var THIRST_THRESHOLD:int = 45;
		public static var SLEEPINESS_THRESHOLD:int = 222;
		// if low, agent gets bored fast! Boredom threshold always changes between the values below, after agent enters that state.
		public static var BORED_RANGE:Point = new Point(260, 300); 
		public static const AGENT_SPEED:Number = 0.1; // the higher the value, the faster the agent is.
		public static const THRESHOLD_RANGE:Point = new Point(20, 2000); // limit the values provided for thresholds.
		public static const PREVENT_FSM_FRAMES:int = 70;
		
		// =================================================================================================
		// VISUAL
		// =================================================================================================
		
		// Constants for the textfields.
		public static const TEXT_COLOR:uint = 0x0;
		public static const FONT_NAME:String = "Arial";
		public static const CURRENT_STATE_TEXT_SIZE:uint = 20;
		public static const CURRENT_STATE_TEXT_POSITION:Point = new Point(5, 5);
		public static const STATE_VALUES_TEXT_SIZE:uint = 8;
		public static const STATE_VALUES_TEXT_POSITION:Point = new Point(5, 25);
		public static const NODE_LABEL_TEXT_SIZE:uint = 12;
		public static const NODE_LABEL_OFFSET:Point = new Point(0, -33);
		public static const NODE_UNKNOWN_ALPHA:Number = 0.7;
		
		/** Effect to use for selected node. (Can be any filter from flash.filters.* package)*/
		public static const SELECT_NODE_EFFECT:BevelFilter = new BevelFilter(4, 45, 0xFF0000);
		/** Effect to use for selected node. (Can be any filter from flash.filters.* package)*/
		public static const DESELECT_NODE_EFFECT:BevelFilter = new BevelFilter();
		
		public static const NODE_COLOR:uint = 0x0;
		public static const NODE_RADIUS:uint = 15;
		public static const AGENT_COLOR:uint = 0x0;
		public static const AGENT_RADIUS:uint = 20;
		
		public static const CONNECTION_COLOR:uint = 0xFF0000;
		
		// =================================================================================================
		// VISUAL - USER INTERFACE
		// =================================================================================================
		
		/** Transparency of the interactive User Interface on top of the program. */
		public static const UI_ALPHA:Number = 0.7;
		public static const UI_OFFSET:Point = new Point(5, 5);
		public static const UI_LINE_POS:Point = new Point(0, 15);
		public static const UI_LINE_WIDTH:Number = 90;
		public static const UI_LINE_COLOR:uint = 0x0;
		public static const UI_STATIC_TEXTS_OFFSET:Point = new Point(0, 15);
		public static const UI_STATIC_TEXT_SIZE:int = 8;
		public static const UI_STATE_TEXT_SIZE:int = 15;
		public static const UI_STATE_OFFSET:Point = new Point(105, 10);
		public static const UI_INPUT_WIDTH:Number = 90;
		public static const UI_HALF_INPUT_DISTANCE:Number = 5;
		public static const UI_INPUT_DELTA_Y:Number = 35;
		public static const UI_STATE_VALUES_PROPS:Rectangle = new Rectangle(105, 90, 120, 65);
		public static const UI_CURRENT_STATE_OFFSET:Point = new Point(105, 20);
		public static const UI_CURRENT_STATE_TEXT_SIZE:int = 40;
	}

}