/*
Copyright (c) 2011 Renaun Erickson (http://renaun.com)

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
package com.renaun.view
{
import com.riaspace.as3viewnavigator.IView;
import com.riaspace.as3viewnavigator.ViewNavigator;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;

/**
 *  The QViewNavigator extends the com.riaspace.as3viewnavigator.ViewNavigator to 
 * 	allow for setting container class outside the constructor. As well as provide
 *  a firstView property.
 *
 *  @author Renaun Erickson
 *  
 *  @langversion 3.0
 *  @productversion BlackBerry Tablet OS SDK 0.9.2
 */
public class QViewNavigator extends ViewNavigator
{
	public function QViewNavigator()
	{
		// workaround to having to call the super constructor earlier then I wanted
		try
		{
			super(null);
		}
		catch (error:Error)
		{
			
		}
	}
	
	/**
	 * 	@private race condition around property setting and binding just 
	 *  being double sure
	 */
	protected var doesFirstViewNeedSetting:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	

	/**
	 * 	The main application sprite that has a reference to stage. This setups
	 *  up a listener for stage resize that then chagnes up all the width/height
	 *  of the views.
	 */
	public function set application(value:Sprite):void
	{
		super.parent = value;
		// Setup the RESIZE, this does assume your views want to fill up the whole stage
		if (parent.stage)
		{
			parent.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
		else
		{
			parent.addEventListener(Event.ADDED_TO_STAGE, parent_addedToStageHandler);
		}
		if (doesFirstViewNeedSetting)
		{
			doesFirstViewNeedSetting = false;
			pushFirstView();
		}
	}
	
	private var _firstView:Class;
	
	/**
	 * 	Allows for setting the first view on the navigator stack.
	 * 	If there is already a view it will not add the view to the stack
	 *  (that logic might change).
	 */
	public function get firstView():Class
	{
		return _firstView;
	}
	
	public function set firstView(value:Class):void
	{
		if (views.length == 0)
		{
			_firstView = value;
			if (!parent)
				doesFirstViewNeedSetting = true;
			else
				pushFirstView();
		}
	}
	
	protected function pushFirstView():void
	{
		pushView(new firstView());
	}
}
}