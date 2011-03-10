////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011 CodeCatalyst, LLC - http://www.codecatalyst.com/
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.	
////////////////////////////////////////////////////////////////////////////////

package com.codecatalyst.factory.styleable
{
	import com.codecatalyst.factory.ClassFactory;
	import com.codecatalyst.util.PropertyUtil;
	import com.codecatalyst.util.StyleUtil;
	
	import mx.styles.IStyleClient;

	/**
	 * StyleableFactory extends ClassFactory to add support for initializing generated instances with styles.
	 * 
	 * StyleableFactory allows developers to include or mix style settings in <code>properties</code>; this 
	 * feature reduces the developers burden to remember if a specific component option is a 'style' or a 'property'.
	 * 
	 * NOTE: Styles are set when the instance is first generated by StyleableFactory. For runtime data-driven style support, see StyleableRendererFactory.
	 * 
	 * @see StyleableRendererFactory
	 * 
	 * NOTE: Flex has a significant bug that causes it to ignore custom styles for containers renderers in Halo lists (ex. DataGrid, List, etc.).
	 * Developers are advised to use BoxItemRenderer or CanvasItemRenderer to ensure custom styles are not cleared by the list component.
	 *  
	 * @see com.codecatalyst.component.renderer.BoxItemRenderer
	 * @see com.codecatalyst.component.renderer.CanvasItemRenderer
	 * 
	 * @example
	 * <fe:UIComponentFactory
	 *     id="factory
	 *     generator="{ BoxItemRenderer }"
	 *     styles="{ { 
	 *                   backgroundAlpha: 0.5, 
	 *                   backgroundColor: 0x990000 
	 *             } }" 
	 *     properties="{ { 
	 *                       percentWidth:    100, 
	 *                       percentHeight:   100, 
	 *                       includeInLayout: this.showDetails, 
	 *                       verticalCenter:  0, 						// This is a style
	 *                       styleName:       'shadowBox'  
	 *                 } }"
	 *     eventListeners="{ { 
	 *                           mouseDown: function (e:MouseEvent):void {
	 *                                          var render : Canvas = event.target as BoxItemRenderer;
	 *                                          render.alpha = 0.2;
	 *                                      }, 
	 *                           mouseOver:  function (e:MouseEvent):void {
	 *                                           // NOTE: "this" is scoped to the DataGrid, negating the need to reference outerDocument
	 *                                           // handler logic goes here...
	 *                                       } 
	 *                     } }"
	 *     xmlns:fe="http://www.codecatalyst.com/2011/flex-extensions" />
	 *  
	 * @author Thomas Burleson
	 * @author John Yanarella
	 */
	public class StyleableFactory extends ClassFactory
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Styles to apply to generated instances.
		 * 
		 * Hashmap of property key / value pairs.
		 * 
		 * NOTE: Styles are only applied when the class is generated.
		 */
		public var styles:Object = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function StyleableFactory( generator:Object = null, parameters:Array  = null, properties:Object = null, eventListeners:Object = null, styles:Object = null )
		{
			super( generator, parameters, properties, eventListeners );
			
			this.styles = styles;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override public function newInstance():*
		{
			// Create instance (and apply properties and event listeners)
			
			var instance:Object = super.newInstance();
			
			// Apply styles
			
			return StyleUtil.applyStyles( IStyleClient( instance ), styles );
		}
		
		/**
		 * NOTE: This overridden method enables a mix of style and property names in <code>properties</code>.
		 * 
		 * @inheritDoc
		 */
		override protected function applyProperties( instance:Object ):void
		{
			try
			{
				// NOTE: fallbackToStyles is set to true - allowing a mix of style and property names in properties
				
				PropertyUtil.applyProperties( instance, properties, true );
			} 
			catch ( error:ReferenceError ) 
			{
				trace(error.message);	
			}	
		}		
	}
}