package com.tribal.trike.utils {

	final public class Validators {
		/**
		 * The <code>isEmailValid</code> method validates the email format.
		 * 
		 * @param email email to validate.
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
		 * @param nric NRIC to validate
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


		/**
		 * The <code>isLeapYear</code> method checks if year is leap year.
		 * 
		 * @param year year to validate
		 * 
		 * @return A value of <code>true</code> for valid;
		 * <code>false</code> if not.
		 */
		static public function isLeapYear(year : int) : Boolean {
			return (year % 4 != 0 ? false : (year % 100 != 0 ? true : (year % 1000 != 0 ? false : true)));
		}


		/**
		 * The <code>isDateValid</code> method checks if year is valid.
		 * 
		 * @param date date to validate
		 * @param format date format to follow
		 * 
		 * @return A value of <code>true</code> for valid;
		 * <code>false</code> if not.
		 */
		static public function isDateValid(date : String, format : String = "dd/mm/yyyy") : Boolean {
			var days : Array = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			var decisionTree : Object = {'m/d/y':{'re':new RegExp(/^(\d{1,2})[.\/-](\d{1,2})[.\/-](\d{2}|\d{4})$/), 'month':1, 'day':2, 'year':3}, 'mm/dd/yy':{'re':new RegExp(/^(\d{1,2})[.\/-](\d{1,2})[.\/-](\d{2})$/), 'month':1, 'day':2, 'year':3}, 'mm/dd/yyyy':{'re':new RegExp(/^(\d{1,2})[.\/-](\d{1,2})[.\/-](\d{4})$/), 'month':1, 'day':2, 'year':3}, 'y/m/d':{'re':new RegExp(/^(\d{2}|\d{4})[.\/-](\d{1,2})[.\/-](\d{1,2})$/), 'month':2, 'day':3, 'year':1}, 'yy/mm/dd':{'re':new RegExp(/^(\d{1,2})[.\/-](\d{1,2})[.\/-](\d{1,2})$/), 'month':2, 'day':3, 'year':1}, 'yyyy/mm/dd':{'re':new RegExp(/^(\d{4})[.\/-](\d{1,2})[.\/-](\d{1,2})$/), 'month':2, 'day':3, 'year':1}, 'd/m/y':{'re':new RegExp(/^(\d{1,2})[.\/-](\d{1,2})[.\/-](\d{2}|\d{4})$/), 'month':2, 'day':1, 'year':3}, 'dd/mm/yy':{'re':new RegExp(/^(\d{1,2})[.\/-](\d{1,2})[.\/-](\d{1,2})$/), 'month':2, 'day':1, 'year':3}, 'dd/mm/yyyy':{'re':new RegExp(/^(\d{1,2})[.\/-](\d{1,2})[.\/-](\d{4})$/), 'month':2, 'day':1, 'year':3}};
			var test : Object = decisionTree[format];
			var year : int, month : int, day : int, date_parts : Array;
			var valid : Boolean = false;

			if (test) {
				date_parts = date.match(test.re);
				if (date_parts) {
					year = date_parts[test.year];
					month = date_parts[test.month];
					day = date_parts[test.day];
					test = (month == 2 && isLeapYear(year) && 29 || days[month] || 0);
					valid = 1 <= day && day <= test;
				}
			}

			return valid;
		}
	}
}
