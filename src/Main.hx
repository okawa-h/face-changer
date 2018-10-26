package ;

import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Element;
import js.html.VideoElement;
import js.html.Image;
import clm.tracker.ClmTracker;
import Material;
import Log;
import ClmTrackerTools;

class Main {

	private static var _board    :Element;
	private static var _image    :CanvasElement;
	private static var _wireframe:CanvasElement;
	private static var _ctrack   :ClmTracker;
	private static var _requestAnimation:Int;

	public static function main():Void {

		window.addEventListener('DOMContentLoaded',init);

	}

	private static function init():Void {

		Log.init();
		DeviceCamera.init();
		Log.say('Initialize...');

		setup();

		_ctrack = new ClmTracker();

		Material.init(function() {
	
			load();

		});

	}

	private static function setup():Void {

		_image     = document.createCanvasElement();
		_wireframe = document.createCanvasElement();
		_board     = document.getElementById('board');

		_board.appendChild(_image);
		_board.appendChild(_wireframe);
		_board.appendChild(DeviceCamera.getVideo());

	}

	private static function load():Void {

		Log.say('Analyze...');
		// _video.onloadedmetadata = function() {
		// 	start(_video);
		// }
		// var cache:Float = Math.random() * 100 * Math.random();
		// _video.src = 'files/video/video.mp4?$cache';

		DeviceCamera.access(function() {

			start(DeviceCamera.getVideo());

		});

	}

	private static function start(video:VideoElement):Void {

		var width :Int = _image.width  = _wireframe.width  = video.videoWidth;
		var height:Int = _image.height = _wireframe.height = video.videoHeight;
		_board.style.width  = width  + 'px';
		_board.style.height = height + 'px';

		update();

		Log.say('Success');
		_ctrack.reset();
		_ctrack.init(untyped pModel);
		_ctrack.start(_image);

	}

	private static function update(?timeStamp:Float):Void {

		_requestAnimation = window.requestAnimationFrame(update);
		_image.getContext2d().drawImage(DeviceCamera.getVideo(), 0, 0);
		clear(_wireframe);

		if (_ctrack.getCurrentPosition()) {

			var mask:Mask = new Mask(_ctrack.getCurrentPosition());
			// _ctrack.draw(_wireframe);

			// var areaPosi :Position     = [];
			// var posiXList:Array<Float> = [];
			// var posiYList:Array<Float> = [];
			// areaPosi = areaPosi.concat(leftEyebrows).concat(rightEyebrows).concat(leftEye).concat(rightEye);
			// for (posi in areaPosi) posiXList.push(posi[0]);
			// for (posi in areaPosi) posiYList.push(posi[1]);

			// var posiX:{max:Float,min:Float} = getMaxMin(posiXList);
			// var posiY:{max:Float,min:Float} = getMaxMin(posiYList);

			// var minX:Float = posiX.min;
			// var maxX:Float = posiX.max;
			// var minY:Float = posiY.min;
			// var maxY:Float = posiY.max;

			// var ctx:CanvasRenderingContext2D = _wireframe.getContext2d();
			// ctx.beginPath();
			// ctx.fillRect(minX,minY,maxX - minX,maxY - minY);


			var wireframeCtx:CanvasRenderingContext2D = _wireframe.getContext2d();
			// ctx.beginPath();
			// ctx.moveTo(outline[0][0],outline[0][1]);
			// for (path in outline) ctx.lineTo(path[0],path[1]);

			// ctx.lineTo(outline[0][0],outline[0][1]);
			// ctx.fillStyle = '#000';
			// ctx.fill();
			// ctx.closePath();

			// ctx.beginPath();
			// ctx.fillStyle = '#000';
			// ctx.arc(posiList[27][0], posiList[27][1], 1, 0, 2 * Math.PI, true);
			// ctx.fill();

			// ctx.beginPath();
			// ctx.fillStyle = '#000';
			// ctx.arc(posiList[32][0], posiList[32][1], 1, 0, 2 * Math.PI, true);
			// ctx.fill();

			var SIZE_RATIO:Int = 5;

			var leftEyeImage :Image = Material.getImage('leftEye');
			var leftPosiYList:Array<Float> = [];
			for (posi in mask.get('eyeFrameLeft')) leftPosiYList.push(posi[1]);
			var leftPosiY:{max:Float,min:Float} = getMaxMin(leftPosiYList);

			var heightL:Float = (leftPosiY.max - leftPosiY.min) * SIZE_RATIO;
			var ratioL :Float = heightL / leftEyeImage.height;
			var eyeLW  :Float = leftEyeImage.width * ratioL;
			var eyeL   :Array<Float> = mask.get('eyeLeft')[0];
			wireframeCtx.drawImage(leftEyeImage,eyeL[0] - eyeLW*.5,eyeL[1] - heightL*.5,eyeLW,heightL);


			var rightEyeImage :Image = Material.getImage('rightEye');
			var rightPosiYList:Array<Float> = [];
			for (posi in mask.get('eyeFrameRight')) rightPosiYList.push(posi[1]);
			var rightPosiY:{max:Float,min:Float} = getMaxMin(rightPosiYList);

			var heightR:Float = (rightPosiY.max - rightPosiY.min) * SIZE_RATIO;
			var ratioR :Float = heightR / rightEyeImage.height;
			var eyeRW  :Float = rightEyeImage.width * ratioR;
			var eyeR   :Array<Float> = mask.get('eyeRight')[0];
			wireframeCtx.drawImage(rightEyeImage,eyeR[0] - eyeRW*.5,eyeR[1] - heightR*.5,eyeRW,heightR);

		}

	}

	private static function getMaxMin(array:Array<Float>):{max:Float,min:Float} {

		var min:Float = array[0];
		var max:Float = min;
		for (value in array) {
			min = Math.min(min,value);
			max = Math.max(max,value);
		}
		return { max:max,min:min };

	}

	private static function clear(canvas:CanvasElement) {

		canvas.getContext2d().clearRect(0, 0, canvas.width, canvas.height);

	}

	private static function onClmtrackrConverged() {

		document.removeEventListener(clmtrackrConverged, onClmtrackrConverged);
		document.removeEventListener(clmtrackrLost, onClmtrackrLost);

		Log.say('Success');
		window.cancelAnimationFrame(_requestAnimation);

	}

	private static function onClmtrackrLost() {

		document.removeEventListener(clmtrackrConverged, onClmtrackrConverged);
		document.removeEventListener(clmtrackrLost, onClmtrackrLost);

		Log.say('Not found');
		window.cancelAnimationFrame(_requestAnimation);
		_ctrack.stop();

	}

}
