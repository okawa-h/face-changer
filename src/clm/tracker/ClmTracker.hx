package clm.tracker;

import haxe.extern.EitherType;
import js.html.CanvasElement;
import js.html.VideoElement;

typedef Parameters = {
	?constantVelocity :Bool,
	?searchWindow     :Int,
	?useWebGL         :Bool,
	?scoreThreshold   :Float,
	?stopOnConvergence:Bool,
	?faceDetection: { ?useWebWorkers:Bool }
}

typedef BoudingBox = Array<Float>;
typedef Position   = Array<Array<Float>>;

@:enum abstract EventType(String) from String to String {
	var clmtrackrConverged:String = 'clmtrackrConverged';
	var clmtrackrLost     :String = 'clmtrackrLost';
}

@:enum abstract DrawType(String) from String to String {
	var normal  :String = 'normal';
	var vertices:String = 'vertices';
}

@:enum abstract ResponseModeType(String) from String to String {
	var single:String = 'single';
	var cycle :String = 'cycle';
	var blend :String = 'blend';
}
 
@:native('clm.tracker')
extern class ClmTracker {

	public function new(?parameters:Parameters):Void;

	public function init(?pModel:Dynamic):Void;
	public function start(element:EitherType<CanvasElement,VideoElement>,?box:BoudingBox):Bool;
	public function stop():Void;
	
	public function track(element:EitherType<CanvasElement,VideoElement>,?box:BoudingBox):Array<Int>;
	
	public function reset():Void;
	public function draw(canvas:CanvasElement,?pv:Array<Float>,?path:DrawType):Void;

	public function getScore():Float;
	public function getCurrentPosition():EitherType<Position,Bool>;
	public function getCurrentParameters():Array<Float>;
	public function getConvergence():Float;

	public function setResponseMode(type:ResponseModeType,list:Dynamic):Void;

}
