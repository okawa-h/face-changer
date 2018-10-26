package ;

import clm.tracker.ClmTracker;

using Lambda;

class ClmTrackerTools {

	public function new () {

	}

}

class Mask {

	private var positionMap:Map<String,Position>;

	public function new(posiList:Position):Void {

		positionMap = new Map();

		positionMap['eyebrowsLeft' ] = [posiList[19],posiList[20],posiList[21],posiList[22]];
		positionMap['eyebrowsRight'] = [posiList[18],posiList[17],posiList[16],posiList[15]];

		positionMap['eyeFrameLeft' ] = [
			posiList[23],posiList[63],posiList[24],posiList[64],
			posiList[25],posiList[65],posiList[26],posiList[66],
			posiList[27]
		];
		positionMap['eyeLeft' ] = [posiList[27]];
		positionMap['eyeFrameRight'] = [
			posiList[30],posiList[68],posiList[29],posiList[67],
			posiList[28],posiList[70],posiList[31],posiList[69],
			posiList[32]
		];
		positionMap['eyeRight' ] = [posiList[32]];

		positionMap['outline'] = [
			posiList[0],posiList[1],posiList[2],posiList[3],posiList[4],posiList[5],posiList[6],posiList[7],
			posiList[8],posiList[9],posiList[10],posiList[11],posiList[12],posiList[13],posiList[14],posiList[15],
			posiList[16],posiList[17],posiList[18],posiList[22],posiList[21],posiList[20],posiList[19]
		];

	}

	public function get(key:String):Position {

		return positionMap.exists(key) ? positionMap[key] : null;

	}

}
