package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * Code for agent to control different states (sleep, hunger, thirst and boredom) and go to the appropriate node.
	 * Use <code>goTo(node)</code> to send agent to the nearest node. It will use Shortest Path algorithm by default.
	 * 
	 * @author Aldo
	 */
	public class Agent extends Sprite
	{
		// a reference of all the nodes.
		private var mNodes:Vector.<Node>;
		private var mRoute:Array;
		
		// the nodes that the agent "knows".
		private var mSafeNodes:Vector.<Node>;
		private var mWaterNodes:Vector.<Node>;
		private var mFoodNodes:Vector.<Node>;
		
		// the nodes that the agent "doesn't know".
		private var mUnknownNodes:Vector.<Node>;
		
		// values of the states.
		private var mHunger:int;
		private var mThirst:int;
		private var mSleepiness:int;
		private var mBoredom:int;
		private var mBoredomThreshold:int;
		private var mPreventFSM:int;
		
		// variables used for moving the agent in different nodes.
		private var mInc:Number;
		private var mCurrentNode:Node;
		private var mNextNode:Node;
		private var mCurrentNodePos:Point;
		private var mNextNodePos:Point;
		
		// current state reference.
		private var mCurrentState:String;
		
		/** Create a new agent and save a reference of all the nodes. */
		public function Agent(nodes:Vector.<Node>) 
		{
			// set a reference to the nodes.
			mNodes = nodes;
			
			createGraphic();
			setVariables();
		}
		
		// create a simple circle representing the agent.
		private function createGraphic():void
		{
			graphics.lineStyle(1, Editor.AGENT_COLOR);
			graphics.drawCircle(0, 0, Editor.AGENT_RADIUS);
			graphics.endFill();
		}
		
		// initialize variables.
		private function setVariables():void
		{
			mHunger = 0;
			mThirst = 0;
			mSleepiness = 0;
			mBoredom = 0;
			mInc = 1;
			mPreventFSM = 0;
			mCurrentNodePos = new Point();
			mNextNodePos = new Point();
			mRoute = [];
			
			// initialize all node lists.
			mSafeNodes = new Vector.<Node>();
			mWaterNodes = new Vector.<Node>();
			mFoodNodes = new Vector.<Node>();
			mUnknownNodes = new Vector.<Node>();
			
			calculateBoredomThreshold();
			
			// set unknown nodes to a copy of all the nodes, since in the beginning agent doesn't know any node.
			mUnknownNodes = mNodes.concat();
		}
		
		// calculate boredom threshold (between the values provided in the Editor.as).
		public function calculateBoredomThreshold():void
		{
			mBoredomThreshold = Misc.betweenInt(Editor.BORED_RANGE.x, Editor.BORED_RANGE.y);
		}
		
		/** Use this function to set the agent at a specific node. */
		public function setToNode(node:Node):void
		{
			// reposition precisely.
			x = node.x;
			y = node.y;
			
			// update the current node.
			mCurrentNode = node;
			
			// was this node unknown?
			if (!isNodeKnown(mCurrentNode))
			{
				// we know a new node.
				makeNodeKnown(mCurrentNode);
				UserInterface.getInstance().say("Awesome! Now I know a new node.");
				
				// select appropriate array to push the node based on its type.
				switch (mCurrentNode.type)
				{
					case Constants.FOOD:
						
						mFoodNodes.push(mCurrentNode);
						
						break;
						
					case Constants.SAFE:
						
						mSafeNodes.push(mCurrentNode);
						
						break;
						
					case Constants.WATER:
						
						mWaterNodes.push(mCurrentNode);
						
						break;
				}
			}
		}
		
		public function update():void
		{
			// agent is moving to a node.
			if (mNextNode)
			{
				updatePos();
			
				mInc -= Editor.AGENT_SPEED;
				if (mInc <= 0)
				{
					mInc = 1;
					
					setToNode(mNextNode);
					nextNode();
				}
			}
			// agent is staying in a node.
			else if (Editor.USE_FSM)
			{
				applyFSM();
			}
		}
		
		// function representing the finite state machine functionality.
		private function applyFSM():void 
		{
			// restrict for a while so that the user can see what's going on.
			if (mPreventFSM > 0) { mPreventFSM--; return; }
			
			// save a reference of the current state as it is.
			var prevState:String = mCurrentState;
			
			// increment all state values.
			incrementStateValues();
			
			// display the change of each state value.
			UserInterface.getInstance().UpdateStatesValuesText(mHunger, mThirst, mSleepiness, mBoredom, mBoredomThreshold);
			
			// select a new state, if needed.
			selectNewState(prevState);
			
			// if it is the same state return, otherwise continue.
			if (prevState == mCurrentState) return;
			
			// display the change of current state.
			UserInterface.getInstance().UpdateCurrentStateText(mCurrentState);
			
			// =================================================================================================
			// STATE CHANGED. TAKE ACTION.
			// =================================================================================================
			changeNode();
		}
		
		private function incrementStateValues():void
		{
			// increase hunger, thirst, sleepiness and boredom.
			mHunger++;
			mThirst++;
			mSleepiness++;
			mBoredom++;
		}
		
		private function selectNewState(prevState:String):void
		{
			if (mHunger >= Editor.HUNGER_THRESHOLD && prevState != Constants.HUNGER)
				mCurrentState = Constants.HUNGER;
			
			if (mThirst >= Editor.THIRST_THRESHOLD && prevState != Constants.THIRST)
				mCurrentState = Constants.THIRST;
			 
			if (mSleepiness >= Editor.SLEEPINESS_THRESHOLD && prevState != Constants.SLEEP)
				mCurrentState = Constants.SLEEP;
			 
			if (mBoredom >= mBoredomThreshold && prevState != Constants.BOREDOM)
				mCurrentState = Constants.BOREDOM;
		}
		
		private function changeNode():void
		{
			switch (mCurrentState)
			{
				case Constants.HUNGER:
					
					// if I don't know any food node, I'm going to explore.
					if (!goToFoodNode()) 
						explore();
					
					break;
				
				case Constants.THIRST:
					
					// if I don't know any water node, I'm going to explore.
					if (!goToWaterNode()) 
						explore();
						
					break;
					
				case Constants.SLEEP:
					
					// if I don't know any safe node, I'm going to explore.
					if (!goToSafeNode())
						explore();
					
					break;
					
				case Constants.BOREDOM:
					
					// just explore any unknown (or known if there are no more unknown) node.
					explore();
					
					break;
			}
			
			mPreventFSM = Editor.PREVENT_FSM_FRAMES;
		}
		
		// returns true if it was successful.
		private function goToFoodNode():Boolean
		{
			// reset hunger.
			mHunger = 0;
			
			// I don't know any food node.
			if (mFoodNodes.length == 0) 
				return false;
				
			UserInterface.getInstance().say("Going to a food node.");
			
			goTo(mFoodNodes[Misc.betweenInt(0, mFoodNodes.length - 1)]);
			
			return true;
		}
		
		// returns true if it was successful.
		private function goToWaterNode():Boolean
		{
			// reset thirst.
			mThirst = 0;
			
			// I don't know any food node.
			if (mWaterNodes.length == 0) 
				return false;
			
			UserInterface.getInstance().say("Going to a water node.");
				
			
			goTo(mWaterNodes[Misc.betweenInt(0, mWaterNodes.length - 1)]);
			
			return true;
		}
		
		// returns true if it was successful.
		private function goToSafeNode():Boolean
		{
			// reset sleepiness.
			mSleepiness = 0;
			
			// I don't know any safe node.
			if (mSafeNodes.length == 0) 
				return false;
			
			UserInterface.getInstance().say("Going to a safe node.");
				
			goTo(mSafeNodes[Misc.betweenInt(0, mSafeNodes.length - 1)]);
			
			return true;
		}
		
		private function explore():void
		{
			// reset boredom.
			mBoredom = 0;
			
			// calculate a new threshold for more 'real' state control.
			calculateBoredomThreshold();
			
			// I know all the nodes so I will just go to a known node.
			if (mUnknownNodes.length == 0) {
				
				goToKnownNode();
				return;
			}
			
			UserInterface.getInstance().say("Going to explore.");
				
			
			goTo(mUnknownNodes[Misc.betweenInt(0, mUnknownNodes.length - 1)]);
		}
		
		// assuming one type of known node certainly exists.
		private function goToKnownNode():Boolean
		{
			// save 1 random food, water and safe node (3 in total).
			var nodesThatExist:Vector.<Node> = new Vector.<Node>;
			
			if (mFoodNodes.length > 0) {
				nodesThatExist.push(mFoodNodes[Misc.betweenInt(0, mFoodNodes.length - 1)]);
			}
			else if (mWaterNodes.length > 0) {
				nodesThatExist.push(mWaterNodes[Misc.betweenInt(0, mWaterNodes.length - 1)]);
			}
			else if (mSafeNodes.length > 0) {
				nodesThatExist.push(mSafeNodes[Misc.betweenInt(0, mSafeNodes.length - 1)]);
			}
			
			if (nodesThatExist.length == 0) 
				return false;
				
			// we got at least a node.
			// so pick one of them randomly!!!
			var chanceOfEach:Number = 1 / nodesThatExist.length;
			
			// generate a random number 0..1.
			var equalChance:Number = Math.random();
			
			// what is the index of the node that correlates to the random number?
			var winningNodeIndex:int = int (Math.floor(equalChance / chanceOfEach));
			
			UserInterface.getInstance().say("Not much to explore, just going to a node I know.");
			
			// go to that node.
			goTo(nodesThatExist[winningNodeIndex]);
			
			return true;
		}
		
		private function updatePos():void 
		{
			mCurrentNodePos.x = mCurrentNode.x;
			mCurrentNodePos.y = mCurrentNode.y;
			
			mNextNodePos.x = mNextNode.x;
			mNextNodePos.y = mNextNode.y;
			
			var newPos:Point = Misc.lerp(mCurrentNodePos, mNextNodePos, mInc);
			x = newPos.x;
			y = newPos.y;
		}
		
		public function goTo(node:Node):void
		{
			// not while we are moving.
			if (mRoute && mRoute.length > 0) return;
			
			// brute-force, find the best path to the destination node.
			mRoute = Pathfinder.findPath(mCurrentNode, node);
			
			if (mRoute && mRoute.length > 0) nextNode();
		}
		
		private function nextNode():void 
		{
			// shift the first node from all nodes in the route.
			mNextNode = mRoute.shift();
		}
		
		/** Returns true if Node is known. */
		private function isNodeKnown(node:Node):Boolean
		{
			return mUnknownNodes.indexOf(node) == -1;
		}
		
		/** Use to remove node from unknown nodes list. */
		private function makeNodeKnown(node:Node):void
		{
			node.alpha = 1;
			mUnknownNodes.splice(mUnknownNodes.indexOf(node), 1);
		}
		
		/** Use to get the boredom threshold. */
		public function get boredomThreshold():int 
		{
			return mBoredomThreshold;
		}
		
	}

}