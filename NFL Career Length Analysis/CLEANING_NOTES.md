This is a short summary of the cleaning and changes made within Excel before importing into SQL server management studio and Tableau.

Assinged every player their state correct state using functions and manual entry.

Calculated "Years_Played" column for players (Year last played - Year drafted = Career length)

Data from 2000 until now updated. 2000 draft is the earliest draft with an active player still playing (Tom Brady). Since this data set was made (2021 draft), all players that are still active and some that just retired have different stats than in the original dataset. To be safe, manually updated all drafts from 2000 until present once the 2022 NFL season concluded.

For "positions" I combined Safety (S), Cornerback (CB) into Defensive Back (DB). Up until 2015, the two positions S and CB were not separate types of DBs, therefore moving foreward they will still be considered combined into the same DB position. I combined Defensive End (DE), Defensive Tackle (DT), and Nose Tackle (NT) into Defensive Line (DL) positions for the same reason. I combined Gaurd (G), Tackle (T), and Center (C) into Offesnsive Line (OL) because these positions are often interchangeable. I combined Inside Linebacker (ILB) and Outside Linebacker (OLB) into general Linebacker (LB). 

I combined Wide Back (WB) with Wide Receiver (WR), as the positions have combined and now only WR is listed as an official NFL position [NFL site](https://operations.nfl.com/learn-the-game/nfl-basics/terms-glossary/).

Kick Returner (KR) was a position drafted for only three times in the NFL data analysis. These players were not relevant during NFL history since they did not play a single NFL game. To simplify the data by not including this irrevelant position, they were changed in the analyst to the position they played in college at the time they were drafted. 

Rick Caswell of the 1976 draft was changed from KR to DB, per [Digital Commons](https://digitalcommons.wku.edu/cgi/viewcontent.cgi?article=8064&context=dlsc_ua_records), he last played DB at Western Kentucky and did not play any snaps in the NFL.

Jamie Harris of the 1985 draft was changed from KR to WR, per [Sports Reference](https://www.sports-reference.com/cfb/players/jamie-harris-2.html), he last played as WR at Oklahoma State but did not play any snaps in the NFL.

Slip Watkins of the 1991 draft was changed from KR to WR, per [Sports Reference](https://www.sports-reference.com/cfb/players/slip-watkins-1.html), he last played as a WR at LSU but did not play any snaps in the NLF.
