// =================================================================================================
//
//	FSMShortestPath
//	Copyright 2014 Aldo Leka. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it.
//
// =================================================================================================

package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * Main class of the project executed on the start of the program.
	 * It is responsible to start the scene and add it to the display list (for rendering).
	 * Also, a user interface to falicitate editing project properties is added here.
	 * 
	 * @author Aldo
	 */
	public class Main extends Sprite 
	{	
		// constructor of the class, used to initialize all variables and setup functionality.
		public function Main():void 
		{
			// add Scene to the display list.
			addChild(Scene.getInstance());
			// add User Interface to the display list.
			addChild(UserInterface.getInstance());
		}
		
	}
	
}