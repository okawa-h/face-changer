package ;

import js.Browser.document;
import js.html.ParagraphElement;

class Log {

	private static var _parent:ParagraphElement;

	public static function init():Void {

		_parent = cast document.getElementById('log');

	}

	public static function say(message:String):Void {

		_parent.textContent = message;

	}

}
