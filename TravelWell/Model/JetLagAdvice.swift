//
//  JetLagAdvice.swift
//  TravelWell
//
//  Created by Callum Graham on 07/12/2021.
//

import Foundation

struct JetLagAdvice{
    var twoDaysBefore = ""
    var oneDayBefore = ""
    var arrival = ""
    var modifierPre = ""
    var mofifierPost1 = ""
    var modifierPost2 = ""
    
    init(easternTravel: Bool){
        
        
        if easternTravel{
            modifierPre = "earlier"
            mofifierPost1 = "falling"
            modifierPost2 = "morning"
        }else{
            modifierPre = "later"
            mofifierPost1 = "staying"
            modifierPost2 = "evening"
        }
        self.twoDaysBefore = "Consider going to sleep 2/3 hours " + modifierPre + " than normal"
        self.oneDayBefore =  "Consider going to sleep 1/2 hours " + modifierPre + " than normal.  Do not leaving packing and other travel preparations to the last minute; if possible, schedule a flight at a time that will not cut short the sleep time before travel"
        self.arrival = "Arrive hydrated and avoid alcohol and caffeine during your journey.  Take a short nap when you reach your destination if possible.  Consider the use of melatonin to promote sleep during your journey if appropriate.  Expect to have trouble " + mofifierPost1 + " asleep until you have become adapted to local time.  For the first few days seek exposure to bright light in the " + modifierPost2 + ".  Caffeine will increase daytime alertness, but avoid it after midday since it may under- mine nighttime sleep.  Consider taking sleep medication until you have adjusted to the local time."
        
    }
    
}


