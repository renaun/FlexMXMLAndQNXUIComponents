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

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.utils.describeType;

import mx.core.DesignLayer;
import mx.core.IVisualElement;
import mx.geom.TransformOffsets;

import qnx.ui.core.Container;
import qnx.ui.core.SizeUnit;
import com.renaun.mxml.QContainer;

[DefaultProperty("qnxContent")]

/**
 *  Dispatched when all the DisplayObjects have been added to the container.
 *
 *  @eventType flash.events.Event.COMPLETE
 *  
 */
[Event(name="complete", type="flash.events.Event")]

/**
 *  The QView extends the QContainer class act just like a QContainer class.
 *  But provides the ability to use this container as a View object in the
 *  com.riaspace.as3viewnavigator.ViewNavigator class.
 *
 *  @author Renaun Erickson
 *  
 *  @langversion 3.0
 *  @productversion BlackBerry Tablet OS SDK 0.9.2
 */
public class QView extends QContainer implements IView
{
	public function QView(s:Number=100, su:String="percent")
	{
		super(s, su);
	}
	
	/**
	 * 	@private
	 */
	private var _navigator:ViewNavigator;
	
	/**
	 *  Reference to the navigator class associated with this view.
	 */
	public function get navigator():ViewNavigator
	{
		return _navigator;
	}
		
	/**
	 * 	@private
	 */
	public function set navigator(value:ViewNavigator):void
	{
		_navigator = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	public function get viewReturnObject():Object
	{
		return this;
	}
}
}