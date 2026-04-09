package util;

#if !macro
import flixel.FlxBasic;
import flixel.util.FlxSort;
#end

class SortUtil
{
	/**
	 * Sort predicate for sorting strings alphabetically.
	 * @param a The first string to compare.
	 * @param b The second string to compare.
	 * @return 1 if `a` comes before `b`, -1 if `b` comes before `a`, 0 if they are equal
	 */
	public static function alphabetically(a:String, b:String):Int
	{
		a = a.toUpperCase();
		b = b.toUpperCase();

		// Sort alphabetically. Yes that's how this works.
		return a == b ? 0 : a > b ? 1 : -1;
	}

	/**
	 * Sort predicate which sorts two strings alphabetically, but prioritizes a specific string first.
	 * Example usage: `array.sort(defaultThenAlphabetical.bind('test'))` will sort the array so that the string 'test' is first.
	 *
	 * @param defaultValue The value to prioritize.
	 * @param a The first string to compare.
	 * @param b The second string to compare.
	 * @return 1 if `a` comes before `b`, -1 if `b` comes before `a`, 0 if they are equal
	 */
	public static function defaultThenAlphabetically(defaultValue:String, a:String, b:String):Int
	{
		if (a == b) return 0;
		if (a == defaultValue) return -1;
		if (b == defaultValue) return 1;
		return alphabetically(a, b);
	}

	/**
	 * Sort predicate which sorts two strings alphabetically, but prioritizes a specific string first.
	 * Example usage: `array.sort(defaultsThenAlphabetical.bind(['test']))` will sort the array so that the string 'test' is first.
	 *
	 * @param defaultValues The values to prioritize.
	 * @param a The first string to compare.
	 * @param b The second string to compare.
	 * @return 1 if `a` comes before `b`, -1 if `b` comes before `a`, 0 if they are equal
	 */
	public static function defaultsThenAlphabetically(defaultValues:Array<String>, a:String, b:String):Int
	{
		if (a == b) return 0;
		if (defaultValues.contains(a) && defaultValues.contains(b))
		{
			// Sort by index in defaultValues
			return defaultValues.indexOf(a) - defaultValues.indexOf(b);
		};
		if (defaultValues.contains(a)) return -1;
		if (defaultValues.contains(b)) return 1;
		return alphabetically(a, b);
	}
}
