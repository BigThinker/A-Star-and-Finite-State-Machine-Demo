Nodegraph with FSM and A Star implemented.
Agent hunger, thirst, boredom, sleepiness increase all the time when agent is staying in a node (not traveling). 
When a state hits threshold value, it will change the state of the agent. 
Agent has a list of unknown nodes and discovers more nodes when he travels through / to them, which get cut from unknown nodes list. 
When agent is bored he goes to a random node (unknown, or any node if there's nothing left to explore). 
Agent sleeps at a 'safe' node out of 'sleepiness'.
Agent drinks at a 'water' node out of 'thirst'.
Agent eats at a 'food' node out of 'hunger'.
Agent explores at a random unknown node out of 'boredom'.

Aldo Leka 
School AI Project