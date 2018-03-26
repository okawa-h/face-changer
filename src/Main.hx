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

class Main {

	private static var _board    :Element;
	private static var _image    :CanvasElement;
	private static var _wireframe:CanvasElement;

	private static var _ctrack:ClmTracker;
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

	private static function update(?timeStamp:Float):Void {

		_requestAnimation = window.requestAnimationFrame(update);
		_image.getContext2d().drawImage(DeviceCamera.getVideo(), 0, 0);
		clearCanvas(_wireframe);

		if (_ctrack.getCurrentPosition()) {

			var posiList:Position = _ctrack.getCurrentPosition();
			// _ctrack.draw(_wireframe);

			var leftEyebrows :Position = [posiList[19],posiList[20],posiList[21],posiList[22]];
			var rightEyebrows:Position = [posiList[18],posiList[17],posiList[16],posiList[15]];
			var leftEye:Position = [
				posiList[23],posiList[63],posiList[24],posiList[64],
				posiList[25],posiList[65],posiList[26],posiList[66],
				posiList[27]
			];
			var rightEye:Position = [
				posiList[30],posiList[68],posiList[29],posiList[67],
				posiList[28],posiList[70],posiList[31],posiList[69],
				posiList[32]
			];

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


			var outline:Position = [
				posiList[0],posiList[1],posiList[2],posiList[3],posiList[4],posiList[5],posiList[6],posiList[7],
				posiList[8],posiList[9],posiList[10],posiList[11],posiList[12],posiList[13],posiList[14],posiList[15],
				posiList[16],posiList[17],posiList[18],posiList[22],posiList[21],posiList[20],posiList[19]
			];

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
			for (posi in leftEye) leftPosiYList.push(posi[1]);
			var leftPosiY:{max:Float,min:Float} = getMaxMin(leftPosiYList);

			var leftH    :Float = (leftPosiY.max - leftPosiY.min) * SIZE_RATIO;
			var leftRatio:Float = (leftH) / leftEyeImage.height;
			var leftEyeW :Float = leftEyeImage.width * leftRatio;
			wireframeCtx.drawImage(leftEyeImage,posiList[27][0] - leftEyeW*.5,posiList[27][1] - leftH*.5,leftEyeW,leftH);

			var rightEyeImage :Image = Material.getImage('rightEye');
			var rightPosiYList:Array<Float> = [];
			for (posi in rightEye) rightPosiYList.push(posi[1]);
			var rightPosiY:{max:Float,min:Float} = getMaxMin(rightPosiYList);

			var rightH    :Float = (rightPosiY.max - rightPosiY.min) * SIZE_RATIO;
			var rightRatio:Float = (rightH) / rightEyeImage.height;
			var rightEyeW :Float = rightEyeImage.width * rightRatio;
			wireframeCtx.drawImage(rightEyeImage,posiList[32][0] - rightEyeW*.5,posiList[32][1] - rightH*.5,rightEyeW,rightH);

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

	private static function load():Void {

		Log.say('Analyze...');
		// _video.onloadedmetadata = function() {
		// 	drawVideo(_video);
		// }
		// var cache:Float = Math.random() * 100 * Math.random();
		// _video.src = 'files/video/video.mp4?$cache';

		DeviceCamera.access(function() {

			drawVideo(DeviceCamera.getVideo());

		});

	}

	private static function drawVideo(video:VideoElement):Void {

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

	private static function clearCanvas(canvas:CanvasElement) {

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
