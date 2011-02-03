/*
Copyright (c) 2010 Renaun Erickson (http://renaun.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

https://github.com/renaun/FlexMXMLAndQNXUIComponents
*/
package com.renaun.mxml
{
	
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

/**
 *  The QApplication class assumes that this container wants
 *  to fill up the whole stage by default. Also assumes the 
 *  stage is set to no scale and align top left. 
 * 
 *  It provides an COMPLETE event when all children are added so you can
 *  start the application logic.
 *
 *
 *  @author Renaun Erickson
 *  
 *  @langversion 3.0
 *  @productversion BlackBerry Tablet OS SDK 0.9.2
 */
public class QApplication extends QContainer
{
	public function QApplication()
	{
		super();
	}

	/**
	 * 	@private
	 *  Sets the stage to no scale and align top left.
	 */
	override protected function addedToStageHandler(event:Event):void
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		super.addedToStageHandler(event);
	}
}
}