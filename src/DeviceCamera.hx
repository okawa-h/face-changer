package ;

import js.Browser;
import js.html.VideoElement;
import js.html.MediaStream;
import js.html.MediaStreamConstraints;
import js.jquery.JQuery;

class DeviceCamera {

	private static var _video:VideoElement;

	public static function init(?callback:Void->Void):Void {

		_video = untyped new JQuery('<video autoplay playsinline></video>').get(0);
		// _video.style.display = 'none';

	}

	public static function getVideo():VideoElement {

		return _video;

	}

	public static function access(callback:Void->Void):Void {

		function onSuccess(stream:MediaStream) {

			_video.onloadedmetadata = function(event) {
				callback();
			}
			_video.srcObject = stream;

		}

		function onError(message:String) {

			Browser.alert(message);
			
		}

		untyped navigator.getUserMedia({
			audio:false,
			video:{
				// facingMode: { exact: 'environment' }
				facingMode:'user'
			}
		},onSuccess,onError);

	}

}
