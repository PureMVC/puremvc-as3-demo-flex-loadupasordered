/*
	PureMVC Flex Demo - Use Loadup Utility - Manage loading of data resources
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.demos.flex.loadupasordered.controller {
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import org.puremvc.as3.utilities.loadup.model.LoadupResourceProxy;
	import org.puremvc.as3.utilities.loadup.model.LoadupMonitorProxy;
	import org.puremvc.as3.utilities.loadup.model.RetryPolicy;
	import org.puremvc.as3.utilities.loadup.model.RetryParameters;
	import org.puremvc.as3.utilities.loadup.interfaces.ILoadupProxy;

    import org.puremvc.as3.demos.flex.loadupasordered.model.CustomerProxy;
    import org.puremvc.as3.demos.flex.loadupasordered.model.ProductProxy;
    import org.puremvc.as3.demos.flex.loadupasordered.model.SalesOrderProxy;
    import org.puremvc.as3.demos.flex.loadupasordered.model.DebtorAccountProxy;
    import org.puremvc.as3.demos.flex.loadupasordered.model.InvoiceProxy;
    import org.puremvc.as3.demos.flex.loadupasordered.view.ApplicationMediator;

	public class LoadResourcesCommand extends SimpleCommand implements ICommand {

		/**
		 * 
		 * As regards an open-ended resource list, see BY THE WAY below.
		 */

		private var monitor :LoadupMonitorProxy;

		override public function execute( note:INotification ) : void {

            
		    facade.registerProxy( new LoadupMonitorProxy() );
		    this.monitor = facade.retrieveProxy( LoadupMonitorProxy.NAME ) as LoadupMonitorProxy;
		    this.monitor.defaultRetryPolicy = new RetryPolicy( note.getBody() as RetryParameters) ;

			var cusPx :ILoadupProxy = new CustomerProxy();
			var proPx :ILoadupProxy = new ProductProxy();
			var soPx :ILoadupProxy = new SalesOrderProxy();
			var daccPx :ILoadupProxy = new DebtorAccountProxy();
			var invPx :ILoadupProxy = new InvoiceProxy();

            facade.registerProxy( cusPx );
            facade.registerProxy( proPx );
            facade.registerProxy( soPx );
            facade.registerProxy( daccPx );
            facade.registerProxy( invPx );

            var rCus :LoadupResourceProxy = makeAndRegisterLoadupResource( CustomerProxy.SRNAME, cusPx );
            var rPro :LoadupResourceProxy = makeAndRegisterLoadupResource( ProductProxy.SRNAME, proPx );
            var rSO :LoadupResourceProxy = makeAndRegisterLoadupResource( SalesOrderProxy.SRNAME, soPx );
            var rDAcc :LoadupResourceProxy = makeAndRegisterLoadupResource( DebtorAccountProxy.SRNAME, daccPx );
            var rInv :LoadupResourceProxy = makeAndRegisterLoadupResource( InvoiceProxy.SRNAME, invPx );

            rSO.requires = [ rCus, rPro ];
            rDAcc.requires = [ rCus ];
            rInv.requires = [ rDAcc, rSO ];

            monitor.loadResources();

		}
        private function makeAndRegisterLoadupResource( proxyName :String, appResourceProxy :ILoadupProxy )
        :LoadupResourceProxy {
            var r :LoadupResourceProxy = new LoadupResourceProxy( proxyName, appResourceProxy );
            facade.registerProxy( r );
            monitor.addResource( r );
            return r;
        }

        /* BY THE WAY...
        *   If you wanted to consider an open-ended resource list, the following lines of code
        *   illustrate how the above code would be changed so that the Invoice resource is added 
        *   after loading of the others has commenced.
        *   
        var rCus :LoadupResourceProxy = makeAndRegisterLoadupResource( CustomerProxy.SRNAME, cusPx );
        var rPro :LoadupResourceProxy = makeAndRegisterLoadupResource( ProductProxy.SRNAME, proPx );
        var rSO :LoadupResourceProxy = makeAndRegisterLoadupResource( SalesOrderProxy.SRNAME, soPx );
        var rDAcc :LoadupResourceProxy = makeAndRegisterLoadupResource( DebtorAccountProxy.SRNAME, daccPx );

        rSO.requires = [ rCus, rPro ];
        rDAcc.requires = [ rCus ];

        monitor.keepResourceListOpen();
        monitor.expectedNumberOfResources = 20; // extreme example, line is optional
        monitor.loadResources();

        var rInv :LoadupResourceProxy = new LoadupResourceProxy( InvoiceProxy.SRNAME, invPx );
        facade.registerProxy( rInv );
        rInv.requires = [ rDAcc, rSO ];
        monitor.addResource( rInv );
        monitor.closeResourceList(); // comment this line to observe behaviour
        */

	}
	
}
