package simpleclick;

typedef ChangelogData =
{
	entrys:Array<ChangelogEntryData>
}

typedef ChangelogEntryData =
{
	version:String,
	changes:Array<ChangelogEntryChangeData>,
	date:String
}

typedef ChangelogEntryChangeData =
{
	change:String,
	type:String,
	?issuenumber:String,
}
