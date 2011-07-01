/**
 * Validator class.
 * 
 * @author: Gerald Yeo
 * @version: 0.1
 * @date: Jul 1, 2011
 */
package com.tribal.trike.utils {

	final public class Validators {
		/**
		 * The <code>isEmailValid</code> method validates the email format.
		 * 
		 * @param email String email to validate.
		 * 
		 * @return A value of <code>true</code> for valid;
		 * <code>false</code> if not.
		 */
		static public function isEmailValid(email : String) : Boolean {
			var re : RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return re.test(email);
		}


		/**
		 * The <code>isNRICValid</code> method validates the NRIC format.
		 * 
		 * @param nric String NRIC to validate
		 * 
		 * @return A value of <code>true</code> for valid;
		 * <code>false</code> if not.
		 */
		static public function isNRICValid(nric : String) : Boolean {
			if (nric.length < 9) {
				throw new Error("NRIC has an inappropriate number of characters");
			}

			// The first digit you multiply by 2, second multiply by 7, third by 6, fourth by 5,
			// fifth by 4, sixth by 3, seventh by 2. Then you add the totals together.
			var icParts : Array = nric.split("");
			var alpha : String = icParts[0].toUpperCase();
			var omega : String = icParts[8].toUpperCase();
			icParts[1] *= 2;
			icParts[2] *= 7;
			icParts[3] *= 6;
			icParts[4] *= 5;
			icParts[5] *= 4;
			icParts[6] *= 3;
			icParts[7] *= 2;

			var weight : int = 0;
			for (var i : int = 1; i < 8; ++i) {
				weight += int(icParts[i]);
			}

			// If the first letter of the NRIC starts with T or G, add 4 to the total.
			var offset : int = (alpha == "T" || alpha == "G") ? 4 : 0;

			// Then you divide the number by 11 and get the remainder.
			var temp : int = (offset + weight) % 11;

			// You can get checksum alphabet depending on the IC type (the first letter in the IC)
			var st : Array = ["J", "Z", "I", "H", "G", "F", "E", "D", "C", "B", "A"];
			var fg : Array = ["X", "W", "U", "T", "R", "Q", "P", "N", "M", "L", "K"];

			var checksum : String;
			if (alpha == "S" || alpha == "T") {
				checksum = st[temp];
			} else if (alpha == "F" || alpha == "G") {
				checksum = fg[temp];
			}

			return (omega == checksum);
		}
	}
}
