package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	
	/**
	 * Scene Class represents the core of this project.
	 * It is responsible to create / update the agent and the nodes.
	 * 
	 * It is a Singleton to prevent creating more than one instance.
	 * 
	 * @author Aldo
	 */
	public class Scene extends Sprite
	{
		// static instance used to force this class to be a singleton (see getInstance() function).
		private static var mInstance:Scene;
		
		/** Use this function to get a reference of the Scene. */
		public static function getInstance():Scene {
			
			if (!mInstance) {
				new Scene();
			}
			
			return mInstance;
		}
		
		// vector to hold all nodes.
		private var mNodes:Vector.<Node>;
		// instance of the agent.
		private var mAgent:Agent;
		 
		public function Scene() 
		{
			if (mInstance) {
				throw new Error(Constants.SINGLETON_ERROR_MESSAGE);
			}
			
			mInstance = this;
			init();
		}
		
		// initialize method, used to initialize all variables and setup functionality.
		private function init():void
		{
			addNodes();
			addConnections();
			addAgent();
			
			// put agent to a random node in the start.
			mAgent.setToNode(mNodes[Misc.betweenInt(0, mNodes.length - 1)]);
			
			// setup loop to run each frame.
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function addNodes():void 
		{
			// initialize the vector.
			mNodes = new Vector.<Node>();
			// initialize the node xml file created in Ogmo Editor.
			var nodesXml:XML = XML(new Constants.NODES_XML)
			// used for iteration.
			var node:XML;
			
			// start at 1 -> used for the name of the node.
			var n:int = 1;
			// go through each Node element in the xml.
			for each(node in nodesXml.Nodes.Node)
			{
				addNode(node.@x, node.@y, n++);
			}
		}
		
		private function addNode(x:Number, y:Number, name:int):Node 
		{
			var nodeName:String = "N" + name.toString();
			var node:Node = new Node(nodeName, x, y);

			// add it to the display (render) list.
			addChild(node);
			// also, add its label on this display list.
			addChild(node.label);
			// disable mouse input.
			// it blocks the node because the hitbox is big. (had to bounce my head against this bug for a while)
			node.label.mouseEnabled = false;
			
			mNodes.push(node);
			
			node.addEventListener(MouseEvent.CLICK, selectNode);
			
			return node;
		}
		
		private function addConnections():void
		{
			const num_nodes:int = mNodes.length - 1;
			
			for (var i:int = 0; i < num_nodes; i++)
			{
				// create between 1 and Node.MAX_CONNECTIONS connections.
				const num_connections:int = Misc.betweenInt(1, Editor.MAX_CONNECTIONS);
				
				for (var j:int = 0; j < num_connections; j++)
				{
					// index of a random node to select from all nodes.
					var randNodeIndex:int;
					
					do 
					{ 
						randNodeIndex = Misc.betweenInt(0, num_nodes); 
					}
					while (randNodeIndex == i)
					
					// add a connection between the current node [i] and a random node [randNodeIndex].
					mNodes[i].addConection(mNodes[randNodeIndex], graphics);
				}
			}
		}
		
		private function addAgent():void
		{
			mAgent = new Agent(mNodes);
			addChild(mAgent);
		}
		
		// game loop.
		private function update(e:Event):void
		{
			// update agent.
			mAgent.update();
		}
		
		// function triggered when user selects a node (click with Mouse) (FSM should be off).
		private function selectNode(e:MouseEvent):void
		{
			if (Editor.USE_FSM)
				return;
			
			// grab the selected node (e.target).
			var selectedNode:Node = Node(e.target);
			// used for iteration.
			var node:Node;
			
			for each(node in mNodes)
			{
				// set filters (effects) to just a glow filter indicating
				node.filters = [Editor.DESELECT_NODE_EFFECT];
			}
			
			// make the selected node popup with a red glow effect.
			selectedNode.filters = [Editor.SELECT_NODE_EFFECT];
			
			mAgent.goTo(selectedNode);
		}
		
		/** Function used to update nodes appearance based on whether FSM / Automatic is being used or not. */
		public function updateNodesAppearance():void
		{
			// used for iteration.
			var node:Node;
			
			for each(node in mNodes)
			{
				if (Editor.USE_FSM) {
					// clear filters.
					node.filters = [];
				}
				else {
					// set the deselect effect.
					node.filters = [Editor.DESELECT_NODE_EFFECT];
				}
			}
		}
		
		// get a reference to one agent.
		public function getAgent():Agent
		{
			return mAgent;
		}
		
	}

}