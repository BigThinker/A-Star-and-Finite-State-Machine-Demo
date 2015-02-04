package  
{
	/**
	 * Non editable parts of the project.
	 * 
	 * @author Aldo
	 */
	public class Constants 
	{		
		public static const FOOD:String = "food";
		public static const WATER:String = "water";
		public static const SAFE:String = "safe";
		public static const NODE_TYPES:Array = [FOOD, WATER, SAFE];
		
		// Agent states.
		public static const HUNGER:String = "Hunger";
		public static const THIRST:String = "Thirst";
		public static const SLEEP:String = "Sleep";
		public static const BOREDOM:String = "Boredom";
		
		// embed the level file (created in Ogmo Editor) in the executable swf.
		[Embed(source = "nodes.oel", mimeType = "application/octet-stream")]
		public static const NODES_XML:Class;
		// embed font.
		[Embed(source = "assets/pf_ronda_seven.ttf", embedAsCFF="false", fontFamily = 'default')]
		public static const RONDA_TFF:Class;
		
		// Singleton class error message.
		public static const SINGLETON_ERROR_MESSAGE:String = "Cannot initialize class via constructor. Use getInstance() method instead.";
		
		public static const UI_AUTOMATIC_TEXT:String = "Automatic (FSM)";
		public static const UI_MANUAL_TEXT:String = "Manual (Click Node)";
		public static const UI_STATIC_TEXTS:Object = { hungerThreshold:"Hunger Threshold", thirstThreshold:"Thirst Threshold", 
														sleepThreshold:"Sleep Threshold", boredomThreshold:"Boredom (Min, Max)" };
		public static const UI_STATE:String = "State";
		public static const UI_AGENT_START_STATE:String = "Idle";
	}

}