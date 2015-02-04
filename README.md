FSMShortestPath
===============

ActionScript project in FlashDevelop to demonstrate finite state machines and A Star algorithm.

This AI project demonstrates finite state machines and finding (shortest) path functionality. 
Connections between nodes are created randomly. Nodes have different (random) purposes for the player (agent) to 
use such as for sleep, eating food, drinking out of thirst and exploring out of boredom. 

The player finds the shortest path to a node that he "knows" (has explored before) and serves his current need. 
If there's more than one node where the player can go, he will choose randomly.
Nodes are set in Ogmo Editor (www.ogmoeditor.com).

Feel free to clone this project and change the values in Editor.as script such as:
	- USE_FSM (boolean): to either make the agent automatic (state machines) or tell it where to go (by clicking on nodes).
	- MAX_CONNECTIONS (uint): to edit the number of connections that a node can have with other nodes.
	- All the threshold values for each state.
	- AGENT_SPEED: to make the agent slower or faster.
	... and every visual aspect of the demo.
	
Also you can edit nodes.oel (xml file) 
* manually to:
	- remove (delete Node element)
	- add (add Node element) 
	- relocate (change x and y attributes of Node element) 
nodes of the scene.
* automatically using www.ogmoeditor.com