// with help from http://actions3.ucoz.ru/_ld/0/4_Keith_Peters-Ad.pdf pg. 155+
// and http://www.untoldentertainment.com/blog/2010/08/20/introduction-to-a-a-star-pathfinding-in-actionscript-3-as3-2/

package
{
	/**
	 * Static class used to calculate shortest path (if there's any), given a node system (via connections), 
	 * a source node and a destination node.
	 * 
	 * @author Aldo
	 */
	public class Pathfinder 
	{
		// variable pointing to a function used as heuristic for estimating the cost from current node to destination node.
		public static var heuristic:Function = Pathfinder.diagonalHeuristic;
		
		public static function isOpen(node:Node, list:Array):Boolean {
			return (list.indexOf(node) >= 0);
		}
		
		public static function isClosed(node:Node, list:Array):Boolean {
			return (list.indexOf(node) >= 0);
		}
		
		public static function findPath(firstNode:Node, destinationNode:Node):Array 	
		{
			var openNodes:Array = []; // all visited nodes with cost.
			var closedNodes:Array = []; // nodes whose neighbors have been visited.
			var currentNode:Node = firstNode;
			var testNode:Node;
			var connectedNodes:Array;
			var travelCost:Number = 1.0;
			var g:Number; // cost from first to this node.
			var h:Number; // cost from this node to final node.
			var f:Number; // total cost of node
			currentNode.g = 0;
			currentNode.h = Pathfinder.heuristic(currentNode, destinationNode, travelCost);
			currentNode.f = currentNode.g + currentNode.h;
			var l:int;
			var i:int;
			
			while (currentNode != destinationNode) 
			{
				connectedNodes = currentNode.connections;
				
				l = connectedNodes.length;
				
				for (i = 0; i < l; ++i) 
				{
					testNode = connectedNodes[i];
					
					// if it's testing with itsself or if the node cannot be traversed, skip the rest of the code.
					if (testNode == currentNode || testNode.traversable == false) continue;
					
					// calculate g for variable distances (use heuristic here too).
					g = currentNode.g + heuristic( currentNode, testNode, travelCost);
					// calculate an estimated cost from this node to destination.
					h = heuristic(testNode, destinationNode, travelCost);
					// add them together.
					f = g + h;
					
					if ( Pathfinder.isOpen(testNode, openNodes) || Pathfinder.isClosed( testNode, closedNodes) )
					{
						if(testNode.f > f)
						{
							testNode.f = f;
							testNode.g = g;
							testNode.h = h;
							testNode.parentNode = currentNode;
						}
					}
					else 
					{
						testNode.f = f;
						testNode.g = g;
						testNode.h = h;
						testNode.parentNode = currentNode;
						openNodes.push(testNode);
					}
				}
				
				closedNodes.push( currentNode );
				if (openNodes.length == 0) {
					return null;
				}
				
				// sort the nodes on f cost. 
				openNodes.sortOn('f', Array.NUMERIC);
				
				currentNode = openNodes.shift() as Node;
			}
			
			return Pathfinder.buildPath(destinationNode, firstNode);
		}
		
		public static function buildPath(destinationNode:Node, startNode:Node):Array 
		{
			var path:Array = [];
			var node:Node = destinationNode;
			path.push(node);
			
			while (node != startNode) 
			{
				node = node.parentNode;
				path.unshift( node );
			}
			
			return path;
		}
		
		public static function manhattan(node:Node, destinationNode:Node, cost:Number =  1):Number
		{
			return Math.abs(node.x - destinationNode.x) * cost + Math.abs(node.y + destinationNode.y) * cost;
		}
		
		public static function euclidianHeuristic(node:Node, destinationNode:Node, cost:Number = 1):Number
		{
			var dx:Number = node.x - destinationNode.x;
			var dy:Number = node.y - destinationNode.y;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public static function diagonalHeuristic(node:Node, destinationNode:Node, cost:Number = 1.0, diagonalCost:Number = 1.0):Number 
		{
			var dx:Number = Math.abs(node.x - destinationNode.x);
			var dy:Number = Math.abs(node.y - destinationNode.y);
			var diag:Number = Math.min( dx, dy );
			var straight:Number = dx + dy;
			
			return diagonalCost * diag + cost * (straight - 2 * diag);
		}
	}

}