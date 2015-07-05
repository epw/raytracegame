#declare ACTIVE_ID = 0;

#ifdef (Active)
#default {
	finish {
		ambient rgb<0, 0, 0>
	}
}
#end

#macro Active_Object_Linked (NAME, OBJ, LINK)
#declare ACTIVE_ID = ACTIVE_ID + 1;
#ifndef (Active)

#fopen ActiveCountFile "map.dat" append
#write (ActiveCountFile, concat(" ", NAME, " ", LINK, "\n"))
#fclose ActiveCountFile

#fopen ActiveCountFile "current.dat" append
#write (ActiveCountFile, concat(NAME, "\n"))
#fclose ActiveCountFile

#end
object {
	OBJ
#ifdef (Active)
#if (Active = ACTIVE_ID)
	texture { pigment { color White }
		  finish { ambient 1 }
	  }
#end
#end
}
#end

#macro Active_Object (NAME, OBJ)
Active_Object_Linked (NAME, OBJ, "")
#end