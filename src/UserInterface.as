package  
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.Text;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * User Interface added to facilitate editing main properties of the project.
	 * 
	 * @author Aldo
	 */
	public class UserInterface extends Sprite
	{
		// variables for input / output.
		private var mUseFsmCheckBox:CheckBox;
		private var mHungerThresholdInput:InputText;
		private var mThirstThresholdInput:InputText;
		private var mSleepThresholdInput:InputText;
		private var mBoredThresholdMinInput:InputText;
		private var mBoredThresholdMaxInput:InputText;
		private var mCurrentStateText:TextField;
		private var mStateValuesText:Text;
		private var mAgentMessage:Label;
		
		// static instance used to force the existence of only one instance of this class.
		private static var mInstance:UserInterface;
		
		/** Get UserInterface instance. */
		public static function getInstance():UserInterface
		{
			if (!mInstance) {
				new UserInterface();
			}
			
			return mInstance;
		}
		
		public function UserInterface() 
		{
			// if there already is an instance, throw error.
			if (mInstance) {
				throw new Error(Constants.SINGLETON_ERROR_MESSAGE);
			}
			
			mInstance = this;
			init();
		}
		
		// initialize method, used to setup interactivity with the user.
		private function init():void
		{
			alpha = Editor.UI_ALPHA;
			x = Editor.UI_OFFSET.x;
			y = Editor.UI_OFFSET.y;
			
			addLine();
			addStaticTexts();
			addInputs();
			addOutputs();
			
			// setup loop of the user interface.
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function say(message:String):void
		{
			mAgentMessage.text = message;
		}
		
		private function addLine():void
		{
			graphics.lineStyle(Editor.UI_LINE_COLOR, 1);
			graphics.moveTo(Editor.UI_LINE_POS.x, Editor.UI_LINE_POS.y);
			graphics.lineTo(Editor.UI_LINE_WIDTH, Editor.UI_LINE_POS.y);
			graphics.endFill();
		}
		
		private function addStaticTexts():void
		{
			addChild(Misc.text(Editor.UI_STATIC_TEXTS_OFFSET.x, 
								Editor.UI_STATIC_TEXTS_OFFSET.y, 
								Constants.UI_STATIC_TEXTS.hungerThreshold, 
								Editor.UI_STATIC_TEXT_SIZE));
								
			addChild(Misc.text(Editor.UI_STATIC_TEXTS_OFFSET.x, 
								Editor.UI_STATIC_TEXTS_OFFSET.y + Editor.UI_INPUT_DELTA_Y, 
								Constants.UI_STATIC_TEXTS.thirstThreshold, 
								Editor.UI_STATIC_TEXT_SIZE));
								
			addChild(Misc.text(Editor.UI_STATIC_TEXTS_OFFSET.x, 
								Editor.UI_STATIC_TEXTS_OFFSET.y + Editor.UI_INPUT_DELTA_Y * 2, 
								Constants.UI_STATIC_TEXTS.sleepThreshold, 
								Editor.UI_STATIC_TEXT_SIZE));
								
			addChild(Misc.text(Editor.UI_STATIC_TEXTS_OFFSET.x, 
								Editor.UI_STATIC_TEXTS_OFFSET.y + Editor.UI_INPUT_DELTA_Y * 3, 
								Constants.UI_STATIC_TEXTS.boredomThreshold, 
								Editor.UI_STATIC_TEXT_SIZE));
								
			addChild(Misc.text(Editor.UI_STATE_OFFSET.x, 
								Editor.UI_STATE_OFFSET.y, 
								Constants.UI_STATE, 
								Editor.UI_STATE_TEXT_SIZE));
		}
		
		private function addInputs():void
		{
			// the checkbox.
			mUseFsmCheckBox = new CheckBox(this, 0, 0, Constants.UI_AUTOMATIC_TEXT, handleFsmCheckbox);
			mUseFsmCheckBox.selected = Editor.USE_FSM;
			
			// hunger threshold input field.
			mHungerThresholdInput = new InputText(this, 0, 
													Editor.UI_INPUT_DELTA_Y, 
													Editor.HUNGER_THRESHOLD.toString(), 
													handleHungerThresholdInput);
													
			mHungerThresholdInput.width = Editor.UI_INPUT_WIDTH;
			
			// thirst threshold input field.
			mThirstThresholdInput = new InputText(this, 0, 
													Editor.UI_INPUT_DELTA_Y * 2, 
													Editor.THIRST_THRESHOLD.toString(),
													handleThirstThresholdInput);
													
			mThirstThresholdInput.width = Editor.UI_INPUT_WIDTH;
			
			// sleep threshold input field.
			mSleepThresholdInput = new InputText(this, 0, 
													Editor.UI_INPUT_DELTA_Y * 3, 
													Editor.SLEEPINESS_THRESHOLD.toString(),
													handleSleepThresholdInput);
													
			mSleepThresholdInput.width = Editor.UI_INPUT_WIDTH;
			
			// boredom threshold input minimum and maximum.
			mBoredThresholdMinInput = new InputText(this, 0, 
													Editor.UI_INPUT_DELTA_Y * 4, 
													Editor.BORED_RANGE.x.toString(),
													handleBoredThresholdMinInput);
																		
			mBoredThresholdMinInput.width = (Editor.UI_INPUT_WIDTH - Editor.UI_HALF_INPUT_DISTANCE) / 2;
			
			mBoredThresholdMaxInput = new InputText(this, (Editor.UI_INPUT_WIDTH + Editor.UI_HALF_INPUT_DISTANCE) / 2, 
													Editor.UI_INPUT_DELTA_Y * 4, 
													Editor.BORED_RANGE.y.toString(),
													handleBoredThresholdMaxInput);
																		
			mBoredThresholdMaxInput.width = (Editor.UI_INPUT_WIDTH - Editor.UI_HALF_INPUT_DISTANCE) / 2;
		}
		
		private function addOutputs():void
		{
			mStateValuesText = new Text(this, Editor.UI_STATE_VALUES_PROPS.x, Editor.UI_STATE_VALUES_PROPS.y);
			mStateValuesText.width = Editor.UI_STATE_VALUES_PROPS.width;
			mStateValuesText.height = Editor.UI_STATE_VALUES_PROPS.height;
			mStateValuesText.editable = false;
			
			mCurrentStateText = Misc.text(Editor.UI_CURRENT_STATE_OFFSET.x,
											Editor.UI_CURRENT_STATE_OFFSET.y, 
											Constants.UI_AGENT_START_STATE, 
											Editor.UI_CURRENT_STATE_TEXT_SIZE);
			addChild(mCurrentStateText);
			
			mAgentMessage = new Label(this);
		}
		
		private function handleFsmCheckbox(e:Event):void
		{
			Editor.USE_FSM = mUseFsmCheckBox.selected;
			
			// change text.
			if (mUseFsmCheckBox.selected) {
				mUseFsmCheckBox.label = Constants.UI_AUTOMATIC_TEXT;
			}
			else {
				mUseFsmCheckBox.label = Constants.UI_MANUAL_TEXT;
			}
			
			Scene.getInstance().updateNodesAppearance();
		}
		
		private function handleHungerThresholdInput(e:Event):void
		{
			var newValue:Number = uint(mHungerThresholdInput.text);
			
			// make sure value is within range.
			if (newValue >= Editor.THRESHOLD_RANGE.x && newValue <= Editor.THRESHOLD_RANGE.y) {
				Editor.HUNGER_THRESHOLD = newValue;
			}
		}
		
		private function handleThirstThresholdInput(e:Event):void
		{
			var newValue:Number = uint(mThirstThresholdInput.text);
			
			// make sure value is within range.
			if (newValue >= Editor.THRESHOLD_RANGE.x && newValue <= Editor.THRESHOLD_RANGE.y) {
				Editor.THIRST_THRESHOLD = newValue;
			}
		}
		
		private function handleSleepThresholdInput(e:Event):void
		{
			var newValue:Number = uint(mSleepThresholdInput.text);
			
			// make sure value is within range.
			if (newValue >= Editor.THRESHOLD_RANGE.x && newValue <= Editor.THRESHOLD_RANGE.y) {
				Editor.SLEEPINESS_THRESHOLD = newValue;
			}
		}
		
		private function handleBoredThresholdMinInput(e:Event):void
		{
			var newValue:Number = uint(mBoredThresholdMinInput.text);
			
			// make sure value is within range.
			if (newValue >= Editor.THRESHOLD_RANGE.x && newValue <= Editor.THRESHOLD_RANGE.y) {
				Editor.BORED_RANGE.x = newValue;
				
				// update the agent with the new info.
				Scene.getInstance().getAgent().calculateBoredomThreshold();
			}
		}
		
		private function handleBoredThresholdMaxInput(e:Event):void
		{
			var newValue:Number = uint(mBoredThresholdMaxInput.text);
			
			// make sure value is within range.
			if (newValue >= Editor.THRESHOLD_RANGE.x && newValue <= Editor.THRESHOLD_RANGE.y) {
				Editor.BORED_RANGE.y = newValue;
				
				// update the agent with the new info.
				Scene.getInstance().getAgent().calculateBoredomThreshold();
			}
		}
		
		public function UpdateCurrentStateText(value:String):void
		{
			mCurrentStateText.text = value;
		}
		
		public function UpdateStatesValuesText(hunger:uint, thirst:uint, sleepiness:uint, boredom:uint, 
												boredomThreshold:uint):void
		{
			mStateValuesText.text = Constants.HUNGER + " \t" + hunger + " / " + Editor.HUNGER_THRESHOLD + "\n"
										+ Constants.THIRST + " \t" + thirst + " / " + Editor.THIRST_THRESHOLD + "\n"
										+ Constants.SLEEP + " \t" + sleepiness + " / " + Editor.SLEEPINESS_THRESHOLD + "\n"
										+ Constants.BOREDOM + " \t" + boredom + " / " + boredomThreshold + "\n";
		}
		
		private function update(e:Event):void
		{
			var agent:Agent = Scene.getInstance().getAgent();
			mAgentMessage.x = agent.x - mAgentMessage.width / 2;
			mAgentMessage.y = agent.y + agent.height / 2;
		}
	}

}