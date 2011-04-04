package org.flixel
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import org.flixel.*;
	/**
	 * ...
	 * @author Vexhel
	 * (revamped by Ace20!)
	 */
	public class FlxPathfinding
	{
		private static const COST_ORTHOGONAL:int = 1000;
		private static const COST_DIAGONAL:int = 1413;
		
		private static var open:Vector.<FlxPathfindingNode> = new Vector.<FlxPathfindingNode>();
		private static var closed:Vector.<FlxPathfindingNode> = new Vector.<FlxPathfindingNode>();
		private var _map:FlxTilemap;
		private var _nodes:Vector.<FlxPathfindingNode>;
		
		// misc helpful vars
		protected static var _allowDiag:Boolean;
		protected static var _acceptClosestBroken:Boolean;
		protected static var _maxLength:uint;
		protected static var _maxCost:uint;
		protected static var _startPoint:Point;
		
		
		
		public function FlxPathfinding(tilemap:FlxTilemap)
		{
			buildNodeGraph(tilemap);
		}
		
		
		
		/**
		 * Refreshes the node graph for this FlxPathfinding instance to match the map
		 * data for a tilemap.
		 */ 
		public function buildNodeGraph(tilemap:FlxTilemap):void
		{
			_map = tilemap;
			
			// Initialize the node structure.
			if (tilemap == null) _nodes = null;
			else
			{
				_nodes = new Vector.<FlxPathfindingNode>(tilemap.totalTiles, true);
			
				for (var i:int = 0; i < tilemap.totalTiles; i++)
					_nodes[i] = new FlxPathfindingNode(i % _map.widthInTiles, int(i / _map.widthInTiles), (_map.getTileByIndex(i) < _map.collideIndex));
			}
		}
		
		
		
		public function reset():void
		{
			for (var i:int = 0; i < _nodes.length; i++)
				_nodes[i].reset();
			
			open.length = 0;
			closed.length = 0;
		}
		
		
		/**
		 * Given a start and end point, returns an array of points representing the shortest path (if any) between them.
		 * @param	startPoint					The point you want to start on.
		 * @param	endPoint					The point you want to end at.
		 * @param	maxLength					The maximum allowed number of points in this path.
		 * @param	allowDiagonalMovement		Whether or not diagonal movement is allowed.
		 * @param	ignoreWalls					Whether or not the path can cross collideable tiles.
		 * @param	acceptClosestBroken			If true, it will return the best guess in the case that no path can be found.
		 */ 
		public function findPath(startPoint:Point, endPoint:Point, maxLength:uint = 0, allowDiagonalMovement:Boolean = false, ignoreWalls:Boolean = false, acceptClosestBroken:Boolean = false):Vector.<Point>
		{
			var maxCost:uint = 0; // this will eventually be a param for the function!
			
			// Make sure the start and end points are different.
			if (_nodes == null || (startPoint.x == endPoint.x && startPoint.y == endPoint.y)) return null;
			
			_allowDiag = allowDiagonalMovement;
			_acceptClosestBroken = acceptClosestBroken;
			_maxLength = maxLength;
			_maxCost = maxCost;
			_startPoint = startPoint;
			//tileSize = (_map.width / _map.widthInTiles);
			
			// Quick check just to make sure fastest path ignoring walls is reachable in less than maxPathLength moves.
			if (!acceptClosestBroken && maxLength != 0)
			{
				if ((allowDiagonalMovement && (Math.max(Math.abs(endPoint.x - startPoint.x), Math.abs(endPoint.y - startPoint.y)) > maxLength))
					|| (Math.abs(endPoint.x - startPoint.x) + Math.abs(endPoint.y - startPoint.y) > maxLength)) return null;
					
				// Some kind of check for cost as well? move the ignoreWalls stuff up?
			}
			
			// The Vector that holds the final path to be returned.
			var path:Vector.<Point>;
			
			// If we ignore walls, then just return the direct path to the end!
			if (ignoreWalls)
			{
				path = new Vector.<Point>();
				var curPoint:Point = new Point(startPoint.x, startPoint.y);
				
				while (curPoint.x != endPoint.x || curPoint.y != endPoint.y)
				{
					if (allowDiagonalMovement)
					{
						if (curPoint.x < endPoint.x) curPoint.x++;
						else if (curPoint.x > endPoint.x) curPoint.x--;
						if (curPoint.y < endPoint.y) curPoint.y++;
						else if (curPoint.y > endPoint.y) curPoint.y--;
					}
					else
					{
						// make this be a straightish line instead of a straight -> diagonal one.
						if (Math.abs(endPoint.x - curPoint.x) > (endPoint.y - curPoint.y))
						{
							if (curPoint.x < endPoint.x) curPoint.x++;
							else if (curPoint.x > endPoint.x) curPoint.x--;
						}
						else
						{
							if (curPoint.y < endPoint.y) curPoint.y++;
							else if (curPoint.y > endPoint.y) curPoint.y--;
						}
					}
					
					path.push(new Point(curPoint.x, curPoint.y));
				}
				
				return trimPath(path);
			}
			
			// Shortest path to endPoint might be reachable in less than maxPathLength moves! Time to do A*!
			reset();
			
			// Set up starting node.
			var start:FlxPathfindingNode = getNodeAt(startPoint.x, startPoint.y);
			var end:FlxPathfindingNode = getNodeAt(endPoint.x, endPoint.y);
			start.g = 0;
			start.h = calcDistance(start, end);
			start.f = start.h;
			
			// Push starting node onto open list.
			open.push(start);
			start.processedState = FlxPathfindingNode.OPEN;
			
			var f:int;
			var curNode:FlxPathfindingNode;
				
			while (open.length > 0)
			{
				f = int.MAX_VALUE;
				//Choose the node with the least cost f
				for (var i:int = open.length - 1; i >= 0; i--)
				{
					if (open[i].f < f)
					{
						// How the hell do you swap again?
						curNode = open[i];
						open[i] = open[open.length - 1]; // modifying it inside the for loop?
						open[open.length - 1] = curNode; // should be fine, it's not a "for each" loop
						f = curNode.f;
					}
				}
				
				// check G?
				
				// Check if current node is ending point.
				if (curNode == end)
				{
					path = rebuildPath(curNode);
					break;
				}
				
				// Mark current node as visited(remove it from the open list and add it to the closed list)
				//open.splice(open.indexOf(curNode), 1);
				open.pop();
				closed.push(curNode);
				curNode.processedState = FlxPathfindingNode.CLOSED;
				
				// Set up each of this node's neighbors.
				for each (var n:FlxPathfindingNode in getNeighbors(curNode))
				{
					//if (n.processedState == FlxPathfindingNode.CLOSED) //|| n.x < 0 || n.x >= _map.widthInTiles || n.y < 0 || n.y >= _map.heightInTiles) continue; // || curNode.g + n.cost + calcDistance(n, end) > maxCost
					var g:int = (n.x == curNode.x || n.y == curNode.y) ? (curNode.g + COST_ORTHOGONAL) : (curNode.g + COST_DIAGONAL);
					
					if (n.processedState == FlxPathfindingNode.UNPROCESSED)
					{	
						n.g = g; //path travelled so far
						if (n.h == 0) n.h = calcDistance(n, end); //estimated path to goal
						n.f = n.g + n.h;
						//if (n.f > maxCost) continue; // I think with this we'd eventually do a buncha redundant calcs for this node.
						//else
						//{
						n.parent = curNode;
						open.push(n);
						n.processedState = FlxPathfindingNode.OPEN;
						//}
					}
					else if (g < n.g) // is open!
					{
						n.parent = curNode;
						n.g = g;
						//n.h = calcDistance(n, end); // this value never changes. just like War.
						n.f = n.g + n.h;
					}
				}
			}
			
			if (path == null && acceptClosestBroken)
			{
				// No path could be found.
				var min:int = int.MAX_VALUE;
				var nearestNode:FlxPathfindingNode;
				//find the reachable node that is nearest to the goal
				for each(var c:FlxPathfindingNode in closed)
				{
					//var dist:Number = calcDistance(c, end, allowDiagonalMovement); // use c.h?
					if (c.h < min)//(dist < min)
					{
						min = c.h;//dist;
						nearestNode = c;
					}
				}
				
				path = rebuildPath(nearestNode); //returns the path to the node nearest to the goal
			}
			
			return path;
		}
		
		
		
		// Returns the Vector of points representing a path from end to start point.
		// The starting point is NOT included in this path. The ending point is.
		private function rebuildPath(end:FlxPathfindingNode):Vector.<Point>
		{
			if (end == null) return null;
			
			var path:Vector.<Point> = new Vector.<Point>();
			var n:FlxPathfindingNode = end;
			//path.push(new Point(n.x, n.y)); // The ending point. Good or bad to include?
			while (n.parent != null) //aka, until we get to starting node
			{
				path.push(new Point(n.x, n.y));
				n = n.parent;
			}
			
			// Make it so ending point is last element.
			path = path.reverse();
			
			// Trim the path to maxLength and maxCost.
			return trimPath(path);
		}
		
		
		
		private function trimPath(path:Vector.<Point>):Vector.<Point>
		{
			if (path == null) return null;
			
			// First, trim according to length!
			if (_maxLength != 0 && path.length > 1)
			{
				var lengthDiff:int = path.length - _maxLength;
				if (lengthDiff > 0)
				{
					if (_acceptClosestBroken) path.splice(_maxLength, lengthDiff);
					else path = null;
				}
			}
			
			if (path != null && _maxCost != 0)
			{	
				var pathCost:int = 0;
				var prevPoint:Point, curPoint:Point;
				var cp:int = 0;
				
				while (cp < path.length)
				{
					prevPoint = curPoint;
					curPoint = (cp == 0) ? (_startPoint) : (path[cp]);
					pathCost += (curPoint.x == prevPoint.x || curPoint.y == prevPoint.y) ? (COST_ORTHOGONAL) : (COST_DIAGONAL);
					if (pathCost > _maxCost)
					{
						if (_acceptClosestBroken && cp > 0) path.splice(cp, path.length - cp - 1);
						else path = null;
						break;
					}
					cp++;
				}
			}
			
			return path;
		}
		
		
		
		private function getNeighbors(node:FlxPathfindingNode):Vector.<FlxPathfindingNode>
		{
			var x:int = node.x;	
			var y:int = node.y;
			var testNode:FlxPathfindingNode;
			var neighbors:Vector.<FlxPathfindingNode> = new Vector.<FlxPathfindingNode>();
			
			if (x > 0)
			{
				testNode = getNodeAt(x - 1, y);
				if (testNode.walkable && testNode.processedState != FlxPathfindingNode.CLOSED) neighbors.push(testNode);
			}
			if (x < _map.widthInTiles - 1)
			{
				testNode = getNodeAt(x + 1, y);
				if (testNode.walkable && testNode.processedState != FlxPathfindingNode.CLOSED) neighbors.push(testNode);
			} 
			if (y > 0)
			{
				testNode = getNodeAt(x, y - 1);
				if (testNode.walkable && testNode.processedState != FlxPathfindingNode.CLOSED) neighbors.push(testNode);
			}
			if (y < _map.heightInTiles - 1)
			{
				testNode = getNodeAt(x, y + 1);
				if (testNode.walkable && testNode.processedState != FlxPathfindingNode.CLOSED) neighbors.push(testNode);
			}
			
			if (_allowDiag)
			{
				if (x > 0 && y > 0)
				{
					testNode = getNodeAt(x - 1, y - 1);
					if (testNode.walkable && testNode.processedState != FlxPathfindingNode.CLOSED
						&& getNodeAt(x - 1, y).walkable && getNodeAt(x, y - 1).walkable) neighbors.push(testNode);
				}
				if (x < _map.widthInTiles - 1 && y > 0)
				{
					testNode = getNodeAt(x + 1, y - 1);
					if (testNode.walkable && testNode.processedState != FlxPathfindingNode.CLOSED
						&& getNodeAt(x + 1, y).walkable && getNodeAt(x, y - 1).walkable) neighbors.push(testNode);
				}
				if (x > 0 && y < _map.heightInTiles - 1)
				{
					testNode = getNodeAt(x - 1, y + 1);
					if (testNode.walkable && testNode.processedState != FlxPathfindingNode.CLOSED
						&& getNodeAt(x - 1, y).walkable && getNodeAt(x, y + 1).walkable) neighbors.push(testNode);
				}
				if (x < _map.widthInTiles - 1 && y < _map.heightInTiles - 1)
				{
					testNode = getNodeAt(x + 1, y + 1);
					if (testNode.walkable && testNode.processedState != FlxPathfindingNode.CLOSED
						&& getNodeAt(x + 1, y).walkable && getNodeAt(x, y + 1).walkable) neighbors.push(testNode);
				}
			}
			
			return neighbors;
		}
		
		
		
		// Calculate an approximate distance between two nodes using Manhattan distance method.
		private function calcDistance(start:FlxPathfindingNode, end:FlxPathfindingNode):int
		{
			if (_allowDiag)
			{
				var xDist:int = Math.abs(end.x - start.x);
				var yDist:int = Math.abs(end.y - start.y);
				
				if (xDist < yDist)
				{
					return (((yDist - xDist) * COST_ORTHOGONAL) + (xDist * COST_DIAGONAL));
				}
				else
				{
					return (((xDist - yDist) * COST_ORTHOGONAL) + (yDist * COST_DIAGONAL));
				}
			}
			else
			{
				// Manhattan Distance
				if (start.x > end.x)
				{
					if (start.y > end.y)
						return COST_ORTHOGONAL * ((start.x - end.x) + (start.y - end.y));
					else
						return COST_ORTHOGONAL * ((start.x - end.x) + (end.y - start.y));
				}
				else
				{
					if (start.y > end.y)
						return COST_ORTHOGONAL * ((end.x - start.x) + (start.y - end.y));
					else
						return COST_ORTHOGONAL * ((end.x - start.x) + (end.y - start.y));
				}
			}
		}
		
		//not sure which one is faster, have to do some test
		/*private function calcDistance2(start:FlxPathfindingNode, end:FlxPathfindingNode):int {
			return Math.abs(start.x - end.x) + Math.abs(start.y - end.y);
		}*/
		
		
		
		public function getNodeAt(x:int, y:int):FlxPathfindingNode { return _nodes[(y * _map.widthInTiles) + x]; }
		
		public function unload():void
		{
			if (_nodes != null)
			{
				for (var i:int = 0; i < _nodes.length; i++)
				{
					_nodes[i].parent = null;
					_nodes[i] = null;
				}
			}
			
			_map = null;
		}
	}
}