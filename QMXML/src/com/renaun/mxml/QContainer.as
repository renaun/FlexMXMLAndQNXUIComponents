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

[DefaultProperty("qnxContent")]

/**
 *  Dispatched when all the DisplayObjects have been added to the container.
 *
 *  @eventType flash.events.Event.COMPLETE
 *  
 */
[Event(name="complete", type="flash.events.Event")]

/**
 *  The QContainer extends the QNX UI Container class to allow
 *  the usage of MXML with QNX components. It adds layout invalidation
 *  when align, containment, flow, margins, padding, size, sizeMode, or sizeUnit 
 *  are changed. The layout invalidation is need to make MXML and binding
 *  useful. 
 * 
 *  It also provides the ability to use QNX MXML with no Flex or mixed with Flex
 *  (requires Spark architecture).
 * 
 *  The container class is like a Spark Group where you have to explicitly 
 *  set its dimensions. Best practice flow-able containers is to use size, 
 * 	sizeUnit and not set width or height properties.
 * 
 *  NOTE: Not all IVisualElement methods might not be implemented. As a baseline
 *  set width/height and x/y explicitly.
 * 
 *  It provides an COMPLETE event when all children are added so you can
 *  start the application logic.
 *
 *
 *  @author Renaun Erickson
 *  
 *  @langversion 3.0
 *  @productversion BlackBerry Tablet OS SDK 0.9.2
 *  @productversion Flex 4.5
 */
