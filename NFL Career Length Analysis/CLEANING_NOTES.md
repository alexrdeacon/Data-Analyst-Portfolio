This is a short summary of the cleaning and changes made within Excel before importing into SQL server management studio and Tableau.

Original data set used: [Kaggle](https://www.kaggle.com/datasets/cviaxmiwnptr/nfl-draft-19702021)

Every college in the US data copied from [here](https://www.theedadvocate.org/an-a-z-list-of-u-s-colleges-and-universities/)

Assinged every player their state correct state using functions and manual entry.

Calculated "Years_Played" column for players (Year last played - Year drafted = Career length)

Data from 2000 until now updated. 2000 draft is the earliest draft with an active player still playing (Tom Brady). Since this data set was made (2021 draft), all players that are still active and some that just retired have different stats than in the original dataset. To be safe, manually updated all drafts from 2000 until present once the 2022 NFL season concluded.

For "positions" I combined S, CB into DB. Combined DE, DT, NT into DL. Combined G, T, C into OL. Combined ILB, OLB into LB. 

Combined WB with WR, per [Wikipedia](https://en.wikipedia.org/wiki/American_football_positions), a wide receiver who can play running back is called a wide back

Changed KR Rick Caswell of the 1976 draft to DB, per [Digital Commons](https://digitalcommons.wku.edu/cgi/viewcontent.cgi?article=8064&context=dlsc_ua_records), he played DB at Western Kentucky and did not play any snaps in the NFL.

Changed KR Jamie Harris of 1985 draft to WR, per [Sports Reference](https://www.sports-reference.com/cfb/players/jamie-harris-2.html), played as WR at Oklahoma State but did not play in the NFL.

Changed KR Slip Watkins of 1991 draft to WR, per [Sports Reference](https://www.sports-reference.com/cfb/players/slip-watkins-1.html), last played as a WR at LSU before entering the draft. Did not play in the NFL.
