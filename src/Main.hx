package ;

import js.Browser;
import js.Browser.document;
import js.Browser.window;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Element;
import js.html.VideoElement;
import js.html.FileReader;
import js.html.Image;
import js.html.InputEvent;
import js.html.InputElement;
import js.html.URL;
import js.html.MediaStream;
import js.html.MediaStreamConstraints;
import js.jquery.JQuery;
import clm.tracker.ClmTracker;

class Main {

	private static var _log      :Element;
	private static var _board    :Element;
	private static var _image    :CanvasElement;
	private static var _wireframe:CanvasElement;
	private static var _video    :VideoElement;
	private static var _input    :InputElement;

	private static var _leftEye :Image;
	private static var _rightEye:Image;

	private static var _ctrack:ClmTracker;
	private static var _requestAnimation:Int;

	public static function main():Void {

		window.addEventListener('DOMContentLoaded',init);

	}

	private static function init():Void {

		_leftEye = new Image();
		_leftEye.onload = function() {
		}
		_leftEye.src = 'files/img/left.png';

		_rightEye = new Image();
		_rightEye.onload = function() {
		}
		_rightEye.src = 'files/img/right.png';

		_log = document.getElementById('log');

		setup();

		_ctrack = new ClmTracker();
		_video.style.display = 'none';
		// loadImage('files/img/image.png');

		var cache:Float = Math.random() * 100 * Math.random();
		loadVideo('files/video/video.mp4?$cache');

		_input = cast document.querySelector('[data-js="inputimage"]');
		_input.addEventListener('change',onChange);

	}

	private static function onChange(event:InputEvent) {

		window.cancelAnimationFrame(_requestAnimation);

		document.removeEventListener(clmtrackrConverged, onClmtrackrConverged);
		document.removeEventListener(clmtrackrLost, onClmtrackrLost);

		_ctrack.stop();
		clearCanvas(_image);
		clearCanvas(_wireframe);

		var reader:FileReader = new FileReader();
		reader.onload = function() {

			loadImage(reader.result);

		}
		reader.readAsDataURL(_input.files.item(0));

	}

	private static function setup():Void {

		_image     = document.createCanvasElement();
		_wireframe = document.createCanvasElement();
		_video     = untyped new JQuery('<video autoplay playsinline></video>').get(0);
		_board     = document.getElementById('board');

		_board.appendChild(_image);
		_board.appendChild(_wireframe);
		_board.appendChild(_video);

	}

	private static function loop(?timeStamp:Float):Void {

		_requestAnimation = window.requestAnimationFrame(loop);
		_image.getContext2d().drawImage(_video, 0, 0);
		Browser.alert('loop');
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

			var ctx:CanvasRenderingContext2D = _wireframe.getContext2d();
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

			var posiYList:Array<Float> = [];
			for (posi in leftEye) posiYList.push(posi[1]);
			var posiY:{max:Float,min:Float} = getMaxMin(posiYList);

			var height:Float = (posiY.max - posiY.min) * SIZE_RATIO;
			var ratio :Float = (height) / _leftEye.height;

			var rightEyeW:Float = _leftEye.width * ratio;
			ctx.drawImage(_leftEye,posiList[27][0] - rightEyeW*.5,posiList[27][1] - height*.5,rightEyeW,height);


			var posiYList:Array<Float> = [];
			for (posi in rightEye) posiYList.push(posi[1]);
			var posiY:{max:Float,min:Float} = getMaxMin(posiYList);

			var height:Float = (posiY.max - posiY.min) * SIZE_RATIO;
			var ratio :Float = (height) / _rightEye.height;

			var rightEyeW:Float = _rightEye.width * ratio;
			ctx.drawImage(_rightEye,posiList[32][0] - rightEyeW*.5,posiList[32][1] - height*.5,rightEyeW,height);

		}

	}

	private static function getMaxMin(array:Array<Float>):{max:Float,min:Float} {

		var min:Float = array[0];
		var max:Float = array[0];
		for (target in array) {
			min = Math.min(min,target);
			max = Math.max(max,target);
		}

		return { max:max,min:min };

	}

	private static function loadImage(src:String):Void {

		log('Analyze...');
		var image:Image = new Image();
		image.onload = function() {

			draw(image);

		}

		image.src = src;

	}

	private static function loadVideo(src:String):Void {

		log('Analyze...');
		// _video.onloadedmetadata = function() {
		// 	drawVideo(_video);
		// }
		// _video.src = src;

		// var constraints:MediaStreamConstraints = { video:true,audio:false };
		// var getUserMedia = untyped __js__('navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia');

		function onSuccess(stream:MediaStream) {

			_video.onloadedmetadata = function(event) {
				drawVideo(_video);
			}
			_video.srcObject = stream;

		}

		function onError(message:String) {

			Browser.alert(message);
			
		}

		untyped navigator.getUserMedia({ audio:false,video:{ facingMode: { exact: 'environment' } }},onSuccess,onError);

	}

	private static function draw(image:Image):Void {

		var width :Int = _image.width  = _wireframe.width  = image.width;
		var height:Int = _image.height = _wireframe.height = image.height;

		_board.style.width  = width  + 'px';
		_board.style.height = height + 'px';
		_image.getContext2d().drawImage(image, 0, 0, width,height);

		loop();

		document.addEventListener(clmtrackrConverged, onClmtrackrConverged);
		document.addEventListener(clmtrackrLost,onClmtrackrLost);

		_ctrack.reset();
		_ctrack.init(untyped pModel);
		_ctrack.start(_image);

	}

	private static function drawVideo(video:VideoElement):Void {

		var width :Int = _image.width  = _wireframe.width  = video.videoWidth;
		var height:Int = _image.height = _wireframe.height = video.videoHeight;

		_board.style.width  = width  + 'px';
		_board.style.height = height + 'px';
		_image.getContext2d().drawImage(video, 0, 0);

		loop();

		// document.addEventListener(clmtrackrConverged, onClmtrackrConverged);
		// document.addEventListener(clmtrackrLost,onClmtrackrLost);

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

		log('Success');
		window.cancelAnimationFrame(_requestAnimation);

	}

	private static function onClmtrackrLost() {

		document.removeEventListener(clmtrackrConverged, onClmtrackrConverged);
		document.removeEventListener(clmtrackrLost, onClmtrackrLost);

		log('Not found');
		window.cancelAnimationFrame(_requestAnimation);
		_ctrack.stop();

	}

	private static function log(message:String):Void {

		_log.textContent = message;

	}

}