public class QContainer extends Container implements IVisualElement
{
	public function QContainer(s:Number=100, su:String="percent")
	{
		super(s, su);
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	/**
	 *  @private
	 *  Keep track of invalidations and re-layout once per frame.
	 */
	protected var invalideLayout:Boolean = false;
	
	/**
	 *  @private
	 *  Keep track of invalidations and re-layout once per frame.
	 */
	protected var sizeWidth:Number = 0;
	
	/**
	 *  @private
	 *  Keep track of invalidations and re-layout once per frame.
	 */
	protected var sizeHeight:Number = 0;
	
	/**
	 * 	@private
	 * 	Hack because flow does not have getter/setter
	 */
	protected var lastFlow:String = "";
	
	/**
	 * 	@private
	 * 	Hack because align does not have getter/setter
	 */
	protected var lastAlign:String = "";
	
	/**
	 * 	@private
	 */
	private var _qnxContent:Vector.<DisplayObject>;
	
	/**
	 * Array of DisplayObject instances to be added as qnxContent
	 */
	public function get qnxContent():Vector.<DisplayObject>
	{
		return _qnxContent;
	}
		
	/**
	 * 	@private
	 */
	public function set qnxContent(value:Vector.<DisplayObject>):void
	{
		if ( _qnxContent != value )
		{
			_qnxContent = value;
			for each (var child:DisplayObject in _qnxContent)
			{
				addChild(child);
			}
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	
	/**
	 * 	@private
	 *  Sets the application up to be the size of the stageWidth and stageHeight.
	 * 	Also sets the stage to no scale and align top left.
	 */
	protected function addedToStageHandler(event:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		lastFlow = flow;// initialize
		lastAlign = align; // initialize
		invalideLayout = true;
		invalidationCheckHandler(null);
		if (!hasEventListener(Event.ENTER_FRAME))
			addEventListener(Event.ENTER_FRAME, invalidationCheckHandler, false, 0, true);
		
		if (!hasEventListener(Event.RESIZE))
		{
			if (parent is Stage)
				stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			else if (!(parent is Container))
				parent.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
		}

		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	override public function set width(value:Number):void
	{
		super.width = value;
		sizeWidth = value;
		invalideLayout = true;		
	}
	
	
	override public function set height(value:Number):void
	{
		super.height = value;
		sizeHeight = value;
		invalideLayout = true;
	}
	
	/**
	 * 	@protected
	 *  Check's values to layout this container and then trickle that down.
	 */
	protected function invalidationCheckHandler(event:Event):void
	{
		// Hack because flow is not set
		if (lastFlow != flow)
		{
			lastFlow = flow;
			invalideLayout = true;
		}
		if (lastAlign != align)
		{
			lastAlign = align;
			invalideLayout = true;
		}
		if (invalideLayout)
		{
			
			/*trace("INVALIDATED");
			trace("33sw/sh: " + stage.stageWidth + "/" + stage.stageHeight);
			trace("33ss: " + size + "/" + sizeUnit + " - " + sizeMode);
			trace("33ss: " + width + "/" + height);
			trace("33parent: " + parent);*/
			invalideLayout = false;
			var w:Number = 0;
			var h:Number = 0;
			if (sizeWidth > 0 && sizeHeight > 0)
			{
				w = width;
				h = height;
			}
			else if (sizeUnit == SizeUnit.PERCENT)
			{
				if (parent != null && !(parent is Stage))
				{
					//trace("SETTING PARENT W/H" + " - " + parent.width + "/" + parent.height);
					w = size/100 * parent.width;
					h = size/100 * parent.height;
				}
				else if (stage != null)
				{
					//trace("SETTING STAGE W/H");
					w = size/100 * stage.stageWidth;
					h = size/100 * stage.stageHeight;
				}
			}
			else if (sizeUnit == SizeUnit.PIXELS)
			{
				
			}
			if (parent != null && (parent is Stage || !(parent is QContainer)))
			{
				//trace("SETTING W/H" + w+"/"+h + "==" +width+"/"+height);
				setSize(w, h);
				//trace("SETTING W/H" + w+"/"+h + "==" +width+"/"+height);
			}
		}
	}
	
	private function resizeHandler(event:Event):void
	{
		invalideLayout = true;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Methods
	//
	//--------------------------------------------------------------------------
	
	override public function set size(value:Number):void
	{
		super.size = value;
		invalideLayout = true;
	}
	
	override public function set sizeUnit(value:String):void
	{
		super.sizeUnit = value;
		invalideLayout = true;
	}
	
	override public function set sizeMode(value:String):void
	{
		super.sizeUnit = value;
		invalideLayout = true;
	}
	
	override public function set containment(value:String):void
	{
		super.containment = value;
		invalideLayout = true;
	}
	
	override public function set margins(value:Vector.<Number>):void
	{
		super.margins = value;
		invalideLayout = true;
	}
	
	override public function set padding(value:Number):void
	{
		super.padding = value;
		invalideLayout = true;
	}
	
	/*override public function set flow(value:String):void
	{
		super.flow = value;
		invalideLayout = true;
	}
	
	override protected function draw():void
	{
		super.draw();
		//trace("draw()");
	}
	*/
	
	
	
	//--------------------------------------------------------------------------
	//
	//  IVisualElement Methods
	//
	//--------------------------------------------------------------------------

	
	private var _owner:DisplayObjectContainer;
	public function get owner():DisplayObjectContainer
	{
		return _owner;
	}
	
	public function set owner(value:DisplayObjectContainer):void
	{
		_owner = value;
	}
	
	private var _depth:Number = 0;
	public function get depth():Number
	{
		return _depth;
	}
	
	public function set depth(value:Number):void
	{
		_depth = value;
	}
	
	private var _designLayer:DesignLayer;
	public function get designLayer():DesignLayer
	{
		return _designLayer;
	}
	
	public function set designLayer(value:DesignLayer):void
	{
		_designLayer = value;
	}
	
	public function get postLayoutTransformOffsets():TransformOffsets
	{
		return null;
	}
	
	public function set postLayoutTransformOffsets(value:TransformOffsets):void
	{
	}
	
	public function get is3D():Boolean
	{
		return false;
	}
	
	
	private var _left:Object;
	public function get left():Object
	{
		return _left;
	}
	
	public function set left(value:Object):void
	{
		_left = value;
	}
	
	private var _right:Object;
	public function get right():Object
	{
		return _right;
	}
	
	public function set right(value:Object):void
	{
		_right = value;
	}
	
	private var _top:Object;
	public function get top():Object
	{
		return _top;
	}
	
	public function set top(value:Object):void
	{
		_top = value;
	}
	
	private var _bottom:Object;
	public function get bottom():Object
	{
		return _bottom;
	}
	
	public function set bottom(value:Object):void
	{
		_bottom = value;
	}
	
	
	public function get horizontalCenter():Object
	{
		return null;
	}
	
	public function set horizontalCenter(value:Object):void
	{
	}
	
	public function get verticalCenter():Object
	{
		return null;
	}
	
	public function set verticalCenter(value:Object):void
	{
	}
	
	public function get baseline():Object
	{
		return null;
	}
	
	public function set baseline(value:Object):void
	{
	}
	
	public function get baselinePosition():Number
	{
		return 0;
	}
	
	public function get percentWidth():Number
	{
		return 0;
	}
	
	public function set percentWidth(value:Number):void
	{
	}
	
	public function get percentHeight():Number
	{
		return 0;
	}
	
	public function set percentHeight(value:Number):void
	{
	}
	
	public function get includeInLayout():Boolean
	{
		return false;
	}
	
	public function set includeInLayout(value:Boolean):void
	{
	}
	public function getPreferredBoundsWidth(postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getPreferredBoundsHeight(postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getMinBoundsWidth(postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getMinBoundsHeight(postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getMaxBoundsWidth(postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getMaxBoundsHeight(postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getLayoutBoundsWidth(postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getLayoutBoundsHeight(postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getLayoutBoundsX(postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function getLayoutBoundsY(postLayoutTransform:Boolean=true):Number
	{
		return 0;
	}
	
	public function setLayoutBoundsPosition(x:Number, y:Number, postLayoutTransform:Boolean=true):void
	{
	}
	
	public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean=true):void
	{
	}
	
	public function getLayoutMatrix():Matrix
	{
		return null;
	}
	
	public function setLayoutMatrix(value:Matrix, invalidateLayout:Boolean):void
	{
	}
	
		
	public function get hasLayoutMatrix3D():Boolean
	{
		return false;
	}
	
	public function getLayoutMatrix3D():Matrix3D
	{
		return null;
	}
	
	public function setLayoutMatrix3D(value:Matrix3D, invalidateLayout:Boolean):void
	{
	}
	
	public function transformAround(transformCenter:Vector3D, scale:Vector3D=null, rotation:Vector3D=null, translation:Vector3D=null, postLayoutScale:Vector3D=null, postLayoutRotation:Vector3D=null, postLayoutTranslation:Vector3D=null, invalidateLayout:Boolean=true):void
	{
	}
	
	public function get layoutDirection():String
	{
		return null;
	}
	
	public function set layoutDirection(value:String):void
	{
	}
	
	public function invalidateLayoutDirection():void
	{
	}
}
}