package net.spider.modules{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.text.TextFormat;
    import net.spider.main;
	import net.spider.handlers.ClientEvent;
	import net.spider.handlers.SFSEvent;
	
	public class drops extends MovieClip{

		public static var events:EventDispatcher = new EventDispatcher();
        private static var dropTimer:Timer;

		public static function onCreate():void{
			drops.events.addEventListener(ClientEvent.onToggle, onToggle);
			main.Game.sfc.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponseHandler);
		}

		public static function onToggle(e:Event):void{
			if(options.draggable){
				dropTimer = new Timer(100);
				dropTimer.addEventListener(TimerEvent.TIMER, onTimer);
				dropTimer.start();
			}else{
				dropTimer.reset();
				dropTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}

		static var incr:int = 0;
        public static function onExtensionResponseHandler(e:*):void{
            var dID:*;
            var protocol:* = e.params.type;
            if (protocol == "json")
                {
                    var resObj:* = e.params.dataObj;
                    var cmd:* = resObj.cmd;
                    switch (cmd)
                    {
                        case "dropItem":
							var itemA:MovieClip;
							var itemB:MovieClip;
							var i:*;
							i = (main.Game.ui.dropStack.numChildren - 2);
							while (i > -1)
							{
								itemA = (main.Game.ui.dropStack.getChildAt(i) as MovieClip);
								itemB = (main.Game.ui.dropStack.getChildAt((i + 1)) as MovieClip);
								(itemA.fY = (itemA.y = (itemB.fY - (itemB.fHeight + 8))));
								itemB.fX = (main.Game.ui.dropStack.getChildAt(0) as MovieClip).fX;
								itemB.x = (main.Game.ui.dropStack.getChildAt(0) as MovieClip).x;
								i--;
							};
                        	break;
                    }
                }
        }

        public static function onTimer(e:TimerEvent):void{
			if(!main.Game.sfc.isConnected)
				return
			if(main.Game.ui.dropStack.numChildren < 1)
				return;
			for(var i:int = 0; i < main.Game.ui.dropStack.numChildren; i++){
				try{
					var mcDrop:* = (main.Game.ui.dropStack.getChildAt(i) as MovieClip);
					if(!mcDrop.hasEventListener(MouseEvent.MOUSE_DOWN)){
						mcDrop.addEventListener(MouseEvent.MOUSE_DOWN, drops.startDrag, false, 0, true);
						mcDrop.addEventListener(MouseEvent.MOUSE_UP, drops.stopDrag, false, 0, true);
					}
				}catch(exception){
					trace("Error handling drops: " + exception);
				}
			}
		}

		private static function startDrag(e:MouseEvent):void{
			e.currentTarget.startDrag(); 
		}
		
		private static function stopDrag(e:MouseEvent):void{
			e.currentTarget.stopDrag(); 
		}
	}
	
}
