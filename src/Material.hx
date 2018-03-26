package ;

import haxe.Timer;
import js.html.Image;

using Lambda;

class Material {

	private static var _data  :Map<String,Image>;
	private static var SOURCE_LIST:Map<String,String> = [
		'leftEye'  => 'files/img/left.png',
		'rightEye' => 'files/img/right.png'
	];

	public static function init(?callback:Void->Void):Void {

		_data = new Map();
		loadMaterial(callback);

	}

	private static function loadMaterial(callback:Void->Void):Void {

		var length :Int   = SOURCE_LIST.count();
		var counter:Int   = 0;
		var timer  :Timer = new Timer(10);

		timer.run = function() {
			if (length <= counter) {
				timer.stop();
				callback();
			}
		}

		for (key in SOURCE_LIST.keys()) {

			var image:Image = new Image();
			image.onload = function() {
				_data[key] = image;
				counter++;
			};
			image.src = SOURCE_LIST[key];
			
		}

	}

	public static function getImage(key:String):Image {

		return _data.exists(key) ?  _data[key] : null;

	}

}
