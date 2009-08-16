/*
	PureMVC Flex Demo - Use Loadup Utility - Manage loading of data resources
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.loadupasordered.model
{
	import flash.events.Event;

	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;
	import org.puremvc.as3.utilities.asyncstub.model.AsyncStubProxy;

    import org.puremvc.as3.demos.flex.loadupasordered.ApplicationFacade;

	public class ProductProxy extends EntityProxy implements ILoadupProxy
	{
		public static const NAME:String = 'ProductProxy';
		public static const SRNAME:String = 'ProductSRProxy';

        private var loadCount :int = 0;

		public function ProductProxy( ) {
			super( NAME );
		}

        /**
         *  Use AsyncStubProxy to simulate an async load.
         *  Given that load() may be called more than once, because of retries,
         *  possibly after timeout,
         *  we discard any results that are not for the latest call, by use
         *  of the token property of the async stub.
         */
        public function load() :void {
            loadCount++;
            sendNotification( ApplicationFacade.PRODUCT_LOADING );
            var stub :AsyncStubProxy = new AsyncStubProxy();
            stub.token = loadCount;
            stub.maxDelayMSecs = 0; //=> immediate completion
            stub.probabilityOfFault = 0.6; // => often a bad connection !!
            stub.asyncAction( loaded, failed );
        }

        protected function loaded( asToken :Object =null ) :void {
            if ( ( asToken == null ) || ( (asToken as int) == loadCount ) )
                sendLoadedNotification( ApplicationFacade.PRODUCT_LOADED, NAME, SRNAME);
        }

        protected function failed( asToken :Object =null ) :void {
            if ( ( asToken == null ) || ( (asToken as int) == loadCount ) )
                sendLoadedNotification( ApplicationFacade.PRODUCT_FAILED, NAME, SRNAME);
        }

	}
}