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
package com.renaun.qnx.ui.display
{
import flash.display.Bitmap;
import flash.events.Event;

import qnx.ui.core.Container;
import qnx.ui.core.UIComponent;
import qnx.ui.display.Image;

/**
 *  The Image extends the com.qnx.ui.dispaly.Image class to allow for property
 *  binding that loads the image. 
 *
 *  @author Renaun Erickson
 *  
 *  @langversion 3.0
 *  @productversion BlackBerry Tablet OS SDK 0.9.2
 *  @productversion Flex 4.5
 */
public class Image extends qnx.ui.display.Image
{
	public function Image()
	{
		super();
		addEventListener(Event.COMPLETE, completeHandler);
	}
	
	private var _source:*;

	/**
	 * 	The source property will call setImage()
	 */
	public function get source():*
	{
		return _source;
	}

	/**
	 * @private
	 */
	public function set source(value:*):void
	{
		_source = value;
		setImage(value);
	}
	
	private function completeHandler(event:Event):void
	{
		if (getChildAt(0) is Bitmap)
		{
			var b:Bitmap = getChildAt(0) as Bitmap;
			setSize(b.width, b.height);
			//trace(b.width + " - " + b.height);
			// For now this works, i tried invalidateProperty() but that didn't work
			//(parent as UIComponent).setSize((parent as UIComponent).width, (parent as UIComponent).height);
			(parent as Container).layout();
		}
	}

}
}