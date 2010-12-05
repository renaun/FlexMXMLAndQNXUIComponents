package
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import qnx.ui.buttons.Button;
import qnx.ui.core.Container;

public class DisplayButtonAS3 extends Sprite
{
	public function DisplayButtonAS3()
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		var container:Container = new Container();
		var but:Button = new Button();
		container.addChild(but);
		addChild(container);
		container.setSize(stage.stageWidth, stage.stageHeight);
	}
}
}